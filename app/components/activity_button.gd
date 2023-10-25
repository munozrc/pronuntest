extends Control


signal pressed(activity: PackedScene)


enum STATE_BUTTON { completed, unlocked, locked }


@export var activity: PackedScene = null
@export var state := STATE_BUTTON.locked


@onready var buttons = {
	"completed": $CompletedButton,
	"unlocked": $UnlockedButton,
	"locked": $LockedButton
}


func _ready():
	self._enable_current_button()
	buttons["completed"].pressed.connect(self._on_button_pressed)
	buttons["unlocked"].pressed.connect(self._on_button_pressed)


func change_state(new_state: String):
	state = STATE_BUTTON.get(new_state)
	_enable_current_button()


func _enable_current_button():
	for key in buttons:
		var button: TextureButton = buttons[key]
		var is_active = key == STATE_BUTTON.keys()[state]
		
		button.visible = is_active
		button.disabled = not is_active
		
		if key == "unlocked":
			$UnlockedButton/GlobalAnimator.play("idle")


func _on_button_pressed():
	if activity == null:
		printerr("Activity is required to change")
		return
	
	self.pressed.emit(activity)
