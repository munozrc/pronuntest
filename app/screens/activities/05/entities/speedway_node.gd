extends Node2D

@export var speedway: Sprite2D

func _ready():
	speedway.hide()

func _on_visible_on_screen_notifier_2d_screen_entered():
	speedway.show()


func _on_visible_on_screen_notifier_2d_screen_exited():
	speedway.hide()

