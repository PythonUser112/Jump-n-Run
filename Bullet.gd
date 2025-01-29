extends Area2D

export (int) var speed

var velocity

func shoot(vel):
	velocity = vel * speed


func _process(delta):
	position += velocity * delta

func _on_Bullet_body_entered(_body):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
