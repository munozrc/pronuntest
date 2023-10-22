extends Control


@onready var buttons = [
	$ScrollContainer/Control/Container/OneButton,
	$ScrollContainer/Control/Container/TwoButton
]


func _ready():
	var max_height = $ScrollContainer/Control.size.x
	$ScrollContainer.scroll_vertical = max_height
	
	for button in buttons:
		button.pressed.connect(self._on_button_pressed)


func _on_button_pressed(activity: PackedScene):
	$TransitionComponent.play("cloud_in")
	await $TransitionComponent.animation_finished
	get_tree().change_scene_to_packed(activity)
