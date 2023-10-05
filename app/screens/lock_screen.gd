extends Panel


@onready var labels = [
	$CodeContainer/First,
	$CodeContainer/Second,
	$CodeContainer/Third,
	$CodeContainer/Fourth
]


var code: String = ""
var current_digit: int = 0


func _input(event):
	if event.is_action_pressed("ui_text_backspace"):
		current_digit-= 1 if current_digit > 0 else 0
		code = code.left(code.length() - 1)
		labels[current_digit].text = "_"
		return
	
	if current_digit > 3:
		return
	
	if event is InputEventKey and event.pressed:
		var text_code = event.as_text()
		
		code+=text_code
		labels[current_digit].text = text_code
		
		current_digit+= 1 if current_digit <= 3 else 0
		
		if code != "1234" and current_digit == 4:
			$CodeAnimator.play("wrong")
