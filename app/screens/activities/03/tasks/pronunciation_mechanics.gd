extends Task


func _ready():
	$PredictionComponent.request_completed.connect(_on_request_completed)
	$RecordButton.save_path = $PredictionComponent.recording


func enable_interactions():
	$RecordButton.enable = true


func disable_insteractions():
	$RecordButton.enable = false


func _on_request_completed(_result, response_code, _headers, body):
	if response_code != HTTPClient.RESPONSE_OK:
		return
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var phoneme = response["phoneme"]["class"]
	var percentage = response["phoneme"]["percentage"]
	
	print("Phoneme = " + phoneme)
	print("Percentage = " + str(percentage) + "%\n")
	
	if phoneme != "a":
		enable_interactions()
		$Container/Player/PlayerAnimator.play("RESET")
		return
	
	$Container/Player/PlayerAnimator.play("jump")
	$NextButton.show_button()
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($RecordButton, "modulate", Color(255, 255, 255, 0), 1)


func _on_record_finished():
	$PredictionComponent.send_audio()
	disable_insteractions()
