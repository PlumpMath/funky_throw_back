extends Node 
signal input_received
signal exit
signal game_over

onready var guess_timer = get_node("guess_timer")
onready var playback_timer = get_node("playback_timer")
onready var round_timer = get_node("round_timer")
onready var arrow = get_node("arrow")
onready var arrow_display_animation = get_node("arrow/displayAnimationPlayer")
onready var player_arrow_position = get_node("player_arrow_position").get_pos()
onready var enemy_arrow_position = get_node("enemy_arrow_position").get_pos()

const game_move = preload('game_move.gd').GameMove
var moves

var current_level

# current set of moves
var current_move_stage

#position in the current move set
var current_move_set

var round_break_time = 2

var current_move_playback_pos

enum states{
	PLAYBACK
	USER_REPEAT
}
var current_state

var possible_moves = ['up', 'down', 'left', 'right']

func _ready():
	playback_timer.set_one_shot(true)
	playback_timer.connect("timeout", self, "_playback_next_move")
	
	round_timer.set_one_shot(true)
	round_timer.connect("timeout", self, "_next_round_timer_up")
	round_timer.set_wait_time(round_break_time)

func entry(level):
	randomize()
	
	playback_timer.set_wait_time(level.move_playback_time)
	
	current_level = level
	current_move_stage = -1
	current_move_set = -1
	current_move_playback_pos = -1
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
	display_arrow(player_arrow_position, moves[current_move_stage].direction)
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
		current_moves.append(game_move.new().setup(possible_moves[rand_range(0, possible_moves.size())], current_level.move_time, guess_timer) )
	return current_moves	
		
func _set_over():
	if current_move_set + 1 < current_level.moves.size():
		current_move_set += 1
		moves = _generate_next_moves(current_level.moves[current_move_set])
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
		display_arrow(enemy_arrow_position, moves[current_move_playback_pos].direction)
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
	
func display_arrow(position, direction):
	var rotation = 0
	if direction == 'down':
		rotation = PI / 2
	elif direction == 'right':
		rotation = PI
	elif direction == 'up':
		rotation = 3 * PI / 2
		
	arrow.set_pos(position)
	arrow.set_rot(rotation)
	arrow_display_animation.play("displayAnimation")