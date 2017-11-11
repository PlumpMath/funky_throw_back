extends Node

onready var play_button = get_node('play_button')

func _ready():
	play_button.connect("button_down", self, "_play_button_press")

func _play_button_press():
	get_tree().change_scene('res://scenes/Main.tscn')