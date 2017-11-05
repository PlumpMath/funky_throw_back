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
	current_move+=1
	moves[current_move].connect("guess_timeout", self, "_time_up")
	moves[current_move].connect("correct_guess", self, "_correct_guess")
	moves[current_move].connect("incorrect_guess", self, "_incorrect_guess")
	moves[current_move].start_guess_timer()