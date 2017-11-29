extends Node

onready var continue_button = get_node('continue_button')
onready var newgame_button = get_node('newgame_button')

func _ready():
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
