extends Activity


func _on_header_close():
	get_tree().change_scene_to_file("res://screens/" + island + ".tscn")
