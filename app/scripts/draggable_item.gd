class_name DraggableItem
extends Node2D


signal selected
signal released


@export var content: String
@export var is_active:= true
@export var button: TouchScreenButton


var _is_selected := false
var _origin := Vector2.ZERO


func _ready():
	button.pressed.connect(_on_button_pressed)
	button.released.connect(_on_button_released)
	self._origin = global_position


func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var new_pos = mouse_pos if _is_selected else _origin
	var speed = 25 if _is_selected else 10
	
	global_position = lerp(global_position, new_pos, speed * delta)


func _on_button_pressed():
	_is_selected = true
	selected.emit()


func _on_button_released():
	_is_selected = false
	released.emit()


func set_origin(pos: Vector2):
	_is_selected = false
	is_active = false
	_origin = pos
