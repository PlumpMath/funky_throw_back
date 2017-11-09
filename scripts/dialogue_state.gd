extends Node 
signal input_received
signal exit

var current_dialogue = -1
var dialogues = []

onready var dialogue_text = get_node('dialogue_text')

func entry(level):
	current_dialogue = -1
	dialogues = level.dialogue
	_advance_dialogue()
	
func exit():
	emit_signal('exit')
	
func input(event):
	if event.type == InputEvent.KEY:
		if	event.is_action_released('ui_interact'):
			emit_signal('input_received')
			_advance_dialogue()
	
func _advance_dialogue():
	if current_dialogue + 1 < dialogues.size():
		current_dialogue+=1
		dialogue_text.set_text(dialogues[current_dialogue])
	else:
		exit()
	