extends Node2D


func start_animation():
	$AnimationPlayer.stop()
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("fade_in")
