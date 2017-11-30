extends Node

class Level4:
	const level_stage = preload('res://scripts/level_stage.gd').LevelStage
	const info_level = false
	const speaker_name = "OLD CHUMP"
	
	#stage 1
	var dialogue1 = [
		"Well... well... well",
		"Looks like you finally decided to show back up",
		"TIME FOR A REMATCH"
	]
	
	var move_time1 = 2
	var move_playback_time1 = 1
	var moves1 = [5, 5, 5, 5, 5]
	
	var num_freestyle_moves1 = 8
	var freestyle_time1 = 2
	
	var stage1 = level_stage.new().setup(dialogue1, move_time1, move_playback_time1, moves1, num_freestyle_moves1, freestyle_time1, speaker_name)
	
	
	#stage 2
	var dialogue2 = [
		"After you disappeared I was the the king of this club",
		"And now...",
		"I can\'t have you go and ruin it."
	]
	
	var move_time2 = 2
	var move_playback_time2 = 1
	var moves2 = [6,6,6]
	
	var num_freestyle_moves2 = 12
	var freestyle_time2 = 2
	
	var stage2 = level_stage.new().setup(dialogue2, move_time2, move_playback_time2, moves2, num_freestyle_moves2, freestyle_time2, speaker_name)
	
	var current_stage = 0
	var stages = [stage1, stage2]
	
	func get_current_stage():
		return stages[current_stage]
		
	func advance_stage():
		if current_stage + 1 < stages.size():
			current_stage += 1
			return true
		return false	
		
	func restart_level():
		current_stage = 0	
		