extends Control


signal validated
signal invalidated


func _on_name_text_changed(new_text: String):
	var parse_text = new_text.strip_edges()
	GLOBAL.information.name = parse_text
	
	if parse_text != "":
		validated.emit()
	else:
		invalidated.emit()


func _on_visibility_changed():
	if (
		is_visible_in_tree() and
		GLOBAL.information.name != ""
	):
		validated.emit()
	
