extends Node

class Level2:
	const level_stage = preload('res://scripts/level_stage.gd').LevelStage
	
	const enemy_name = "ROXIE"
	
	#stage 1
	var dialogue1 = [
		"Well, hello there!",
		"Hhhhheeeyyyyy, BOSS!",
		"Looks like he finally showed back up!",
		"The boss said you disappeared a long time ago...",
		"... and if you ever returned, WE WERE SUPPOSED TO CRUSH YOU (duh)."
	]
	
	var move_time1 = 2
	var move_playback_time1 = 1
	var moves1 = [3, 3, 4, 4, 4]
	
	var num_freestyle_moves1 = 4
	var freestyle_time1 = 2
	
	var stage1 = level_stage.new().setup(dialogue1, move_time1, move_playback_time1, moves1, num_freestyle_moves1, freestyle_time1, enemy_name)
	
	
	#stage 2
	var dialogue2 = [
		"Okay, seriously, not cool.",
		"This is like, my ONLY job today.",
		"So can you just mess up, please? Thx <3"
	]
	
	var move_time2 = 2
	var move_playback_time2 = 1
	var moves2 = [4, 4, 5, 5, 6]
	
	var num_freestyle_moves2 = 6
	var freestyle_time2 = 2
	
	var stage2 = level_stage.new().setup(dialogue2, move_time2, move_playback_time2, moves2, num_freestyle_moves2, freestyle_time2, enemy_name)
	
	
	#stage 3
	var dialogue3 = [
		"FOR REAL, NOT COOL.",
		"I THOUGHT you were cute.",
		"DEFINITELY NOT NOW!!!"
	]
	var move_time3 = 2
	var move_playback_time3 = 1
	var moves3 = [5, 5, 5, 6]
	
	var num_freestyle_moves3 = 8
	var freestyle_time3 = 2
	
	var stage3 = level_stage.new().setup(dialogue3, move_time3, move_playback_time3, moves3, num_freestyle_moves3, freestyle_time3, enemy_name)
	
	
	var current_stage = 0
	var stages = [stage1, stage2, stage3]
	
	func get_current_stage():
		return stages[current_stage]
		
	func advance_stage():
		if current_stage + 1 < stages.size():
			current_stage += 1
			return true
		return false	
		
	func restart_level():
		current_stage = 0	
	