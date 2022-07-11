extends Node2D

var low_bar = preload("res://Assets/Low_Health.png")
var medium_bar = preload("res://Assets/Medium_Health.png")
var high_bar = preload("res://Assets/High_Health.png")

onready var health_bar = $HealthBar

func _ready():
	pass

func _process(delta):
	global_rotation = 0

func update_health_bar(value):
	health_bar.texture_progress = high_bar
	if value < health_bar.max_value * 0.7:
		health_bar.texture_progress = medium_bar
	if value < health_bar.max_value * 0.35:
		health_bar.texture_progress = low_bar
	if value < health_bar.max_value:
		show()
	
	health_bar.value = value
