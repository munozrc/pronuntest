extends Task

@onready var predict: PredictionComponent = $PredictionComponent

var record_bus_index: int
var record_effect: AudioEffectRecord


func _ready():
	record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	
	$Container/RecordButton.button_down.connect(_on_record_pressed)
	$Container/RecordButton.button_up.connect(_on_record_released)
	
	predict.request_completed.connect(_on_request_completed)
	
	print(AudioServer.get_input_device_list())


func _on_record_pressed():
	record_effect.set_recording_active(true)


func _on_record_released():
	record_effect.set_recording_active(false)
	
	var recording: AudioStreamWAV = record_effect.get_recording()
	recording.save_to_wav($PredictionComponent.recording)
	predict.send_audio()


func _on_request_completed(_result, response_code, _headers, body):
	if response_code != HTTPClient.RESPONSE_OK:
		return
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var phoneme = response["phoneme"]["class"]
	var percentage = response["phoneme"]["percentage"]
	
	print("Phoneme = " + phoneme)
	print("Percentage = " + str(percentage) + "%\n")
	
	if phoneme != "a":
		return

	$Container/Player/PlayerAnimator.play("jump")
	$NextButton.show_button()


func _on_button_pressed():
	$AudioStreamPlayer.stream = record_effect.get_recording()
	$AudioStreamPlayer.play()
