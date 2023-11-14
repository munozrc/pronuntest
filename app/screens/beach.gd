extends Control


func _on_button_back_pressed():
	$TransitionComponent.play("fade_in")
	await $TransitionComponent.animation_finished
	get_tree().change_scene_to_packed(GLOBAL.menu_scene)
