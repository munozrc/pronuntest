extends Control


func _ready():
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(GLOBAL.menu_scene)
