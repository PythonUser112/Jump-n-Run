extends KinematicBody2D

signal collided
signal killed

export (Vector2) var marker
export (int) var move_speed = 100
export (bool) var friendly = false
export (bool) var override_visibility_factor = false
var vel = Vector2()
var dead = false
var move = false

func _ready():
	move = override_visibility_factor and not friendly

func _process(delta):
	if move:
		var diff = marker - position
		if diff.x > 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
		vel += diff.normalized() * move_speed * delta
		$AnimationPlayer.play("fly")
		vel = move_and_slide(vel)
	else:
		vel = Vector2()

func _on_VisibilityNotifier2D_screen_entered():
	move = true


func _on_VisibilityNotifier2D_screen_exited():
	move = false or override_visibility_factor


func set_marker_pos(pos):
	marker = pos


func _on_CollisionArea_body_entered(body):
	emit_signal("collided", body)


func damage():
	if friendly:
		return
	if not dead:
		move = override_visibility_factor
		dead = true
		$AnimationPlayer.play("die")
		yield($AnimationPlayer, "animation_finished")
		emit_signal("killed")
		queue_free()


func _on_CollisionArea_area_entered(area):
	if area.name == "Bullet":
		damage()
