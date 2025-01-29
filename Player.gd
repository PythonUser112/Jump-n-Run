extends KinematicBody2D

signal life_changed
signal dead
signal moved

export (PackedScene) var bullet_scene
export (bool) var has_gun = false

var life
var run_speed=350
var jump_speed=500
var gravity=750

enum {IDLE, RUN, JUMP, HURT, DEAD}
var state
var anim
var new_anim
var velocity = Vector2()
var shoots = 25
var can_shoot = true
var recharging = false

func get_input():
	if state == HURT:
		return
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_pressed("jump")
	
	velocity.x = 0
	if right:
		velocity.x += run_speed
		$AnimatedSprite.flip_h = false
		$Gun.flip_h = false
		$Gun.position.x = 30
	elif left:
		$Gun.position.x = -30
		$Gun.flip_h = true
		velocity.x -= run_speed
		$AnimatedSprite.flip_h = true
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y -= jump_speed
	elif is_on_floor():
		change_state(IDLE)
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, JUMP] and !is_on_floor():
		change_state(JUMP)
	if Input.is_action_pressed("shoot") and shoots > 0 and can_shoot and has_gun:
		shoots -= 1
		$ShootTimer.start()
		if !recharging:
			$RechargeTimer.start()
			recharging = true
		var x
		if $AnimatedSprite.flip_h:
			x = -1
		else:
			x = 1
		var bullet = bullet_scene.instance()
		bullet.position = position + Vector2(-45 * (int($Gun.flip_h) * 2 -1), 12)
		bullet.shoot(Vector2(x, 0))
		get_parent().add_child(bullet)
	
func ready():
	change_state(IDLE)

func start(pos):
	position = pos
	show()
	change_state(IDLE)
	life=5
	emit_signal("life_changed", life)

func hurt():
	if state != HURT:
		change_state(HURT)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			new_anim = "stand"
		RUN:
			new_anim = "walk"
		HURT:
			new_anim = "hurt"
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			emit_signal("life_changed", life)
			yield(get_tree().create_timer(0.5), "timeout")
			if life <= 0:
				change_state(DEAD)
			else:
				change_state(IDLE)
		JUMP:
			new_anim = "jump"
		DEAD:
			emit_signal("dead")
			queue_free()

func _physics_process(delta):
	$Gun.visible = has_gun
	velocity.y += gravity * delta
	get_input()
	if new_anim != anim:
		anim = new_anim
		$AnimatedSprite.animation = anim
	velocity = move_and_slide(velocity, Vector2(0, -1))
	emit_signal("moved", position)

func enemy_collision(body):
	if body == self:
		change_state(HURT)


func _on_ShootTimer_timeout():
	can_shoot = true


func _on_RechargeTimer_timeout():
	shoots += 1
	if shoots < 25:
		$RechargeTimer.start()
	else:
		recharging = false
