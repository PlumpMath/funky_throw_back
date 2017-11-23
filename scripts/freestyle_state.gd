extends Node
signal input_received
signal game_over
signal exit
signal show_arrow
signal play_direction

onready var guess_timer = get_node('guess_timer')
onready var freestyle_text = get_node('freestyle_text')
onready var header_text_timer = get_node('header_text_timer')

const possible_moves = ['up', 'down', 'left', 'right']
const game_move = preload('game_move.gd').GameMove

var freestyle_moves
var freestyle_move_index = -1
var current_stage

export var header_text_time = 2

func _ready():
	header_text_timer.set_one_shot(true)
	header_text_timer.connect("timeout", self, "_freestyle_text_end")
	header_text_timer.set_wait_time(header_text_time)

func entry(stage):
	current_stage = stage
	freestyle_move_index = -1
	freestyle_moves = _generate_freestyle_moves(stage.num_freestyle_moves)
	freestyle_text.showAni()
	header_text_timer.start()
	
func _freestyle_text_end():
	freestyle_text.hideAni()
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
			emit_signal('play_direction', 'player', current_input)
			freestyle_moves[freestyle_move_index].guess_input(current_input)
		
func _next_move():
	if freestyle_move_index + 1 < freestyle_moves.size():
		freestyle_move_index += 1
		emit_signal("show_arrow", "player", freestyle_moves[freestyle_move_index].direction)
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
		current_moves.append(game_move.new().setup(possible_moves[rand_range(0, possible_moves.size())], current_stage.freestyle_time, guess_timer) )
	return current_moves