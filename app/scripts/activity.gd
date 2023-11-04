class_name Activity
extends Control


signal finished


@export var tasks: Array[PackedScene]
@export var container: Control
@export var island: String
@export var index_island: int = 0


var current_task := 0
var current_state := "locked"
var increment_value := 0.0


func _ready():
	_next_task(0)
	
	if tasks.size() > 0:
		increment_value = 100.0 / tasks.size()
	
	if not island.is_empty():
		current_state = GLOBAL.get_activity_state(island, index_island)


func _next_task(index := -1):
	if container.get_child_count() == 1:
		var task: Task = container.get_child(0)
		task.completed.disconnect(_on_task_completed)
		task.queue_free()
	
	current_task = index if index != -1 else current_task + 1
	
	if current_task >= tasks.size():
		finished.emit()
		return
	
	var task: Task = tasks[current_task].instantiate()
	task.completed.connect(_on_task_completed)
	container.add_child(task)


func _on_task_completed():
	_next_task()
