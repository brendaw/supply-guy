extends KinematicBody2D

signal hit

export var speed = 150

var velocity = Vector2.ZERO

# TO-DO: Implement AI for shoot and get behind the barricade
# TO-DO: Implement the logic for running low of resources.

var screen_size

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

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
	
	velocity = velocity.normalized() * speed

func animate_player():
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func clear_velocity():
	velocity = Vector2.ZERO
