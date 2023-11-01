extends Task


func _on_next_button():
	$TaskAnimator.play("outro")
	await $TaskAnimator.animation_finished
	self.completed.emit()
