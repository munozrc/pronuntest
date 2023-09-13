extends Control

@onready var record_button_animator = $RecordButton/AnimationPlayer
@onready var record_button_voice = $RecordButton/EllipseVoice
@onready var phoneme = $VBoxContainer/Phoneme
@onready var pronunciation = $VBoxContainer/Pronunciation
@onready var record_button = $RecordButton
@onready var record_stream = $RecordStream
@onready var request = $HTTPRequest
@export var url = "http://127.0.0.1:5000/api/"

const MIN_DB: int = 80

var record_bus_index: int
var record_effect: AudioEffectRecord
var recording: AudioStreamWAV
var volume_samples: Array = []
var active_visualizer: bool = false

func _ready() -> void:
	record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)

func _process(_delta):
	var sample = AudioServer.get_bus_peak_volume_right_db(record_bus_index, 0)
	volume_samples.push_front(sample)
	
	while volume_samples.size() > 8:
		volume_samples.pop_back()
	
	var normalize_sample = average_array(volume_samples)
	var energy = clampf(db_to_linear(normalize_sample)*MIN_DB, 0, 1)
	
	if active_visualizer:
		record_button_voice.scale = Vector2(energy, energy)

func _on_record_button_button_down():
	record_button_animator.play("press_button")
	record_effect.set_recording_active(true)
	active_visualizer = true
	print("press")

func _on_record_button_button_up():
	record_effect.set_recording_active(false)
	
	record_button_voice.scale = Vector2.ZERO
	record_button_animator.play_backwards("press_button")
	
	recording = record_effect.get_recording()
	recording.save_to_wav("user://recording.wav")

	var file = FileAccess.open("user://recording.wav", FileAccess.READ)
	var content = file.get_buffer(file.get_length())
	file.close()
	
	var headers = [	"Content-Type: multipart/form-data; boundary=\"boundary\""]
	var body = PackedByteArray()

	body.append_array("--boundary\r\n".to_utf8_buffer())
	body.append_array("Content-Disposition: form-data; name=\"recording\"; filename=\"recording.wav\"\r\n".to_utf8_buffer())
	body.append_array("Content-Type: audio/wav\r\n\r\n".to_utf8_buffer())
	body.append_array(content)
	body.append_array("\r\n--boundary--\r\n".to_utf8_buffer())
	
	request.request_raw(url, headers, HTTPClient.METHOD_POST, body)
	active_visualizer = false
	print("release")


func _on_http_request_request_completed(_result, response_code, _headers, body):
	if response_code != HTTPClient.RESPONSE_OK:
		phoneme.text = "Unknown"
		pronunciation.text = "Unknown"
		return
	
	var data = JSON.parse_string(body.get_string_from_utf8())
	phoneme.text = data["phoneme"]["class"].capitalize()
	pronunciation.text = data["pronunciation"].capitalize()
	print(data)
	
func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
