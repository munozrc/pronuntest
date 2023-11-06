class_name Island
extends Control


signal selected


@export var button: TextureButton = null
@export var scene: PackedScene = null
@export var visible_notifier : VisibleOnScreenNotifier2D = null


func _ready():
	if button != null:
		button.pressed.connect(_on_button_pressed)
	
	if visible_notifier != null:
		visible_notifier.screen_entered.connect(_on_screen_entered)
		visible_notifier.screen_exited.connect(_on_screen_exited)


func _on_screen_entered():
	self.get_child(0).show()


func _on_screen_exited():
	self.get_child(0).hide()


func _on_button_pressed():
	if scene == null:
		return
	selected.emit()
