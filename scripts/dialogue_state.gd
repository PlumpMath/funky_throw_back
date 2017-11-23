extends Node 
signal input_received
signal exit

var current_dialogue = -1
var current_dialogue_char = -1
var dialogues = []

export var character_timer = 0.05
var _active = false

onready var dialogue_text = get_node('dialogue_text')
onready var dialogue_background = get_node('dialogue_background')
onready var dialogue_print_timer = get_node('dialogue_print_timer')

func _ready():
	dialogue_print_timer.set_wait_time(character_timer)
	dialogue_print_timer.set_one_shot(false)
	dialogue_print_timer.start()
	dialogue_print_timer.connect("timeout", self, "_advance_dialogue_char")

func entry(stage):
	_active = true
	current_dialogue = -1
	dialogues = stage.dialogue
	dialogue_background.show()
	_advance_dialogue()
	
func exit(skip_signal):
	_active = false
	dialogue_background.hide()
	dialogue_text.set_text('')
	if !skip_signal:
		emit_signal('exit')
	
func input(event):
	if event.type == InputEvent.KEY:
		if	event.is_action_released('ui_interact'):
			emit_signal('input_received')
			if current_dialogue_char + 1 < dialogues[current_dialogue].length():
				current_dialogue_char = dialogues[current_dialogue].length() - 2
			else:	
				_advance_dialogue()
	
func _advance_dialogue():
	if current_dialogue + 1 < dialogues.size():
		current_dialogue+=1
		current_dialogue_char = -1
	else:
 		exit(false)
	
func _advance_dialogue_char():
	if _active and current_dialogue_char < dialogues[current_dialogue].length():
		current_dialogue_char += 1
		var current_string = ''
		for i in range(0, current_dialogue_char, 1):
			current_string += dialogues[current_dialogue][i] 
		dialogue_text.set_text(current_string)