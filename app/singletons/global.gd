extends Node


var information = {
	"age": 7,
	"gender": "M"
}

var activities = {
	"forest": [
		{
			"state": "unlocked",
			"score": 0
		}
	]
}


func set_activity_completed(island: String, index: int):
	activities[island][index]["state"] = "completed"
	
	if index + 1 >= activities[island].size():
		print("There are no more activities to unlock")
		return
	
	activities[island][index + 1]["state"] = "unlocked"


func get_activity_state(island: String, index) -> String:
	return activities[island][index]["state"]
