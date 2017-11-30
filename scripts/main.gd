extends Node

onready var main_character_animation = get_node('main_character')
onready var opp_character_animation = get_node('opp_character')
onready var player_spotlight = get_node('Node/scene/player_spotlight')
onready var enemy_spotlight = get_node('Node/scene/enemy_spotlight')
onready var arrow_controller = get_node('arrow_controller')
onready var dialogue_state = get_node('states/dialogue_state')
onready var repeat_play_state = get_node('states/play_repeat_state')
onready var freestyle_state = get_node('states/freestyle_state')
onready var game_over_res = preload('res://scenes/subscenes/game_over.tscn')
onready var light_animation = get_node('Node/light_flash/AnimationPlayer')

var game_over_container
var current_state

var current_input_timeout = 0
export var guess_timout = .1

var levels
export var current_level = 0

func _ready():
	levels = [
		preload('intro_level.gd').IntroLevel.new(),
		preload('level1_5.gd').Level1_5.new().setup(light_animation),
		preload('level2.gd').Level2.new(),
		preload('level3.gd').Level3.new(),
		preload('level4.gd').Level4.new(),
		preload('level4_5.gd').Level4_5.new().setup(light_animation)
	]
	
	dialogue_state.connect('input_received', self, '_reset_input_timeout')
	dialogue_state.connect('exit', self, '_dialogue_state_ended')
	
	repeat_play_state.connect('input_received', self, '_reset_input_timeout')
	repeat_play_state.connect('exit', self, '_repeat_play_state_ended')
	repeat_play_state.connect('game_over', self, '_game_over')
	repeat_play_state.connect('show_arrow', arrow_controller, 'display_arrow')
	repeat_play_state.connect('play_direction', self, 'play_direction')
	repeat_play_state.connect('show_spotlight', self, 'show_spotlight')
	
	freestyle_state.connect('input_received', self, '_reset_input_timeout')
	freestyle_state.connect('exit', self, '_freestyle_state_ended')
	freestyle_state.connect('game_over', self, '_game_over')
	freestyle_state.connect('show_arrow', arrow_controller, 'display_arrow')
	freestyle_state.connect('play_direction', self, 'play_direction')
	freestyle_state.connect('show_spotlight', self, 'show_spotlight')
	
	player_spotlight.hide()
	enemy_spotlight.hide()
	
	#load game
	if scene_state.autoload_level != null && scene_state.autoload_stage != null:
		current_level = scene_state.autoload_level
		levels[current_level].current_stage = scene_state.autoload_stage
	
	levels[current_level].get_current_stage().emit_signal('entry')
	switch_state(dialogue_state, levels[current_level].get_current_stage())
	
	#DEBUG
	#switch_state(freestyle_state, levels[current_level].get_current_stage())
	
	if !levels[current_level].info_level:
		opp_character_animation.set_sprite(current_level)
		opp_character_animation.enter()

	self.set_process_input(true)
	self.set_process(true)
	
func _input(event):
	if(current_state != null and current_input_timeout >= guess_timout):
		current_state.input(event)

func _process(delta):
	current_input_timeout += delta
	
func _restart_level():
	remove_child(game_over_container)
	if current_state != null:
		current_state.exit(true)
		current_state = null
	#levels[current_level].restart_level()	
	switch_state(dialogue_state, levels[current_level].get_current_stage())

func _reset_input_timeout():
	current_input_timeout = 0

func _dialogue_state_ended():
	if levels[current_level].info_level:
		#level is done now
		current_level += 1
		if current_level >= levels.size():
			_goto_menu()
			return

		levels[current_level].get_current_stage().emit_signal('entry')
		opp_character_animation.set_sprite(current_level)
		opp_character_animation.enter()
		switch_state(dialogue_state, levels[current_level].get_current_stage())
		return
	switch_state(repeat_play_state, levels[current_level].get_current_stage())
	
func _repeat_play_state_ended():
	switch_state(freestyle_state, levels[current_level].get_current_stage())

func _freestyle_state_ended():
	if !levels[current_level].advance_stage():
		current_level += 1
		levels[current_level].get_current_stage().emit_signal('entry')
		opp_character_animation.exit()
		if !levels[current_level].info_level:
			opp_character_animation.set_sprite(current_level)
			opp_character_animation.enter()

	_save_game(current_level, levels[current_level].current_stage)
	switch_state(dialogue_state, levels[current_level].get_current_stage())
	
func show_spotlight(light):
	var target = player_spotlight
	var other = enemy_spotlight
	if light == 'off':
		target.hide()
		other.hide()
		return
		
	if light == 'enemy':
		target = enemy_spotlight
		other = player_spotlight
		
	target.show()
	other.hide()	

func switch_state(state, stage):
	current_state = state
	current_state.entry(stage)

func play_direction(character, direction):
	var target = main_character_animation
	if character == 'enemy':
		target = opp_character_animation
	
	if direction == 'left':
		target.left()
	elif direction == 'right':
		target.right()
	elif direction == 'up':
		target.up()
	elif direction == 'down':
		target.down()			

func _game_over():
	game_over_container = game_over_res.instance()
	add_child(game_over_container)
	get_node('game_over/restart_button').connect('button_up', self, '_restart_level')
	get_node('game_over/menu_button').connect('button_up', self, '_goto_menu')
	current_state = null
	
func _save_game(level, stage):
	print('saving game...')
	var save_data = {
		level=level,
		stage=stage
	}
	var savegame = File.new()
	savegame.open('user://savegame.save', File.WRITE)
	savegame.store_line(save_data.to_json())
	savegame.close()
	
func _goto_menu():
	get_tree().change_scene('res://scenes/Menu.tscn')