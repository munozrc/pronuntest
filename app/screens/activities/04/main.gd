extends Activity


func _start_outro_animation():
	$TransitionComponent.play("fade_in")
	await $TransitionComponent.animation_finished
	get_tree().change_scene_to_file("res://screens/" + island + ".tscn")


func _on_header_close():
	_start_outro_animation()
