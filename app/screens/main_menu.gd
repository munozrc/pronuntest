extends Control

@onready var scroll = $SlidingMenu
@onready var btn_left = $SliderControls/CenterContainer/HBoxContainer/LeftButton
@onready var btn_right = $SliderControls/CenterContainer/HBoxContainer/RightButton
@onready var btn_sound_effect = $SliderControls/AudioStreamPlayer

var current_island: int = 0
var separation: float = 100.0
var island_width: float = 720.0

func _ready():
	_show_slider_controls()

func _show_slider_controls():
	btn_left.modulate.a = 1.0 if current_island > 0 else 0.5
	btn_right.modulate.a = 1.0 if current_island < 1 else 0.5

func _change_current_island():
	btn_sound_effect.play()
	_show_slider_controls()
	
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var pos_x = (island_width + separation) * current_island
	tween.tween_property(scroll, "scroll_horizontal", pos_x, 0.3)

func _on_left_button_pressed():
	if current_island == 0:
		return
	
	current_island-=1
	_change_current_island()

func _on_right_button_pressed():
	if current_island == 1:
		return
	
	current_island+=1
	_change_current_island()
