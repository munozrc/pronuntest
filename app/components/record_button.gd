extends Control


signal finished
signal pressed
signal fail


@export var max_duration := 1.0


var save_path := "user://recording.wav"
var enable := true:
	set(new_value):
		enable = new_value
		$Button.disabled = !new_value


var _tween: Tween
var _record_bus_index: int
var _record_effect: AudioEffectRecord
var _recording: AudioStreamWAV


func _ready() -> void:
	_record_bus_index = AudioServer.get_bus_index("Record")
	_record_effect = AudioServer.get_bus_effect(_record_bus_index, 0)
	_record_effect.set_recording_active(false)


func reset() -> void:
	_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	_tween.tween_property($Progressbar, "value", 0, 0.2)


func _on_button_down():
	if not enable:
		return
	
	pressed.emit()
	$Progressbar.value = 0
	_record_effect.set_recording_active(true)
	
	_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	_tween.tween_property($Progressbar, "value", 100, max_duration)
	_tween.tween_callback(_on_max_duration_reached)


func _on_recording_finished():
	_record_effect.set_recording_active(false)
	
	if $Progressbar.value < 15:
		fail.emit()
		return

	if not enable:
		return
	
	_recording = _record_effect.get_recording()
	_recording.save_to_wav(save_path)
	finished.emit()


func _on_button_up():
	if not _record_effect.is_recording_active():
		return
	
	_on_recording_finished()
	_tween.kill()


func _on_max_duration_reached():
	if not _record_effect.is_recording_active():
		return
	
	_on_recording_finished()
