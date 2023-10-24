class_name Island
extends Control


signal selected


@export var button: TextureButton = null
@export var scene: PackedScene = null


func _ready():
	if button != null:
		button.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	if scene == null:
		return
	selected.emit()
