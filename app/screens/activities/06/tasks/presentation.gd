extends Task


func _on_next_button_up():
	$AnimationPlayer.play("outro")


func _on_animation_finished(anim_name):
	if anim_name == "outro":
		self.completed.emit()
