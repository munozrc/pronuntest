extends Node2D


signal finished


func start_animation():
	$AnimationPlayer.stop()
	$AudioStreamPlayer.play()
	
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	finished.emit()
