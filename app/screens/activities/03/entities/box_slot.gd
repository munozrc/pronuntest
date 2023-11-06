extends DroppableArea


@onready var success_sound: AudioStream = preload("res://assets/sounds/success.mp3")
@onready var wrong_sound: AudioStream = preload("res://assets/sounds/error.mp3")


func _ready():
	super()
	dropped.connect(_on_dropped)
	failed.connect(_on_failed)


func _on_dropped():
	$Sound.stream = success_sound
	$Sound.play()


func _on_failed(item: DraggableItem):
	$Sound.stream = wrong_sound
	$Sound.play()
	
	if item == null:
		return
	
	item.start_shake_animation()
