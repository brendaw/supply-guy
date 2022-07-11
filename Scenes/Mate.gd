extends KinematicBody2D

export var speed = 200

enum { WATER_RESOURCE, BANDAGE_RESOURCE, KEVLAR_RESOURCE } 

var need_water_resource = false
var need_bandage_resource = false
var need_kevlar_resource = false

var choosed_resource_index
var last_choosed_resource_index

var screen_size

func _ready():
	$CollisionShape2D.disabled = false
	$AnimatedSprite.play()
	update_animation("empty")
	choose_some_resource_in_need()

func disable():
	$CollisionShape2D.disabled = true
	hide()
	queue_free()

func update_animation(animation):
	$AnimatedSprite.animation = animation

func choose_some_resource_in_need():
	choosed_resource_index = randi() % 3
	
	if choosed_resource_index == last_choosed_resource_index:
		if choosed_resource_index == 2:
			choosed_resource_index = 0
		else:
			choosed_resource_index += 1

	match choosed_resource_index:
		WATER_RESOURCE:
			need_water_resource = true
			$AnimatedSprite.animation = "water"
		BANDAGE_RESOURCE:
			need_bandage_resource = true
			$AnimatedSprite.animation = "bandage"
		KEVLAR_RESOURCE:
			need_kevlar_resource = true
			$AnimatedSprite.animation = "kevlar"
	
	last_choosed_resource_index = choosed_resource_index
	$HealthTimer.start()

func reset_resources():
	need_water_resource = false
	need_bandage_resource = false
	need_kevlar_resource = false

func reset_current_resource():
	reset_resources()
	$AnimatedSprite.animation = "empty"
	$RefillTimer.start()

func _on_MateRefillZone_body_entered(body):
	if body != self:
		print(body.name)
		body._on_entered_mate_refill_zone(self)


func _on_MateRefillZone_body_exited(body):
	if body != self:
		print(body.name)
		body._on_exited_mate_refill_zone()

func _on_RefillTimer_timeout():
	choose_some_resource_in_need()
	$RefillTimer.stop()

func _on_ResourceTimer_timeout():
	pass # Replace with function body.


func _on_HealthTimer_timeout():
	print("Health counter")
