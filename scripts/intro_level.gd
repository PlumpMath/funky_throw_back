extends Node

class IntroLevel:
	const level_stage = preload('res://scripts/level_stage.gd').LevelStage
	
	var dialogue1 = [
		"Oh, man BRO.",
		"What do we have here?!",
		"Looks like a CHUMP!!!",
		"Well, chump? Why don\'t you say something?",
		"OH I GET IT!",
		"This dude thinks he\'s too good to talk to us.",
		"Well you better GROOVE better thank you talk, CHUMP!"
	]
	
	var move_time1 = 2
	var move_playback_time1 = 1
	var moves1 = [2, 2, 2, 4]
	
	var num_freestyle_moves1 = 4
	var freestyle_time1 = 1
	
	var stage1 = level_stage.new().setup(dialogue1, move_time1, move_playback_time1, moves1, num_freestyle_moves1, freestyle_time1)
	
	var current_stage = 0
	var stages = [stage1]
	
	func get_current_stage():
		return stages[current_stage]
		
	func advance_stage():
		if current_stage + 1 < stages.size():
			current_stage += 1
			return true
		return false	