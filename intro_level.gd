extends Node
class IntroLevel:
	const game_move = preload('game_move.gd').GameMove
	
	var dialogue
	var post_dialogue
	var moves
	
	func setup(guess_timer):
		dialogue = [
			'Oh, man BRO.',
			'What do we have here?!',
			'Looks like a CHUMP!!!',
			'Well, chump? Why don\t you say something?',
			'OH I GET IT!',
			'This dude thinks he\'s too good to talk to us.',
			'Well you better GROOVE better thank you talk, CHUMP!'
		]
		
		post_dialogue = [
			'...'
		]
		
		moves = [
			game_move.new().setup('up', 2, guess_timer),
			game_move.new().setup('down', 2, guess_timer),
			game_move.new().setup('left', 2, guess_timer),
			game_move.new().setup('right', 2, guess_timer)
		]
		
		return self