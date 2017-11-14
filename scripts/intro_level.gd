extends Node
class IntroLevel:
	
	var dialogue = [
		"Oh, man BRO.",
		"What do we have here?!",
		"Looks like a CHUMP!!!",
		"Well, chump? Why don\'t you say something?",
		"OH I GET IT!",
		"This dude thinks he\'s too good to talk to us.",
		"Well you better GROOVE better thank you talk, CHUMP!"
	]
		
	var post_dialogue = [
		"..."
	]
	
	var move_time = 2
	var move_playback_time = 1
	var moves = [2, 2, 2, 4, 3, 3, 4, 2, 5, 4, 5, 5]
	
	var num_freestyle_moves = 20
	var free_style_time = 1