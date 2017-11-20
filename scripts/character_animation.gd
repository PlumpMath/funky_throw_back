extends Node
onready var animator = get_node('./AnimationPlayer')

func _ready():
	#animator.play('idle')
	pass

func left():
	animator.play('left')

func right():
	animator.play('right')
	
func up():
	animator.play('up')

func down():
	animator.play('down')	