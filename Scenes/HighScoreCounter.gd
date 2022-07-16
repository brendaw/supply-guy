extends Label

func _ready():
	pass

func update_high_score(high_score):
	text = "High Score: %07d" % high_score
