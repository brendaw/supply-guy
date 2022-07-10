extends KinematicBody2D

export var speed = 150

var velocity = Vector2.ZERO

# TO-DO: Implement AI for shoot and get behind the barricade
# TO-DO: Implement the logic for running low of resources.

var has_water_resource = false
var has_bandage_resource = false
var has_kevlar_resource = false

var on_water_refill_zone = false
var on_bandage_refill_zone = false
var on_kevlar_refill_zone = false

var screen_size

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
