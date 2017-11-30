
class Level4_5:
	const level_stage = preload('res://scripts/level_stage.gd').LevelStage
	const info_level = true
	const speaker_name = "UNKNOWN"
	var light_animation
	
	#stage 1
	var dialogue1 = [
		"WITH THAT, THE YOUNG CHUMP HAD PROVEN HIMSELF FOR ALL TIME",
		"HIS SICK DANCE MOVES HAD ONCE AGAIN OPENED THE PORTAL",
		"HE WAS BACK HOME TO TAKE THE THROWN AS...",
		"RETRO TIME THROW BACK KING",
		"(Congradulations and thank you for playing!)"
	]
	
	
	var stage1 = level_stage.new().setup(dialogue1, 0, 0, null, 0, 0, speaker_name)
	
	
	var current_stage = 0
	var stages = [stage1]
	
	func _init():
		print('test')
		stage1.connect('entry', self, '_play_light_animation')
		
	func setup(_light_animation):
		light_animation = _light_animation
		return self	
	
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
		light_animation.play('flash')
	