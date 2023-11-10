extends Task


func _ready():
	$CenterContainer/Boat.active = false


func start_interactions():
	$TaskAnimator.play("statement")
	await $TaskAnimator.animation_finished
	$CenterContainer/Boat.active = true


func _on_area_2d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	$CenterContainer/Goal/ConfettiEffect.start_animation()
	$Narrator.stream = load("res://assets/voices/statements/excelente.mp3")
	$Narrator.play()
	body.active = false


func _on_confetti_effect_finished():
	$TaskAnimator.play("outro")
	await $TaskAnimator.animation_finished
	completed.emit()
