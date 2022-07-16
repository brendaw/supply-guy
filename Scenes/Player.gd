extends KinematicBody2D

signal update_score(score)

export var score = 0

export var speed = 150

var velocity = Vector2.ZERO

var has_water_resource = false
var has_bandage_resource = false
var has_kevlar_resource = false

var on_water_refill_zone = false
var on_bandage_refill_zone = false
var on_kevlar_refill_zone = false

var near_mate = null

var screen_size

var dead_penalty_counter = 0

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	$AnimatedSprite.play()
	update_animation("default")

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _physics_process(delta):
	get_input()
	animate_player()
	
	move_and_slide(velocity)
	
	clear_velocity()

func key_pressed(key):
	return Input.is_action_pressed(key)

func get_input():
	if key_pressed("move_right"):
		velocity.x += 1
	
	if key_pressed("move_left"):
		velocity.x -= 1
	
	if key_pressed("move_up"):
		velocity.y -= 1
	
	if key_pressed("move_down"):
		velocity.y += 1
	
	if key_pressed("handle_resource"):
		if on_water_refill_zone:
			has_water_resource = true
			has_bandage_resource = false
			has_kevlar_resource = false
			update_animation("water")
		elif on_bandage_refill_zone:
			has_bandage_resource = true
			has_water_resource = false
			has_kevlar_resource = false
			update_animation("bandage")
		elif on_kevlar_refill_zone:
			has_kevlar_resource = true
			has_bandage_resource = false
			has_water_resource = false
			update_animation("kevlar")
		
		if (near_mate != null):
			if (has_water_resource && near_mate.need_water_resource):
				has_water_resource = false
				$AnimatedSprite.animation = "empty"
				update_score()
				near_mate.reset_current_resource()
			elif (has_bandage_resource && near_mate.need_bandage_resource):
				has_bandage_resource = false
				$AnimatedSprite.animation = "empty"
				update_score()
				near_mate.reset_current_resource()
			elif (has_kevlar_resource && near_mate.need_kevlar_resource):
				has_kevlar_resource = false
				$AnimatedSprite.animation = "empty"
				update_score()
				near_mate.reset_current_resource()
	
	velocity = velocity.normalized() * speed

func animate_player():
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func update_animation(animation):
	$AnimatedSprite.animation = animation

func clear_velocity():
	velocity = Vector2.ZERO
	
func update_score():
	score += near_mate.health * near_mate.health_pace
	
	emit_signal("update_score", score)


func slow_player_after_mate_dead():
	dead_penalty_counter = dead_penalty_counter + 6
	
	speed = 100
	
	$AnimatedSprite.modulate.a = 0.5
	
	if ($DeadTimer.is_stopped()):
		$DeadTimer.start()


func _on_entered_water_refill():
	print("entered water refill")
	on_water_refill_zone = true
	on_bandage_refill_zone = false
	on_kevlar_refill_zone  = false


func _on_WaterResource_exited_water_refill():
	print("exited water refill")
	on_water_refill_zone = false


func _on_BandageResource_entered_bandage_refill():
	print("entered bandage refill")
	on_bandage_refill_zone = true
	on_water_refill_zone = false
	on_kevlar_refill_zone  = false


func _on_BandageResource_exited_bandage_refill():
	print("exited bandage refill")
	on_bandage_refill_zone = false


func _on_KevlarResource_entered_kevlar_refill():
	print("entered kevlar refill")
	on_kevlar_refill_zone  = true
	on_water_refill_zone = false
	on_bandage_refill_zone = false


func _on_KevlarResource_exited_kevlar_refill():
	print("exited kevlar refill")
	on_kevlar_refill_zone  = false


func _on_entered_mate_refill_zone(mate):
	print("entered near mate refill zone")
	print(mate)
	near_mate = mate


func _on_exited_mate_refill_zone():
	print("exited near mate refill zone")
	print(near_mate)
	near_mate = null
	print(near_mate)


func _on_DeadTimer_timeout():
	print("--")
	print(dead_penalty_counter)
	print(speed)
	
	if dead_penalty_counter == 0:
		$DeadTimer.stop()
		speed = 125
		$AnimatedSprite.modulate.a = 1
	else:
		dead_penalty_counter = dead_penalty_counter - 1
		
		if $AnimatedSprite.modulate.a == 0.5:
			$AnimatedSprite.modulate.a = 1
		else:
			$AnimatedSprite.modulate.a = 0.5
	
	print(dead_penalty_counter)
	print(speed)
