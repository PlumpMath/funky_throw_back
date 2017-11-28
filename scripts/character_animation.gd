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
	
func _return_to_idle():
	animator.play('idle')	