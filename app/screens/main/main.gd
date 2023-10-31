extends Control


@onready var left_button: TextureButton = $Controls/MarginContainer/HBoxContainer/LeftButton
@onready var right_button: TextureButton = $Controls/MarginContainer/HBoxContainer/RightButton
@onready var islands: Array[Island] = [
	$ScrollContainer/HBoxContainer/Forest,
	$ScrollContainer/HBoxContainer/Beach,
	$ScrollContainer/HBoxContainer/Lighthouse
]


var islands_sky: Array[Color] = [
	Color("#00a7f3"),
	Color("#f1ba00"),
	Color("#7d4aff")
]


var width_island := 720.0
var current_island := 0
var cloud_position := Vector2.ZERO


func _ready():
	left_button.pressed.connect(self._on_left_pressed)
	right_button.pressed.connect(self._on_right_pressed)
	
	current_island = GLOBAL.current_island
	_move_to(0.0)
	
	for island in islands:
		island.selected.connect(_on_island_selected)


func _move_to(time := 0.3):
	var tween: Tween = get_tree().create_tween()
	var new_pos = width_island * current_island
	var background_color = islands_sky[current_island]
	
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($ScrollContainer, "scroll_horizontal", new_pos, time)
	tween.parallel().tween_property($BackgroundColor, "color", background_color, time)
	tween.parallel().tween_property($Clouds, "position", cloud_position, 0.3)

	left_button.modulate.a = 1.0 if current_island > 0 else 0.5
	right_button.modulate.a = 1.0 if current_island < 2 else 0.5


func _on_left_pressed():
	if current_island > 0:
		current_island -= 1
		cloud_position = $Clouds.position - Vector2.LEFT * 12
		_move_to()


func _on_right_pressed():
	if current_island < 2:
		current_island += 1
		cloud_position = $Clouds.position - Vector2.RIGHT * 12
		_move_to()


func _on_island_selected():
	if current_island > islands.size():
		printerr("Island scene is required")
		return
	
	$TransitionComponent.play("fade_in")
	await $TransitionComponent.animation_finished
	
	var target = islands[current_island].scene
	GLOBAL.current_island = current_island
	get_tree().change_scene_to_packed(target)
