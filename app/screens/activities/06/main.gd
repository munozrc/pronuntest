extends Activity


func _start_outro_animation():
	$TransitionComponent.play("fade_in")
	await $TransitionComponent.animation_finished
	get_tree().change_scene_to_file("res://screens/forest.tscn")


func _on_header_close():
	_start_outro_animation()


func _on_finished():
	if self.current_state == "unlocked":
		GLOBAL.set_activity_completed(island, index_island)
	
	_start_outro_animation()
