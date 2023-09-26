extends ScrollContainer

@onready var timer: Timer = $SwipeTimeout

var max_diagonal_slope:= 1.3
var swipe_start_pos = Vector2.ZERO
var swipe_canceled := false
var current_item := 0

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.is_pressed():
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)
		
	if not event.is_pressed():
		_handle_touch()

func _start_detection(pos: Vector2):
	swipe_start_pos = pos
	swipe_canceled = false
	timer.start()

func _end_detection(pos: Vector2):
	timer.stop()
	var direction = (pos - swipe_start_pos).normalized()
	if abs(direction.x) + abs(direction.y) >= max_diagonal_slope:
		return
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	current_item = (-sign(direction.x) + round(scroll_horizontal / 500.0)) * 500.0
	tween.tween_property(self, "scroll_horizontal", current_item, 0.3)

func _handle_touch():
	if swipe_canceled == false:
		return
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	current_item = round(scroll_horizontal / 500.0) * 500.0
	tween.tween_property(self, "scroll_horizontal", current_item, 0.3)

func _on_swipe_timeout_timeout():
#	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
#	current_item = round(scroll_horizontal / 500.0) * 500.0
#	tween.tween_property(self, "scroll_horizontal", current_item, 0.2)
	swipe_canceled = true
