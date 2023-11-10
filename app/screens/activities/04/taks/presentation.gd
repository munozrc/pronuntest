extends Task


func _ready():
	$CenterContainer/Boat.active = false


func start_interactions():
	$TaskAnimator.play("statement")
	await $TaskAnimator.animation_finished
	$CenterContainer/Boat.active = true


func _on_area_2d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	body.active = false
