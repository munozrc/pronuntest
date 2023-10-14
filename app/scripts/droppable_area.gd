class_name DroppableArea
extends Node2D


signal dropped
signal failed


@export var content: String
@export var is_active:= true
@export var area: Area2D


var _item : DraggableItem = null


func _ready():
	self.area.area_entered.connect(self._on_area_entered)
	self.area.area_exited.connect(self._on_area_exited)


func _input(event):
	if (
		not event is InputEventScreenTouch or 
		not event.is_released() or
		not is_active or 
		not _item
	):
		return
	
	if self.content != self._item.content:
		failed.emit()
		return
	
	var current_pos = self.global_position
	self._item.set_origin(current_pos)
	self._item = null
	dropped.emit()


func _on_area_entered(object: Area2D):
	if not object.get_parent() is DraggableItem:
		print("Failed")
		return
	self._item = object.get_parent()


func _on_area_exited(object: Area2D):
	if not object.get_parent() is DraggableItem:
		return
	self._item = null
