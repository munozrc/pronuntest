class_name Activity
extends Control


signal finished


@export var taks: Array[PackedScene]
@export var container: Control
@export var island: String
@export var index_island: int = 0


var current_task := 0
var current_state := "locked"


func _ready():
	_next_task(0)
	
	if not island.is_empty():
		current_state = GLOBAL.get_activity_state(island, index_island)


func _next_task(index := -1):
	if container.get_child_count() == 1:
		var task: Task = container.get_child(0)
		task.completed.disconnect(_on_task_completed)
		task.queue_free()
	
	if current_task + 1 >= taks.size():
		finished.emit()
		return
	
	current_task = index if index != -1 else current_task + 1
	var task: Task = taks[current_task].instantiate()
	
	task.completed.connect(_on_task_completed)
	container.add_child(task)


func _on_task_completed():
	_next_task()
