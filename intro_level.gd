class intro_level:
	const game_move = preload('game_move.gd').GameMove
	onready var guess_timer = get_node("guess_timer")
	
	var dialogue = [
		'Oh, man BRO.',
		'What do we have here?!',
		'Looks like a CHUMP!!!',
		'Well, chump? Why don\t you say something?',
		'OH I GET IT!',
		'This dude thinks he\'s too good to talk to us.',
		'Well you better GROOVE better thank you talk, CHUMP!'
	]
	
	var post_dialogue = [
		'...'
	]
	
	var moves = [
		game_move.new().setup('up', 2, guess_timer),
		game_move.new().setup('down', 2, guess_timer),
		game_move.new().setup('left', 2, guess_timer),
		game_move.new().setup('right', 2, guess_timer)
	]