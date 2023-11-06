extends DraggableItem


@export var sound: AudioStream:
	set(value):
		sound = value
		$Sound.stream = value


func _ready():
	super()
	selected.connect(_on_selected)


func start_shake_animation():
	$BoxAnimator.stop()
	$BoxAnimator.play("shake")


func _on_selected():
	$Sound.play()
	self.get_parent().move_child(self, -1)
