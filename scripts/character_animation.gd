extends Node
onready var animator = get_node('./AnimationPlayer')

func _ready():
	animator.connect("finished", self, '_return_to_idle')
	pass

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