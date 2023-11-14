extends Control


signal validated
signal invalidated


@onready var title: Label = $MarginContainer/VBoxContainer/VBoxContainer/Title


var question = "¿Qué edad tiene _@_=...?"
var group: ButtonGroup


func _ready():
	group = $MarginContainer/VBoxContainer/VBoxContainer2/Number/Button.button_group
	
	for button in group.get_buttons():
		button.pressed.connect(_on_button_pressed)


func _on_visibility_changed():
	if (
		not is_visible_in_tree() or 
		not title is Label
	):
		return
	
	var child_name = GLOBAL.information.name
	title.text = question.replace("_@_=...", child_name)
	
	if group.get_pressed_button() == null:
		invalidated.emit()
	else:
		validated.emit()


func _on_button_pressed():
	var new_value = int(group.get_pressed_button().text)
	GLOBAL.information.age = new_value
	validated.emit()
