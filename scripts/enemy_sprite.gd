extends 'res://scripts/character_animation.gd'

var entering
var exiting

export var present_x = 806
export var outside_x = 1224

onready var enemy_scenes = [
	load('res://scenes/subscenes/enemy1.tscn'),
	null,
	load('res://scenes/subscenes/enemy2.tscn'),
	load('res://scenes/subscenes/enemy3.tscn'),
	load('res://scenes/subscenes/enemy4.tscn')
]

func set_sprite(num):
	remove_child(get_node('character'))
	var new_enemy = enemy_scenes[num].instance()
	add_child(new_enemy)
	
	animator = new_enemy.get_node('./AnimationPlayer')
	animator.connect("finished", self, '_return_to_idle')
	