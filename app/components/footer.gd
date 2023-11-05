extends Control


signal pressed


func _ready():
	$Control/CenterContainer/Button.button_up.connect(_on_button_pressed)


func show_button():
	$Control/FooterAnimator.play("fade_in")


func hidden_button():
	$Control/FooterAnimator.play("fade_out")


func _on_button_pressed():
	pressed.emit()
