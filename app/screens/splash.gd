extends Control


func _ready():
	if GLOBAL.information.name == "":
		get_tree().change_scene_to_file("res://screens/register/register.tscn")
		return
	
	get_tree().change_scene_to_packed(GLOBAL.menu_scene)
