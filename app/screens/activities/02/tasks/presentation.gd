extends Task


func set_completed_task():
	self.completed.emit()
