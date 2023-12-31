extends Control


@onready var buttons = [
	$ScrollContainer/Control/Container/OneButton,
	$ScrollContainer/Control/Container/TwoButton,
	$ScrollContainer/Control/Container/ThreeButton,
	$ScrollContainer/Control/Container/FourButton,
	$ScrollContainer/Control/Container/FiveButton
]


func _ready():
	var max_height = $ScrollContainer/Control.size.x
	$ScrollContainer.scroll_vertical = max_height
	
	var activities: Array = GLOBAL.activities["forest"]
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


func _on_button_back():
	$BackSound.play()
	$TransitionComponent.play("fade_in")
	
	await $TransitionComponent.animation_finished
	get_tree().change_scene_to_packed(GLOBAL.menu_scene)
