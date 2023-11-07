extends RigidBody2D


@export var speed := 10
@export var active := true


var record_bux_index: int


func _ready() -> void:
	record_bux_index = AudioServer.get_bus_index("Record")


func _process(_delta):
	if not active:
		return
	
	var sample = AudioServer.get_bus_peak_volume_left_db(record_bux_index, 0)
	var linear_sample = db_to_linear(sample)
	
	apply_impulse(Vector2(0, -round(linear_sample * speed)))
