extends Area2D

export var speed = 200

# TO-DO: Implement AI for shoot and get behind the barricade
# TO-DO: Implement the logic for running low of resources.

var screen_size

signal hit

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	var velocity = Vector2.ZERO
	
	if key_pressed("move_right"):
		velocity.x += 1
	
	if key_pressed("move_left"):
		velocity.x -= 1
	
	if key_pressed("move_up"):
		velocity.y -= 1
	
	if key_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func key_pressed(key):
	return Input.is_action_pressed(key)

func _on_Player_body_entered(body):
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
