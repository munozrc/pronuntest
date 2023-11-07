class_name DroppableArea
extends Node2D


signal dropped(item: DraggableItem)
signal failed(item: DraggableItem)


@export var content: String
@export var is_active:= true
@export var area: Area2D


var _item : DraggableItem = null


func _ready():
	area.area_entered.connect(self._on_area_entered)
	area.area_exited.connect(self._on_area_exited)


func _input(event):
	if (
		not event is InputEventScreenTouch or 
		not event.is_released() or
		not is_active or 
		not _item
	):
		return
	
	if content != _item.content:
		failed.emit(_item)
		_item = null
		return
	
	var current_pos = global_position
	_item.set_origin(current_pos)
	dropped.emit(_item)
	_item = null


func _on_area_entered(object: Area2D):
	if not object.get_parent() is DraggableItem:
		return
	_item = object.get_parent()


func _on_area_exited(object: Area2D):
	if not object.get_parent() is DraggableItem:
		return
	_item = null
