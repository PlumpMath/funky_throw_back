extends Node

const game_move = preload('game_move.gd').GameMove
var moves = []
enum GAME_STATE{
	MENU,
	RUNNING,
	GAME_OVER
}
var current_state
var current_move = -1
var guess_timer

var current_guess_timeout = 0

export var guess_timout = .1

func _ready():
	guess_timer = get_node("guess_timer")
	
	moves = [
		game_move.new().setup('up', 2, guess_timer),
		game_move.new().setup('down', 2, guess_timer),
		game_move.new().setup('left', 2, guess_timer),
		game_move.new().setup('right', 2, guess_timer)
	]

	current_state = GAME_STATE.RUNNING
	_next_move()
	self.set_process_input(true)
	self.set_process(true)
	
func _process(delta):
	current_guess_timeout += delta

func _input(event):
	if event.type == InputEvent.KEY and current_guess_timeout >= guess_timout:
		var current_input = ""
		if	event.scancode == KEY_UP:
			current_input = "up"
		elif	event.scancode == KEY_DOWN:
			current_input = "down"
		elif	event.scancode == KEY_LEFT:
			current_input = "left"
		elif	event.scancode == KEY_RIGHT:
			current_input = "right"	
			
		if(current_input != ""):
			current_guess_timeout = 0
			moves[current_move].guess_input(current_input)

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
	print("next move...")
	if current_move + 1 < moves.size():
		current_move+=1
		moves[current_move].connect("guess_timeout", self, "_time_up")
		moves[current_move].connect("correct_guess", self, "_correct_guess")
		moves[current_move].connect("incorrect_guess", self, "_incorrect_guess")
		moves[current_move].start_guess_timer()