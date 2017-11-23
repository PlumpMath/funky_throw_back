extends Node

onready var player = get_node("AnimationPlayer")

func showAni():
	player.play('show')
	
func hideAni():
	player.play('hide')	