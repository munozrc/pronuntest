extends Node


var information = {
	"age": 7,
	"gender": "M"
}

var app_state = {
	"forest": {
		"activities": [
			{
				"state": "unlocked",
				"score": 0
			}
		]
	}
}


func set_activity_completed(island: String, index: int):
	app_state[island]["activities"][index]["state"] = "completed"
	
	if index + 1 >= app_state[island]["activities"].size():
		print("There are no more activities to unlock")
		return
	
	app_state[island]["activities"][index + 1]["state"] = "unlocked"


func get_activity_state(island: String, index) -> String:
	return app_state[island]["activities"][index]["state"]
