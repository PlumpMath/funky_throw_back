extends Node


class Level1_5:
	const level_stage = preload('res://scripts/level_stage.gd').LevelStage
	const info_level = true
	const speaker_name = "UNKNOWN"
	
	#stage 1
	var dialogue1 = [
		"JUST THEN, DUE TO EXCESSIVE GROOVE...",
		"THE YOUNG CHUMP WAS THROWN INTO THE FUTURE...",
		"TO FIND HIMSELF IN THE SAME CLUB",
		"HOW WILL HE FIND HIS WAY HOME?"
	]
	
	
	var stage1 = level_stage.new().setup(dialogue1, 0, 0, null, 0, 0, speaker_name)
	
	
	var current_stage = 0
	var stages = [stage1]
	
	func _init():
		print('test')
		stage1.connect('entry', self, '_play_light_animation')
	
	func get_current_stage():
		return stages[current_stage]
		
	func advance_stage():
		if current_stage + 1 < stages.size():
			current_stage += 1
			return true
		return false	
		
	func restart_level():
		current_stage = 0
	
	func _play_light_animation():
		print('LIGHT ANIMATION')
	