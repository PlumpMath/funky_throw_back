extends Node
signal input_received
signal exit

onready var input_timer = get_node('input_timer')

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
		pass 
		
func _next_move():
	if freestyle_move_index + 1 < freestyle_moves.size():
		freestyle_move_index += 1
		freestyle_moves[freestyle_move_index]
		#TODO
		freestyle_moves[freestyle_move_index].connect("guess_timeout", self, "_time_up")
		freestyle_moves[freestyle_move_index].connect("correct_guess", self, "_correct_guess")
		freestyle_moves[freestyle_move_index].connect("incorrect_guess", self, "_incorrect_guess")
		freestyle_moves[freestyle_move_index].start_guess_timer()	
		
func _generate_freestyle_moves(num):
	var current_moves = []
	for i in range(0, num):
		current_moves.append(game_move.new().setup(possible_moves[rand_range(0, possible_moves.size())], level.freestyle_moves, guess_timer) )
	return current_moves