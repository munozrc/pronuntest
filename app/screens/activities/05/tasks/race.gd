extends Task

@onready var timer: Timer = $Timer
@onready var timer_box: Timer = $ContainerCenter/BoxSpawner/Timer
@onready var car: Node2D = $ContainerCenter/Car
@onready var spawn_points: Array[Node2D] = [
	$ContainerCenter/Spawn,
	$ContainerCenter/Spawn2,
	$ContainerCenter/Spawn3
]
@onready var box_spawn_point: Array[Node2D] = [
	$ContainerCenter/BoxSpawner/BoxSpawn,
	$ContainerCenter/BoxSpawner/BoxSpawn2,
	$ContainerCenter/BoxSpawner/BoxSpawn3,
]


var box: PackedScene = load("res://screens/activities/05/entities/box.tscn")
var record_bus_index: int
var current_position: int
var record_effect: AudioEffectRecord
var recording: AudioStreamWAV
var tween: Tween
var is_finished:= false


func _ready():
	record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	record_effect.set_recording_active(false)
	
	current_position = 1
	car.reset_animation()


func start_race():
	record_effect.set_recording_active(true)
	
	car.position = spawn_points[current_position].position
	car.move_animation()
	is_finished = false
	
	timer_box.start()
	timer.start()
	create_box()


func stop_race():
	record_effect.set_recording_active(false)
	is_finished = true
	
	timer_box.stop()
	timer.stop()
	
	if tween != null and tween.is_running():
		tween.stop()
	
	$Footer.show_button()
	
	for box_item in $ContainerCenter/BoxSpawner/Container.get_children():
		box_item.is_moved = false


func move_up_car():
	if current_position > 0:
		current_position -= 1
		move_car()


func move_down_car():
	if current_position < 2:
		current_position += 1
		move_car()


func move_car():
	if tween != null and tween.is_running():
		tween.stop()
	
	var new_position = spawn_points[current_position].global_position
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(car, "position", new_position, 0.4)


func create_box():
	var new_box = box.instantiate()
	new_box.position = box_spawn_point[randi() % 3].position
	$ContainerCenter/BoxSpawner/Container.add_child(new_box)


func _process(delta):
	if not record_effect.is_recording_active():
		return
	
	$ContainerCenter/SpeedWay.global_position.x -= 120 * delta


func _on_timer_timeout():
	record_effect.set_recording_active(false)
	
	recording = record_effect.get_recording()
	recording.save_to_wav($PredictionComponent.recording)
	
	$PredictionComponent.send_audio()
	record_effect.set_recording_active(true)


func _on_timer_box_timeout():
	create_box()


func _on_prediction_completed(_result, response_code, _headers, body):
	if (
		response_code != HTTPClient.RESPONSE_OK ||
		is_finished
	):
		return
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response.phoneme.class == "i":
		move_up_car()
		print("Up")
		return

	if response.phoneme.class == "e":
		move_down_car()
		print("Down")
		return


func _on_car_crashed():
	$Narrator.stream = load("res://assets/voices/statements/oh_no.mp3")
	$Narrator.play()
	stop_race()


func _on_car_won():
	stop_race()
	car.reset_animation()
	
	$ContainerCenter/ConfettiEffect.start_animation()
	
	$Narrator.stream = load("res://assets/voices/statements/bien_hecho.mp3")
	$Narrator.play()


func _on_footer_pressed():
	$TaskAnimator.play("outro")
	await $TaskAnimator.animation_finished
	completed.emit()
