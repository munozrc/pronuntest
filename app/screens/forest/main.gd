extends Control


@onready var buttons = [
	$ScrollContainer/Control/Container/OneButton,
	$ScrollContainer/Control/Container/TwoButton
]


func _ready():
	var max_height = $ScrollContainer/Control.size.x
	$ScrollContainer.scroll_vertical = max_height
	
	var activities: Array = GLOBAL.app_state["forest"]["activities"]
	var max_activites: int = activities.size()
	var index := 0
	
	for button in buttons:
		button.pressed.connect(self._on_button_pressed)
		
		if index < max_activites:
			var state = activities[index]["state"]
			button.change_state(state)
		
		index+=1


func _on_button_pressed(activity: PackedScene):
	$TransitionComponent.play("fade_in")
	await $TransitionComponent.animation_finished
	get_tree().change_scene_to_packed(activity)
