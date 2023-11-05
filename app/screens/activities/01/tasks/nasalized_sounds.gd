extends Task


func _on_button_next_pressed():
	$TaskAnimator.play("outro")
	await $TaskAnimator.animation_finished
	self.completed.emit()
