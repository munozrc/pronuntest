extends Control

@onready var container = $Container

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		return
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var nearest_start_position = round((container.position.x) / 720) * 720
	tween.tween_property(container, "position", Vector2(nearest_start_position, 0), 0.2)

func handle_drag(event: InputEventScreenDrag):
	var touch_points = container.position.x + event.relative.x
	if touch_points <= 0 && touch_points >= -720:
		container.position.x = touch_points
