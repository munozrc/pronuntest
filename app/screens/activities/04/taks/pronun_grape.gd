extends Task


func _ready():
	disable_interactions()
	$PredictionComponent.request_completed.connect(_on_request_completed)
	$Bottom/RecordButton.save_path = $PredictionComponent.recording


func enable_interactions():
	$Bottom/RecordButton.enable = true


func disable_interactions():
	$Bottom/RecordButton.enable = false


func _on_request_completed(_result, response_code, _headers, body):
	if response_code != HTTPClient.RESPONSE_OK:
		return
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var phonemes: Array = response["phonemes"]
	var score: float = response["score"]
	
	if score == 0 or phonemes.size() == 0:
		$Narrator.stream = load("res://assets/voices/statements/intentalo-nuevo.mp3")
		$Bottom/RecordButton.reset()
		$Narrator.play()
		enable_interactions()
		return
	
	$Narrator.stream = load("res://assets/voices/statements/excelente.mp3")
	$Container/HBoxContainer/ConfettiEffect.start_animation()
	$Narrator.play()


func _on_record_button_fail():
	$Narrator.stream = load("res://assets/voices/statements/manten_presionado.mp3")
	$Narrator.play()


func _on_record_button_finished():
	disable_interactions()
	$PredictionComponent.send_audio()


func _on_record_button_pressed():
	$Narrator.stop()


func _on_confetti_effect_finished():
	$AnimationPlayer.play("outro")
	await $AnimationPlayer.animation_finished
	completed.emit()
