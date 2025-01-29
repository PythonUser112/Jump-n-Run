extends StaticBody2D

var locked = true
var color = ""

func init(col, pos):
	locked = true
	position = pos
	color = col
	$CollisionShape2D.disabled = false
	$Sprite.visible = true
	$Sprite.texture = load("res://graphics/GRP/tiles/Block/Lock/lock_%s.png"%(color))

func _on_Main_keys_changed(keys):
	locked = not keys["key_"+color]
	$CollisionShape2D.set_deferred("disabled", not locked)
	$Sprite.visible = locked
