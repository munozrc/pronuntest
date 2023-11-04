extends Control


signal close


@onready var progressbar: ProgressBar = $MarginContainer/HBoxContainer/ProgressBar


func _on_close_button_pressed():
	close.emit()


func increment(new_value: float):
	var value = progressbar.value + new_value
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(progressbar, "value",  value, 0.2)
	
	if value < 100:
		$AudioStreamPlayer.play()
