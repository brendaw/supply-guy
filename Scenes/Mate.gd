extends KinematicBody2D

signal mate_died

enum { WATER_RESOURCE, BANDAGE_RESOURCE, KEVLAR_RESOURCE } 

var on_resource_need = false

var need_water_resource = false
var need_bandage_resource = false
var need_kevlar_resource = false

var choosed_resource_index
var last_choosed_resource_index

var health_pace = 0

var health_pace_random = 1

var health_pace_difficulty = 1.25
var health_pace_difficulty_level = 1
var health_pace_difficulty_step = 0.5

var health = 100

var screen_size


func _ready():
	randomize()
	
	$CollisionShape2D.disabled = false
	
	update_animation("empty")
	
	choose_some_resource_in_need()
	choose_health_pace()
	
	health = 100
	
	$HealthTimer.start()


func disable():
	$CollisionShape2D.disabled = true
	hide()
	queue_free()


func update_animation(animation):
	$AnimatedSprite.animation = animation


func update_health_animation():
	if ($HappyTimer.is_stopped()):
		if health < $HealthDisplay/HealthBar.max_value:
			$AnimatedSprite.frame = 0
		if health < $HealthDisplay/HealthBar.max_value * 0.7:
			$AnimatedSprite.frame = 1
		if health < $HealthDisplay/HealthBar.max_value * 0.35:
			$AnimatedSprite.frame = 2


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
	
	on_resource_need = true


func reset_resources():
	on_resource_need = false
	
	need_water_resource = false
	need_bandage_resource = false
	need_kevlar_resource = false
	
	$AnimatedSprite.animation = "empty"


func reset_current_resource():
	$HealthTimer.stop()
	$HealthDisplay.hide()
	
	reset_resources()
	
	health = 100
	$HealthDisplay.update_health_bar(health)
	
	$AnimatedSprite.animation = "empty"
	$AnimatedSprite.play()
	
	$RefillTimer.start()


func choose_health_pace():
	health_pace_random = (randi() % 5) * 2
	
	if health_pace_random == 0:
		health_pace_random = 5
	
	health_pace_difficulty = health_pace_difficulty_level * health_pace_difficulty_step
	
	health_pace = health_pace_random * (health_pace_difficulty + 1)


func player_grabbed_a_resource(resource):
	if (resource == "water" && need_water_resource):
		make_mate_happy()
	
	if (resource == "bandage" && need_bandage_resource):
		make_mate_happy()
	
	if (resource == "kevlar" && need_kevlar_resource):
		make_mate_happy()

func make_mate_happy():
	$HappyTimer.start()
	
	$AnimatedSprite.frame = 3

func _on_MateRefillZone_body_entered(body):
	if body != self && body.has_method("_on_entered_mate_refill_zone"):
		print(body.name)
		body._on_entered_mate_refill_zone(self)


func _on_MateRefillZone_body_exited(body):
	if body != self && body.has_method("_on_exited_mate_refill_zone"):
		print(body.name)
		body._on_exited_mate_refill_zone()


func _on_RefillTimer_timeout():
	$RefillTimer.stop()
	
	$AnimatedSprite.stop()
	
	choose_some_resource_in_need()
	choose_health_pace()
	
	$HealthDisplay.show()
	
	$HealthTimer.start()


func _on_HealthTimer_timeout():
	if (on_resource_need):
		health_pace_difficulty = health_pace_difficulty_level * health_pace_difficulty_step
		
		health_pace = health_pace_random * (health_pace_difficulty + 1)
		
		health -= health_pace / 4
		
		if (health <= 0):
			print("It's over, mate")
			
			reset_resources()
			
			$AnimatedSprite.animation = "dead"
			
			emit_signal("mate_died")
			
			$HealthTimer.stop()
		
		update_health_animation()

		$HealthDisplay.update_health_bar(health)


func _on_HappyTimer_timeout():
	$HappyTimer.stop()
	
	update_health_animation()
