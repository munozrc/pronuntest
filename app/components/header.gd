extends Control

signal close

func _on_close_button_pressed():
	close.emit()
