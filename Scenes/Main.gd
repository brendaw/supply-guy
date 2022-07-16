extends Node

export (PackedScene) var mate_scene
export (PackedScene) var barricade_scene

var is_game_over

var total_mates
var mates_dead_count

var mate_one
var mate_two
var mate_three
var mate_four

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
	
	mate_one = mate_scene.instance()
	mate_two = mate_scene.instance()
	mate_three = mate_scene.instance()
	mate_four = mate_scene.instance()
	
	total_mates = 4
	mates_dead_count = 0
	
	mate_one.position = $MateStuff/FirstStartPosition.position
	mate_two.position = $MateStuff/SecondStartPosition.position
	mate_three.position = $MateStuff/ThirdStartPosition.position
	mate_four.position = $MateStuff/FourthStartPosition.position
	
	mate_one.connect("mate_died", self, "_on_Mate_mate_died")
	mate_two.connect("mate_died", self, "_on_Mate_mate_died")
	mate_three.connect("mate_died", self, "_on_Mate_mate_died")
	mate_four.connect("mate_died", self, "_on_Mate_mate_died")
	
	add_child(mate_one)
	add_child(mate_two)
	add_child(mate_three)
	add_child(mate_four)


func _on_Player_update_score(score):
	$HUD/ScoreCounter.update_score(score)


func _on_Mate_mate_died():
	print("Mate died :/")
	
	mates_dead_count = mates_dead_count + 1
	
	if (mates_dead_count == total_mates):
		is_game_over = true
	else:
		mate_one.health_pace_difficulty_level = mates_dead_count + 1
		mate_two.health_pace_difficulty_level = mates_dead_count + 1
		mate_three.health_pace_difficulty_level = mates_dead_count + 1
		mate_four.health_pace_difficulty_level = mates_dead_count + 1
		
		$PlayerStuff/Player.slow_player_after_mate_dead()
