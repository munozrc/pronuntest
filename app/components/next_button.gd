extends TextureButton


func _ready():
	self.button_down.connect(self._on_button_down)
	self.button_up.connect(self._on_button_up)
	self.modulate = Color(255, 255, 255, 0)


func show_button():
	$AnimationPlayer.play("fade_in")


func hidden_button():
	$AnimationPlayer.play("fade_out")


func _on_button_up():
	$Icon.position.y = 6


func _on_button_down():
	$Icon.position.y = 12
