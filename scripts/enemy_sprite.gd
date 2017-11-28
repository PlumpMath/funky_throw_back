extends 'res://scripts/character_animation.gd'

onready var sprite = get_node('./character/Sprite')
onready var enemy_sprites = [
	load('res://images/enemy1.png'),
	load('res://images/enemy2.png'),
	load('res://images/enemy3.png'),
	load('res://images/enemy4.png')
]

func set_sprite(num):
		pass
		#sprite.set_texture(enemy_sprites[num])