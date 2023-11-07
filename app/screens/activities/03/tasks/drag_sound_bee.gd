extends Task


@onready var options = [
	[
		"araña",
		preload("res://assets/voices/words/araña.mp3")
	],
	[
		"abeja",
		preload("res://assets/voices/words/abeja.mp3")
	]
]


var boxes := []
var number_of_boxes := 0
var missing_sounds := 0
var found_sounds := 0:
	set(new_value):
		found_sounds = new_value
		var rest = missing_sounds - new_value
		$TopContainer/Display/Statement.text = "Sonidos restantes: %d" % rest


func _ready():
	boxes = $CenterContainer.get_children()
	number_of_boxes = $CenterContainer.get_child_count()
	
	for i in range(number_of_boxes):
		if not boxes[i] is Node2D:
			boxes.erase(boxes[i])
			number_of_boxes -= 1
	
	for i in range(number_of_boxes):
		var option = options[randi() % options.size()]
		boxes[i].content = option[0]
		boxes[i].sound = option[1]
		boxes[i].is_active = true
	
	for i in range(number_of_boxes):
		if boxes[i].content == "abeja":
			missing_sounds += 1
	
	if missing_sounds == 0:
		boxes[-1].content = options[1][0]
		boxes[-1].sound = options[1][1]
		boxes[0].content = options[1][0]
		boxes[0].sound = options[1][1]
		missing_sounds = 2
	elif missing_sounds == 4:
		boxes[0].content = options[0][0]
		boxes[0].sound = options[0][1]
		boxes[-1].content = options[0][0]
		boxes[-1].sound = options[0][1]
		missing_sounds = 2
	
	found_sounds = 0


func enable_interactions():
	for i in range(number_of_boxes):
		boxes[i].is_active = true


func disable_interactions():
	for i in range(number_of_boxes):
		boxes[i].is_active = false


func _on_box_dropped(item):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(item, "scale", Vector2.ZERO, 1.2)
	
	$TopContainer/BoxSlot/ConfettiEffect.start_animation()
	found_sounds += 1

	if missing_sounds != found_sounds:
		return
	
	$Narrator.stream = load("res://assets/voices/statements/excelente.mp3")
	$Narrator.play()
	disable_interactions()


func _on_confetti_effect_finished():
	if missing_sounds != found_sounds:
		return
	
	$TaskAnimator.play("outro")
	await $TaskAnimator.animation_finished
	completed.emit()
