extends Node

export (PackedScene) var mate_scene
export (PackedScene) var barricade_scene

var is_game_over

func _ready():
	randomize()
	new_game()

func new_game():
	is_game_over = false
	
	instanciate_player()
	instanciate_mates()

func instanciate_player():
	$PlayerStuff/Player.start($PlayerStuff/StartPosition.position)

func instanciate_mates():
	$MateStuff/Mate.disable()
	
	var mate_one = mate_scene.instance()
	var mate_two = mate_scene.instance()
	var mate_three = mate_scene.instance()
	var mate_four = mate_scene.instance()
	
	mate_one.position = $MateStuff/FirstStartPosition.position
	mate_two.position = $MateStuff/SecondStartPosition.position
	mate_three.position = $MateStuff/ThirdStartPosition.position
	mate_four.position = $MateStuff/FourthStartPosition.position
	
	add_child(mate_one)
	add_child(mate_two)
	add_child(mate_three)
	add_child(mate_four)




func _on_Player_update_score(score):
	$HUD/ScoreCounter.update_score(score)
