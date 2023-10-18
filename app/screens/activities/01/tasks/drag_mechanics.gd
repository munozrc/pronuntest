extends Task


func _ready():
	$Container/Box.is_active = false
	$Container/Slot.is_active = false


func activate_items():
	$Container/Box.is_active = true
	$Container/Slot.is_active = true
	$Hand/Timer.start()


func _on_slot_dropped():
	$NextButton.show_button()
	$Hand/Timer.stop()
	$Container/Box.is_active = false
	$Container/Slot.is_active = false


func _on_timer_timeout():
	$Hand/HandAnimator.play("drag")


func _on_box_selected():
	$Hand/HandAnimator.play("hidden")
	$Hand/Timer.stop()


func _on_box_released():
	if $Container/Slot.is_active:
		$Hand/Timer.start()


func _on_animation_finished(anim_name):
	if anim_name == "outro":
		self.completed.emit()


func _on_next_button_up():
	$AnimationPlayer.play("outro")
