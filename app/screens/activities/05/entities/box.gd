class_name BoxObstacle
extends Node2D


const SPEED := 120
var is_moved := false 


func _process(delta):
	if is_moved:
		global_position.x -= SPEED * delta


func _on_tree_entered():
	is_moved = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
