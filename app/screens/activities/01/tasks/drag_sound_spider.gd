extends Task


@onready var boxs = [
	$Container/Box,
	$Container/Box2
]

@onready var options = [
	[
		"abeja",
		preload("res://assets/voices/words/abeja.mp3")
	],
	[
		"araña",
		preload("res://assets/voices/words/araña.mp3")
	]
]


func _ready():
	for i in range(boxs.size()):
		var option = options[randi() % options.size()]
		boxs[i].content = option[0]
		boxs[i].audio = option[1]
		boxs[i].is_active = false
		options.erase(option)


func activate_items():
	for i in range(boxs.size()):
		boxs[i].is_active = true


func disable_items():
	for i in range(boxs.size()):
		boxs[i].is_active = false


func _on_slot_dropped():
	$NextButton.show_button()
	$Container/Slot.start_animation()
	self.disable_items()


func _on_next_button_up():
#	$AnimationPlayer.play("outro")
	pass
