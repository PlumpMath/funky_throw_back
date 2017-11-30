extends Node

onready var continue_button = get_node('continue_button')
onready var newgame_button = get_node('newgame_button')

onready var dance_timer = get_node('intro_dancer/dance_timer')
onready var dancer_animation = get_node('intro_dancer/character/AnimationPlayer')

var possible_moves = ['up', 'down', 'left', 'right']
var last_move = ''

func _ready():
	randomize()
	dance_timer.connect("timeout", self, '_dancer_move')
	
	newgame_button.connect("button_up", self, "_new_game_button_press")
	
	var save_game = _load_save_data()
	if save_game != null:
		continue_button.connect("button_up", self, "_continue_button_press", [save_game['level'], save_game['stage']])
	else:
		continue_button.set_disabled(true)

func _continue_button_press(level, stage):
	scene_state.autoload_level = level
	scene_state.autoload_stage = stage
	get_tree().change_scene('res://scenes/Main.tscn')

func _new_game_button_press():
	scene_state.autoload_level = null
	scene_state.autoload_stage = null
	get_tree().change_scene('res://scenes/Main.tscn')

	
func _load_save_data():
	var savegame = File.new()
	if !savegame.file_exists('user://savegame.save'):
		return null
	
	var save_data = {}
	savegame.open('user://savegame.save', File.READ)
	save_data.parse_json(savegame.get_line())
	savegame.close()
	return save_data
	
func _dancer_move():
	var move = possible_moves[rand_range(0, possible_moves.size())]
	if last_move == move:
		if move != 'down':
			move = 'down'
		else:
			move = 'right'
	
	dancer_animation.play(move)
	last_move = move
