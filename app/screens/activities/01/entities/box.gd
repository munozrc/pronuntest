extends DraggableItem


@export var audio: AudioStream:
	get:
		return audio
	set(value):
		audio = value
		$Dialog.stream = value


func _ready():
	super()
	self.selected.connect(self._on_selected)
	$Dialog.stream = audio


func _on_selected():
	$Dialog.play()
