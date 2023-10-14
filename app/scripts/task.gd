class_name Task
extends Control


signal completed


@export var next_button: TextureButton


func show_next_button():
	self.next_button.show_button()


func hidden_next_button():
	self.next_button.hidden_button()
