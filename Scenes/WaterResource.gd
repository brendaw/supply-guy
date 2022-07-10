extends StaticBody2D

signal entered_water_refill
signal exited_water_refill

func _ready():
	pass

func _on_WaterRefillSpot_body_entered(body):
	if body != self:
		print(body.name)
		emit_signal("entered_water_refill")

func _on_WaterRefillSpot_body_exited(body):
	if body != self:
		print(body.name)
		emit_signal("exited_water_refill")
	
