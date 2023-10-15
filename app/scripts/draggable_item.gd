class_name DraggableItem
extends Node2D


signal selected
signal released


@export var area: Area2D
@export var content: String
@export var is_active:= true


var _is_draggable := false
var _is_selected := false
var _origin := Vector2.ZERO


func _ready():
	self.area.mouse_entered.connect(self._on_mouse_entered)
	self.area.mouse_exited.connect(self._on_mouse_exited)
	self._origin = global_position

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var new_pos = mouse_pos if self._is_selected else self._origin
	var speed = 25 if self._is_selected else 10
	
	global_position = lerp(global_position, new_pos, speed * delta)

func _input(event):
	if (
		not event is InputEventScreenTouch or 
		not self._is_draggable or 
		not self.is_active
	):
		return
	
	if event.is_released():
		self._is_selected = false
		self.released.emit()
		return
	
	self._is_selected = true
	selected.emit()


func _on_mouse_entered():
	self._is_draggable = true


func _on_mouse_exited():
	self._is_draggable = false


func set_origin(pos: Vector2):
	self._is_selected = false
	self._origin = pos
