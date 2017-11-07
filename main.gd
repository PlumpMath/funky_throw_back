extends Node

var current_move = -1
var moves = []

var current_dialogue = -1
var dialogues = []

enum GAME_STATE{
	MENU,
	PLAYING,
	GAME_OVER,
	DIALOGUE
}
var current_state


var current_input_timeout = 0

export var guess_timout = .1

var levels
var current_level = 0

var guess_timer

var dialogue_text

func _ready():
	dialogue_text = get_node('dialogue_text')

	guess_timer = get_node("guess_timer")
	levels = [preload('intro_level.gd').IntroLevel.new().setup(guess_timer)]
	
	moves = levels[current_level].moves
	dialogues = levels[current_level].dialogue
	start_dialogue_state()
	
	self.set_process_input(true)
	self.set_process(true)
	
func _process(delta):
	current_input_timeout += delta

func _input(event):
	if current_state == GAME_STATE.PLAYING and event.type == InputEvent.KEY and current_input_timeout >= guess_timout:
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
			current_input_timeout = 0
			moves[current_move].guess_input(current_input)
	
	elif current_state == GAME_STATE.DIALOGUE and event.type == InputEvent.KEY:
		if	event.is_action_released('ui_interact'):
			current_input_timeout = 0
			_advance_dialogue()

func start_dialogue_state():
	current_state = GAME_STATE.DIALOGUE
	current_dialogue = -1
	_advance_dialogue()

func start_playing_state():
	current_state = GAME_STATE.PLAYING
	current_move = -1	
	_next_move()

func _advance_dialogue():
	if current_dialogue + 1 < dialogues.size():
		current_dialogue+=1
		dialogue_text.set_text(dialogues[current_dialogue])
	else:
		start_playing_state()

func _incorrect_guess():
	_game_over()

func _time_up():
	print('main: time up')
	_game_over()

func _game_over():
	print('Game over!')
	current_state = GAME_STATE.GAME_OVER
	
func _correct_guess():
	print('Correct Guess!')
	_next_move()
	
func _next_move():
	if current_move + 1 < moves.size():
		current_move+=1
		moves[current_move].connect("guess_timeout", self, "_time_up")
		moves[current_move].connect("correct_guess", self, "_correct_guess")
		moves[current_move].connect("incorrect_guess", self, "_incorrect_guess")
		moves[current_move].start_guess_timer()