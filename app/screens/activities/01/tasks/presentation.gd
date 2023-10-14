extends Task


func _on_next_button_up():
	self.completed.emit()
