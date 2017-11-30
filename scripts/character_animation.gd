extends Node
onready var animator = get_node('./character/AnimationPlayer')

func _ready():
	if animator != null:
		animator.connect("finished", self, '_return_to_idle')

func left():
	animator.play('left')

func right():
	animator.play('right')
	
func up():
	animator.play('up')

func down():
	animator.play('down')

func enter():
	animator.play('enter')

func exit():
	animator.play('exit')
	
func set_lightning(enable):
	var lightning
	lightning = get_node('./character/lightning/lightning1')
	if lightning != null:
		lightning.set_emitting(enable)
	lightning = get_node('./character/lightning/lightning2')
	if lightning != null:
		lightning.set_emitting(enable)

func _return_to_idle():
	animator.play('idle')
	
