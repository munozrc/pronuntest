extends Task


@export var sound_good: AudioStreamMP3 


func enable_interactions():
	$ContainerCenter/Box.is_active = true
	$ContainerCenter/BoxSlot.is_active = true
	$ContainerCenter/Hand/Timer.start()


func disable_interactions():
	$ContainerCenter/Box.is_active = false
	$ContainerCenter/BoxSlot.is_active = false
	$ContainerCenter/Hand/HandAnimator.play_backwards("hidden")
	$ContainerCenter/Hand/Timer.stop()


func _on_box_slot_dropped():
	$ContainerCenter/ConfettiEffect.start_animation()
	disable_interactions()
	$Footer.show_button()
	$Narrator.stream = sound_good
	$Narrator.play()


func _on_box_released():
	if not $ContainerCenter/Box.is_active:
		return
	$ContainerCenter/Hand/Timer.start()


func _on_box_selected():
	$ContainerCenter/Hand/Timer.stop()
	$ContainerCenter/Hand/HandAnimator.play_backwards("hidden")


func _on_timer_timeout():
	$ContainerCenter.move_child($ContainerCenter/Hand, -1)
	$ContainerCenter/Hand/HandAnimator.play("drag")


func _on_next_button_pressed():
	$TaskAnimator.play("outro")
	await $TaskAnimator.animation_finished
	completed.emit()
