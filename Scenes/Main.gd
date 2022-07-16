extends Node

export (PackedScene) var mate_scene
export (PackedScene) var barricade_scene

var is_begin_screen = true
var is_game_over = false
var is_game_on = false

var start_countdown = 4

var total_mates
var mates_dead_count

var mate_one
var mate_two
var mate_three
var mate_four

func _ready():
	randomize()
	disable_assets()


func _process(delta):
	if is_begin_screen && Input.is_action_pressed("action_input"):
		print("enter pressed in begin")
		
		new_game()
	
	elif is_game_over && Input.is_action_pressed("action_input"):
		print("enter pressed on game over")
		
		new_game()


func disable_assets():
	$MateStuff/Mate.disable()


func new_game():
	is_begin_screen = false
	is_game_over = false
	is_game_on = true
	
	$HUD/GameOverHUD/GameOverLabel.hide()
	
	$HUD/GameOnHUD/ScoreCounter.hide()
	$HUD/GameOnHUD/ScoreCounter.update_score(0)
	
	
	$HUD/BeginHUD/SupplyGuyLabel.hide()
	$HUD/BeginHUD/CopyrightLabel.hide()
	$HUD/PressEnterLabel.hide()
	
	$HUD/CountdownLabel.show()
	$HUD/CountdownLabel.text = "Get Ready!"
	
	$StartCountdown.start()


func instanciate_player():
	$PlayerStuff/Player.start($PlayerStuff/StartPosition.position)


func hide_player():
	$PlayerStuff/Player.hide()


func instanciate_mates():
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


func destroy_mates():
	mate_one.disable()
	mate_one = null
	
	mate_two.disable()
	mate_two = null
	
	mate_three.disable()
	mate_three = null
	
	mate_four.disable()
	mate_four = null


func show_barricades_and_resources():
	$BarricadeStuff/BarricadeOne.show()
	$BarricadeStuff/BarricadeTwo.show()
	$BarricadeStuff/BarricadeThree.show()
	$BarricadeStuff/BarricadeFour.show()
	$BarricadeStuff/BarricadeFive.show()
	$BarricadeStuff/BarricadeSix.show()
	
	$ResourcesStuff/WaterResource.show()
	$ResourcesStuff/BandageResource.show()
	$ResourcesStuff/KevlarResource.show()


func hide_barricades_and_resources():
	$BarricadeStuff/BarricadeOne.hide()
	$BarricadeStuff/BarricadeTwo.hide()
	$BarricadeStuff/BarricadeThree.hide()
	$BarricadeStuff/BarricadeFour.hide()
	$BarricadeStuff/BarricadeFive.hide()
	$BarricadeStuff/BarricadeSix.hide()
	
	$ResourcesStuff/WaterResource.hide()
	$ResourcesStuff/BandageResource.hide()
	$ResourcesStuff/KevlarResource.hide()


func show_hud():
	$HUD/GameOnHUD/ScoreCounter.show()


func hide_hud():
	$HUD/GameOnHUD/ScoreCounter.hide()


func game_over():
	$PlayerStuff/Player.stop_player()
	
	is_game_over = true
	
	$HUD/GameOverHUD/GameOverLabel.show()
	
	$HUD/PressEnterLabel.text = "Press \"Enter\" to restart"
	$HUD/PressEnterLabel.show()
	
	hide_player()
	destroy_mates()
	hide_barricades_and_resources()


func _on_Player_update_score(score):
	$HUD/GameOnHUD/ScoreCounter.update_score(score)


func _on_Mate_mate_died():
	print("Mate died :/")
	
	mates_dead_count = mates_dead_count + 1
	
	if (mates_dead_count == total_mates - 1):
		game_over()
	
	else:
		if (not is_game_over):
			mate_one.health_pace_difficulty_level = mates_dead_count + 1
			mate_two.health_pace_difficulty_level = mates_dead_count + 1
			mate_three.health_pace_difficulty_level = mates_dead_count + 1
			mate_four.health_pace_difficulty_level = mates_dead_count + 1
			
			$PlayerStuff/Player.slow_player_after_mate_dead()


func _on_StartCountdown_timeout():
	if (start_countdown > 0):
		if (start_countdown > 1):
			$HUD/CountdownLabel.text = str(start_countdown - 1)
		else:
			$HUD/CountdownLabel.text = "Go!"
	else:
		$StartCountdown.stop()
		
		$HUD/CountdownLabel.hide()
		
		print("countdown 5")
		
		start_countdown = 4
		
		instanciate_player()
		instanciate_mates()
		
		show_barricades_and_resources()
		show_hud()
	
	start_countdown = start_countdown - 1
