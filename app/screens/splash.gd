extends Control


func _ready():
#	await $AnimationPlayer.animation_finished
	if GLOBAL.information.name == "":
		get_tree().change_scene_to_file("res://screens/register/register.tscn")
		return
	
	get_tree().change_scene_to_packed(GLOBAL.menu_scene)
