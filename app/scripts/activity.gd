class_name Activity
extends Control


signal finished


@export var taks: Array[PackedScene]
@export var container: Control


var current_task := 0


func _ready():
	self._next_task(0)


func _next_task(index := -1):
	if self.container.get_child_count() == 1:
		var task: Task = self.container.get_child(0)
		task.completed.disconnect(self._on_task_completed)
		task.queue_free()
	
	if self.current_task >= self.taks.size():
		finished.emit()
		return
	
	self.current_task = index if index != -1 else self.current_task + 1
	var task: Task = self.taks[self.current_task].instantiate()
	
	task.completed.connect(self._on_task_completed)
	self.container.add_child(task)


func _on_task_completed():
	self._next_task()
