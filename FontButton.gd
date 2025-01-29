extends Button

signal level

var level

func set_level(_level):
	level = _level
	text = "Level "+str(level)

func set_active(max_level):
	if level > max_level:
		disabled = true
	else:
		disabled = false

func _on_FontButton_pressed():
	emit_signal("level", level)
