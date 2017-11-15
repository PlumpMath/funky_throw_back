extends Node
signal input_received
signal game_over
signal exit

onready var guess_timer = get_node('guess_timer')

const possible_moves = ['up', 'down', 'left', 'right']
const game_move = preload('game_move.gd').GameMove

var freestyle_moves
var freestyle_move_index = -1
var current_level

func _ready():
	pass

func entry(level):
	current_level = level
	freestyle_move_index = -1
	freestyle_moves = _generate_freestyle_moves(level.num_freestyle_moves)
	_next_move()
	
func exit(skip_signal):
	if !skip_signal:
		emit_signal('exit')
		
func input(event):
	if event.type == InputEvent.KEY:
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
			freestyle_moves[freestyle_move_index].guess_input(current_input)
		
func _next_move():
	#TODO
	#Display arrow for move (float down?)
	if freestyle_move_index + 1 < freestyle_moves.size():
		freestyle_move_index += 1
		freestyle_moves[freestyle_move_index].connect("guess_timeout", self, "_time_up")
		freestyle_moves[freestyle_move_index].connect("correct_guess", self, "_correct_guess")
		freestyle_moves[freestyle_move_index].connect("incorrect_guess", self, "_incorrect_guess")
		freestyle_moves[freestyle_move_index].start_guess_timer()	
		
func _time_up():
	_game_over()
	
func _incorrect_guess():
	_game_over()
	
func _correct_guess():
	_next_move()
	
func _game_over():
	emit_signal('game_over')	

func _generate_freestyle_moves(num):
	var current_moves = []
	for i in range(0, num):
		current_moves.append(game_move.new().setup(possible_moves[rand_range(0, possible_moves.size())], current_level.freestyle_time, guess_timer) )
	return current_moves