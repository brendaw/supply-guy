extends KinematicBody2D

export var speed = 200

var screen_size

signal hit

func _ready():
	$CollisionShape2D.disabled = false
	pass

