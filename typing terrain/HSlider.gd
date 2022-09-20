extends HSlider


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _process(delta):
	if value == 0.0:
		value = 1.0
