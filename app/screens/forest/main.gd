extends Control


func _ready():
	var max_height = $ScrollContainer/Control.size.x
	$ScrollContainer.scroll_vertical = max_height
