extends Label

var scorea = 0

func _ready():
	pass

func update_score(score):
	text = "Score: %07d" % score
