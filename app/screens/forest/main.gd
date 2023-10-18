extends Control


func _ready():
	var max_scroll_value = $ScrollContainer/VBoxContainer.size.y
	$ScrollContainer.scroll_vertical = max_scroll_value
