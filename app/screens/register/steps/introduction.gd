extends Control


signal validated
signal invalidated


func _on_visibility_changed():
	if is_visible_in_tree():
		validated.emit()
