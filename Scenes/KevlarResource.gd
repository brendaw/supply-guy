extends StaticBody2D

signal entered_kevlar_refill
signal exited_kevlar_refill

func _ready():
	pass

func _on_KevlarRefillSpot_body_entered(body):
	if body != self:
		print(body.name)
		emit_signal("entered_kevlar_refill")


func _on_KevlarRefillSpot_body_exited(body):
	if body != self:
		print(body.name)
		emit_signal("exited_kevlar_refill")
