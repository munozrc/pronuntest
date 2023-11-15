extends Node2D


signal crashed
signal won


func move_animation():
	$AnimationPlayer.play("move")


func reset_animation():
	$AnimationPlayer.play("RESET")


func _on_area_obstacles_entered(area: Area2D):
	if area.get_parent() is BoxObstacle:
		crashed.emit()
		$AnimationPlayer.play("crash")
		return
	
	won.emit()
