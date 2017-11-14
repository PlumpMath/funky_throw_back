extends Node

onready var dialogue_state = get_node('states/dialogue_state')
onready var repeat_play_state = get_node('states/play_repeat_state')
onready var game_over_res = preload('res://scenes/subscenes/game_over.tscn')
var game_over_container
var current_state

var current_input_timeout = 0
export var guess_timout = .1

var levels
var current_level = 0

func _ready():
	levels = [preload('intro_level.gd').IntroLevel.new()]
	
	dialogue_state.connect('input_received', self, '_reset_input_timeout')
	dialogue_state.connect('exit', self, '_dialogue_state_ended')
	
	repeat_play_state.connect('input_received', self, '_reset_input_timeout')
	repeat_play_state.connect('exit', self, '_repeat_play_state_ended')
	repeat_play_state.connect('game_over', self, '_game_over')
	
	switch_state(dialogue_state, levels[current_level])
	
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
	switch_state(dialogue_state, levels[current_level])

func _reset_input_timeout():
	current_input_timeout = 0

func _dialogue_state_ended():
	switch_state(repeat_play_state, levels[current_level])
	
func _repeat_play_state_ended():
	print('end of current play?')
	#switch_state(repeat_play_state, levels[current_level])	

func switch_state(state, level):
	current_state = state
	current_state.entry(level)

func _game_over():
	game_over_container = game_over_res.instance()
	add_child(game_over_container)
	get_node('game_over/restart_button').connect('button_down', self, '_restart_level')
	
	current_state = null
	
