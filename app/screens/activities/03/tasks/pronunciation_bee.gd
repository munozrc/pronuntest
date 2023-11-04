extends Control


@onready var predict: PredictionComponent = $PredictionComponent
@onready var letters := [
	$HBoxContainer/Letter2,
	$HBoxContainer/Letter4
]


var record_bus_index : int
var record_effect : AudioEffectRecord
var pattern := "ai"


func _ready():
	record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	
	_change_letter_color(Color("fff"), 0)
	_change_letter_color(Color("fff"), 1)
	
	$RecordButton.button_down.connect(_on_record_pressed)
	$RecordButton.button_up.connect(_on_record_released)
	
	predict.request_completed.connect(_on_request_completed)


func _on_record_pressed():
	record_effect.set_recording_active(true)
	_change_letter_color(Color("fff"), 0)
	_change_letter_color(Color("fff"), 1)


func _on_record_released():
	record_effect.set_recording_active(false)
	
	var recording: AudioStreamWAV = record_effect.get_recording()
	recording.save_to_wav($PredictionComponent.recording)
	predict.send_audio()


func _change_letter_color(new_color: Color, index: int):
	var parent: Panel = letters[index]
	var letter: Label = parent.get_child(0)
	letter.set("theme_override_colors/font_color", new_color)


func _on_request_completed(_result, response_code, _headers, body):
	if response_code != HTTPClient.RESPONSE_OK:
		return
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var phonemes: Array = response["phonemes"]
	var score: float = response["score"]
	var index: int = 0
	
	if score == 0:
		_change_letter_color(Color("FF6969"), 0)
		_change_letter_color(Color("FF6969"), 1)
		return
	
	for phoneme in phonemes:
		if phoneme["class"] != pattern[index]:
			_change_letter_color(Color("FF6969"), index)
			continue
		
		if phoneme["percentage"] < 33.33:
			_change_letter_color(Color("FF6969"), index)
		elif phoneme["percentage"] < 66.66:
			_change_letter_color(Color("F4CE14"), index)
		else:
			_change_letter_color(Color("A2FF86"), index)
		
		index+=1
	
	print(response)
