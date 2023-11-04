extends Task


var is_hidden_replay_button := true 


func _ready():
	$Container/ReplayButton.scale = Vector2(0,0)


func _show_replay_button():
	if not is_hidden_replay_button:
		return
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Container/ReplayButton, "scale", Vector2(1,1), 0.2)
	is_hidden_replay_button = false
	$NextButton.show_button()


func _on_next_button():
	$TaskAnimator.play("outro")
	await $TaskAnimator.animation_finished
	self.completed.emit()


func _on_replay_button():
	$TaskAnimator.stop()
	$TaskAnimator.play("intro")
