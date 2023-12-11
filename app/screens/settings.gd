extends Control


@onready var server_field = $Container/HBoxContainer/ServerField/VBoxContainer/FieldContainer/LineEdit


func _ready():
	server_field.text = GLOBAL.information.server


func _on_back_pressed():
	get_tree().change_scene_to_packed(GLOBAL.menu_scene)


func _on_save_pressed():
	GLOBAL.information.server = server_field.text
	GLOBAL.save_user_data()
