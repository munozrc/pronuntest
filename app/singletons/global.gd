extends Node


var information = {
	"name": "",
	"gender": "M",
	"age": 0,
}

var activities = {
	"forest": [
		{
			"state": "completed",
			"score": 0
		},
		{
			"state": "completed",
			"score": 0
		},
		{
			"state": "completed",
			"score": 0
		},
		{
			"state": "unlocked",
			"score": 0
		}
	]
}

var current_island := 0
var menu_scene := preload("res://screens/menu.tscn")


func _ready():
	var load_user_info = _load_json_file("user://info.json")

	for user_info in information:
		if load_user_info.has(user_info):
			information[user_info] = load_user_info[user_info]


func save_user_data():
	_save_json_file("user://info.json", information)


func _load_json_file(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		print(file_path + " is not founded")
		return {}
	
	var data_file = FileAccess.open(file_path, FileAccess.READ)
	var parse_result = JSON.parse_string(data_file.get_as_text())
	
	data_file.close()
	
	if not parse_result is Dictionary:
		print(file_path + " is not a dictionary")
		return {}
	
	return parse_result


func _save_json_file(file_path: String, data: Dictionary):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))


func set_activity_completed(island: String, index: int):
	activities[island][index]["state"] = "completed"
	
	if index + 1 >= activities[island].size():
		print("There are no more activities to unlock")
		return
	
	activities[island][index + 1]["state"] = "unlocked"


func get_activity_state(island: String, index) -> String:
	return activities[island][index]["state"]
