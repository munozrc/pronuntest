extends Node


var information = {
	"name": "",
	"gender": "",
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
			"state": "completed",
			"score": 0
		}
	]
}

var current_island := 0
var menu_scene := load("res://screens/menu.tscn")


func set_activity_completed(island: String, index: int):
	activities[island][index]["state"] = "completed"
	
	if index + 1 >= activities[island].size():
		print("There are no more activities to unlock")
		return
	
	activities[island][index + 1]["state"] = "unlocked"


func get_activity_state(island: String, index) -> String:
	return activities[island][index]["state"]
