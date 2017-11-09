extends Node 
signal input_received
signal exit
signal game_over

onready var guess_timer = get_node("guess_timer")
var moves
var current_move

func entry(level):
	level.setup_moves(guess_timer)
	moves = level.moves
	current_move = -1
	_next_move()
	pass
	
func exit():
	emit_signal('exit')
	
func input(event):
	if event.type == InputEvent.KEY:
		var current_input = ""
		if	event.is_action_released('ui_up'):
			current_input = "up"
		elif	event.is_action_released('ui_down'):
			current_input = "down"
		elif	event.is_action_released('ui_left'):
			current_input = "left"
		elif	event.is_action_released('ui_right'):
			current_input = "right"	
			
		if(current_input != ""):
			emit_signal('input_received')
			moves[current_move].guess_input(current_input)

func _game_over():
	emit_signal('game_over')

func _correct_guess():
	print('Correct Guess!')
	_next_move()

func _incorrect_guess():
	_game_over()

func _time_up():
	_game_over()
	
func _next_move():
	if current_move + 1 < moves.size():
		current_move+=1
		moves[current_move].connect("guess_timeout", self, "_time_up")
		moves[current_move].connect("correct_guess", self, "_correct_guess")
		moves[current_move].connect("incorrect_guess", self, "_incorrect_guess")
		moves[current_move].start_guess_timer()
	else:
		emit_signal('exit')	