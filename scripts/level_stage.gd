class LevelStage:
	signal entry
	
	var dialogue
	var move_time
	var move_playback_time
	var moves
	var num_freestyle_moves
	var freestyle_time
	var speaker_name
		
	func setup(_dialogue, _move_time, _move_playback_time, _moves, _num_freestyle_moves, _freestyle_time, _speaker_name):
		dialogue = _dialogue
		move_time = _move_time
		move_playback_time = _move_playback_time
		moves = _moves
		num_freestyle_moves = _num_freestyle_moves
		freestyle_time = _freestyle_time
		speaker_name = _speaker_name
		return self
