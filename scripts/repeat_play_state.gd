extends Node 
signal input_received
signal exit
signal game_over
signal show_arrow
signal play_direction

onready var guess_timer = get_node("guess_timer")
onready var playback_timer = get_node("playback_timer")
onready var round_timer = get_node("round_timer")
onready var follow_leader_text = get_node("follow_leader_text")
onready var header_text_timer = get_node("header_text_timer")

const game_move = preload('game_move.gd').GameMove
var moves

var current_stage

# current set of moves
var current_move_stage

#position in the current move set
var current_move_set

export var round_break_time = 2

export var header_text_time = 2

var current_move_playback_pos

enum states{
	PLAYBACK
	USER_REPEAT
}
var current_state

const possible_moves = ['up', 'down', 'left', 'right']

func _ready():
	playback_timer.set_one_shot(true)
	playback_timer.connect("timeout", self, "_playback_next_move")
	
	round_timer.set_one_shot(true)
	round_timer.connect("timeout", self, "_next_round_timer_up")
	round_timer.set_wait_time(round_break_time)
	
	header_text_timer.set_one_shot(true)
	header_text_timer.connect("timeout", self, "_header_over")
	header_text_timer.set_wait_time(header_text_time)

func entry(stage):
	randomize()
	
	playback_timer.set_wait_time(stage.move_playback_time)
	
	current_stage = stage
	current_move_stage = -1
	current_move_set = -1
	current_move_playback_pos = -1
	follow_leader_text.showAni()
	header_text_timer.start()
	
func _header_over():
	follow_leader_text.hideAni()
	_set_over()
	
func exit(skip_signal):
	if !skip_signal:
		emit_signal('exit')
	
func input(event):
	if current_state == states.USER_REPEAT and  event.type == InputEvent.KEY:
		var current_input = ""
		if event.is_action_released('ui_up'):
			current_input = "up"
		elif event.is_action_released('ui_down'):
			current_input = "down"
		elif event.is_action_released('ui_left'):
			current_input = "left"
		elif event.is_action_released('ui_right'):
			current_input = "right"	
			
		if(current_input != ""):
			emit_signal('input_received')
			moves[current_move_stage].guess_input(current_input)

func _game_over():
	emit_signal('game_over')

func _correct_guess():
	print('Correct Guess!')
	emit_signal("show_arrow", "player", moves[current_move_stage].direction)
	emit_signal('play_direction', 'player', moves[current_move_stage].direction)
	_wait_for_next_move()
	
func _next_round_timer_up():
	_set_over()

func _incorrect_guess():
	_game_over()

func _time_up():
	_game_over()
	
func _generate_next_moves(num):
	var current_moves = []
	for i in range(0, num):
		current_moves.append(game_move.new().setup(possible_moves[rand_range(0, possible_moves.size())], current_stage.move_time, guess_timer) )
	return current_moves	
		
func _set_over():
	if current_move_set + 1 < current_stage.moves.size():
		current_move_set += 1
		moves = _generate_next_moves(current_stage.moves[current_move_set])
		current_move_stage = -1
		
		current_state = states.PLAYBACK
		current_move_playback_pos = -1
		_playback_next_move()
	else:
		emit_signal('exit')

func _playback_next_move():
	if current_move_playback_pos + 1 < moves.size():
		current_move_playback_pos += 1
		print(moves[current_move_playback_pos].direction)
		emit_signal('show_arrow', 'enemy', moves[current_move_playback_pos].direction)
		emit_signal('play_direction', 'enemy', moves[current_move_playback_pos].direction)
		playback_timer.start()
	else:
		current_state = states.USER_REPEAT
		_wait_for_next_move()	

func _wait_for_next_move():
	print('waitForNextMove')
	if current_move_stage + 1 < moves.size():
		current_move_stage+=1
		moves[current_move_stage].connect("guess_timeout", self, "_time_up")
		moves[current_move_stage].connect("correct_guess", self, "_correct_guess")
		moves[current_move_stage].connect("incorrect_guess", self, "_incorrect_guess")
		moves[current_move_stage].start_guess_timer()
	else:
		round_timer.start()
