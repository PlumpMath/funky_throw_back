class GameMove:
	extends Node
	signal guess_timeout
	signal correct_guess
	signal incorrect_guess
	
	var direction = ''
	var guessTime = 0
	var guess_timer
	
	var guessed = false
	
	func setup(_direction, _time, _timer):
		guessTime = _time
		direction = _direction
		guess_timer = _timer
		return self
		
	func start_guess_timer():
		print("starting guess timer...")
		guessed = false
		
		guess_timer.set_wait_time(guessTime)
		guess_timer.set_one_shot(true)
		guess_timer.connect("timeout", self, "_on_guess_timeout")
		guess_timer.start()
			
	func _on_guess_timeout():
		print('timer ended', guessed)
		if !guessed:
			emit_signal('guess_timeout')
			
	func guess_input(input):
		guessed = true
		if input == direction:
			emit_signal('correct_guess')
		else:
			emit_signal('incorrect_guess')