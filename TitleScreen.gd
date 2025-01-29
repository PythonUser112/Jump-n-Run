extends Control

onready var screensize = get_viewport_rect().size

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var posx = mouse_pos.x
	var posy = mouse_pos.y
	var outx = translate(posx, 0, screensize.x, -$Sprite.scale.x*597, 0)
	var outy = translate(posy, 0, screensize.y, -$Sprite.scale.y*692, 0)
	$Sprite.position = Vector2(outx, outy)

func translate(value, leftMin, leftMax, rightMin, rightMax):
	# Figure out how 'wide' each range is
	var leftSpan = leftMax - leftMin
	var rightSpan = rightMax - rightMin

	# Convert the left range into a 0-1 range (float)
	var valueScaled = float(value - leftMin) / float(leftSpan)

	# Convert the 0-1 range into a value in the right range.
	return rightMin + (valueScaled * rightSpan)
