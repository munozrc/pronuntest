extends Control

signal selected


func _on_button_up():
	selected.emit()
