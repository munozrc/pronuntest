extends Control


@onready var progressbar = $Toolbar/MarginContainer/HBoxContainer/ProgressBar 
@onready var back_button = $Toolbar/MarginContainer/HBoxContainer/BackButton
@onready var steps := [
	$Steps/Introduction,
	$Steps/Name,
	$Steps/Age,
	$Steps/Permissions
]


var current_step := -1
var progressbar_step := 0.0
var finished: = false
var tween: Tween


func _ready():
	progressbar_step =  100.0 / (steps.size() + 1.0)
	
	for step in steps:
		step.validated.connect(_on_validated_step)
		step.invalidated.connect(_on_invalidated_step)
	
	show_next_step()


func show_next_step():
	current_step += 1
	_increment(progressbar_step)
	show_step()


func show_before_step():
	current_step -= 1
	_increment(-progressbar_step)
	show_step()


func show_step():
	for step in steps:
		step.hide()
	
	$Footer/ContinueButton.disabled = true
	steps[current_step].show()


func _increment(new_value: float):
	var value = progressbar.value + new_value
	tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(progressbar, "value",  value, 0.2)
	tween.tween_callback(_on_animation_finished)


func _on_validated_step():
	$Footer/ContinueButton.disabled = false


func _on_invalidated_step():
	$Footer/ContinueButton.disabled = true


func _on_continue_button_up():
	$Sound.play()
	
	if current_step == steps.size() - 1:
		_increment(progressbar_step)
		back_button.disabled = true
		_on_invalidated_step()
		
		if steps[current_step].has_method("disable_interactions"):
			steps[current_step].disable_interactions()
		
		finished = true
		GLOBAL.save_user_data()
		return
	
	show_next_step()


func _on_animation_finished():
	if not finished:
		return
	
	get_tree().change_scene_to_packed(GLOBAL.menu_scene)


func _on_back_button_up():
	if current_step == 0:
		return
	show_before_step()
