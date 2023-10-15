extends DraggableItem


@export var audio: AudioStream


func _ready():
	super()
	self.selected.connect(self._on_selected)
	$Dialog.stream = audio


func _on_selected():
	$Dialog.play()
