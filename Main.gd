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
	var mate_one = mate_scene.instance()
	mate_one.position = $MateStuff/FirstStartPosition.position
	
	var mate_two = mate_scene.instance()
	mate_two.position = $MateStuff/SecondStartPosition.position
	
	var mate_three = mate_scene.instance()
	mate_three.position = $MateStuff/ThirdStartPosition.position
	
	add_child(mate_one)
	add_child(mate_two)
	add_child(mate_three)
