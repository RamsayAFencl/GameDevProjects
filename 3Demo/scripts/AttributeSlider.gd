extends VBoxContainer

var attribute = ""
var val = 0
var max_val = 0

func _ready():
	$Label.text = attribute
	$HSlider.value = val
	$HSlider.max_value = max_val
