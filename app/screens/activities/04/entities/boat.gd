extends RigidBody2D


@export var speed := 10
@export var active := true


var record_bux_index: int


func _ready() -> void:
	record_bux_index = AudioServer.get_bus_index("Record")


func _process(_delta):
	if not active:
		$AnimationTree.set("parameters/conditions/idle", true)
		$AnimationTree.set("parameters/conditions/wind", false)
		return
	
	var sample = AudioServer.get_bus_peak_volume_left_db(record_bux_index, 0)
	var linear_sample = round(db_to_linear(sample) * speed)

	apply_impulse(Vector2(0, -linear_sample if linear_sample >= 11 else 0))
	
	$AnimationTree.set("parameters/conditions/idle", linear_sample <= 10)
	$AnimationTree.set("parameters/conditions/wind", linear_sample >= 11)
	
	print(linear_sample)
