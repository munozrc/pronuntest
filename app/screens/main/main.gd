extends Control


@onready var left_button: TextureButton = $Controls/MarginContainer/HBoxContainer/LeftButton
@onready var right_button: TextureButton = $Controls/MarginContainer/HBoxContainer/RightButton


var width_island := 720.0
var current_island := 0:
	get: return current_island
	set(value):
		current_island = value
		self._move_to()


func _ready():
	left_button.pressed.connect(self._on_left_pressed)
	right_button.pressed.connect(self._on_right_pressed)
	
	current_island = 0


func _move_to():
	var tween: Tween = get_tree().create_tween()
	var new_pos = width_island * current_island
	
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($ScrollContainer, "scroll_horizontal", new_pos, 0.3)

	left_button.modulate.a = 1.0 if current_island > 0 else 0.5
	right_button.modulate.a = 1.0 if current_island < 1 else 0.5


func _on_left_pressed():
	if current_island > 0:
		current_island -= 1


func _on_right_pressed():
	if current_island < 1:
		current_island += 1
