extends Node

onready var arrow = get_node("arrow")
onready var arrow_display_animation = get_node("arrow/displayAnimationPlayer")
onready var player_arrow_position = get_node("player_arrow_position").get_pos()
onready var enemy_arrow_position = get_node("enemy_arrow_position").get_pos()

func display_arrow(positionStr, direction):
	var position = player_arrow_position
	if positionStr == 'enemy':
		position = enemy_arrow_position
	
	var rotation = 0
	if direction == 'down':
		rotation = PI / 2
	elif direction == 'right':
		rotation = PI
	elif direction == 'up':
		rotation = 3 * PI / 2
		
	arrow.set_pos(position)
	arrow.set_rot(rotation)
	
	arrow_display_animation.stop()
	arrow_display_animation.seek(0)
	arrow_display_animation.play("displayAnimation")