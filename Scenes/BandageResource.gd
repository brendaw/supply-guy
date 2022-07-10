extends StaticBody2D

signal entered_bandage_refill
signal exited_bandage_refill

func _ready():
	pass

func _on_BandageRefillSpot_body_entered(body):
	if body != self:
		print(body.name)
		emit_signal("entered_bandage_refill")


func _on_BandageRefillSpot_body_exited(body):
	if body != self:
		print(body.name)
		emit_signal("exited_bandage_refill")
