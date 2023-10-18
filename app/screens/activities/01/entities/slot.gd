extends DroppableArea


@onready var success_sound: AudioStream = preload("res://assets/sounds/success.mp3")
@onready var wrong_sound: AudioStream = preload("res://assets/sounds/error.mp3")


func _ready():
	super()
	self.dropped.connect(self._on_dropped)
	self.failed.connect(self._on_failed)


func _on_dropped():
	$CompletionAnimation/AnimationPlayer.play("fade_in")
	$AudioStreamPlayer.stream = success_sound
	$AudioStreamPlayer.play()


func _on_failed():
	$AudioStreamPlayer.stream = wrong_sound
	$AudioStreamPlayer.play()
