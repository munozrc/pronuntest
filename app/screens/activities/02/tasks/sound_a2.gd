extends Task


@onready var short_sound = preload("res://assets/voices/statements/manten_presionado.mp3")
@onready var fail_sound_narrator = preload("res://assets/voices/statements/intentalo-nuevo.mp3")
@onready var ok_sound_narrator = preload("res://assets/voices/statements/bien_hecho.mp3")


func _ready():
	disable_interactions()
	$PredictionComponent.request_completed.connect(_on_request_completed)
	$Container/RecordButton.save_path = $PredictionComponent.recording


func start_statement_animation():
	$TaskAnimator.stop()
	$TaskAnimator.play("statement")
	disable_interactions()


func enable_interactions():
	$Container/RecordButton.enable = true


func disable_interactions():
	$Container/RecordButton.enable = false


func _on_request_completed(_result, response_code, _headers, body):
	if response_code != HTTPClient.RESPONSE_OK:
		return
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var phonemes: Array = response["phonemes"]
	var score: float = response["score"]
	
	if score == 0 or phonemes.size() == 0:
		$Narrator.stream = fail_sound_narrator
		$Container/RecordButton.reset()
		$Narrator.play()
		enable_interactions()
		return
	
	$Narrator.stream = ok_sound_narrator
	$Container/ConfettiEffect.start_animation()
	$Narrator.play()


func _on_record_fail():
	$Narrator.stream = short_sound
	$Narrator.play()


func _on_record_finished():
	disable_interactions()
	$PredictionComponent.send_audio()


func _on_record_button_pressed():
	$Narrator.stop()


func _on_confetti_effect_finished():
	$TaskAnimator.play("outro")
	await $TaskAnimator.animation_finished
	self.completed.emit()
