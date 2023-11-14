extends Control


signal validated
signal invalidated


var waiting := false
var permissions := false


func disable_interactions():
	$MarginContainer2/Button.disabled = true


func _process(_delta):
	if not is_visible_in_tree():
		return
	
	if not waiting and permissions:
		return
	
	if OS.get_name() == "Android" and not permissions:
		invalidated.emit()

	if OS.get_granted_permissions().size() == 1:
		validated.emit()
		waiting = false
		permissions = true


func _on_button_pressed():
	if OS.get_name() != "Android":
		validated.emit()
		waiting = false
		permissions = true
	
	waiting = !OS.request_permission("RECORD_AUDIO")
	permissions = OS.request_permission("RECORD_AUDIO")

	if not waiting and permissions:
		validated.emit()
