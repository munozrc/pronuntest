extends Task


func _ready():
	$Container/Box.is_active = false
	$Container/Slot.is_active = false


func activate_items():
	$Container/Box.is_active = true
	$Container/Slot.is_active = true
	$Container/Hand/Timer.start()

func _on_slot_dropped():
	print("Finished")
	$NextButton.show_button()


func _on_next_button_up():
	print("Finished")


func _on_timer_timeout():
	$Container/Hand/HandAnimator.play("drag")


func _on_box_selected():
	$Container/Hand/HandAnimator.play("hidden")
	$Container/Hand/Timer.stop()
