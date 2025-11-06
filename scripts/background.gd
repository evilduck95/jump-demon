extends Node2D

@onready var overflow_bg = $overflow

const SPEED = 100

func _process(delta): 
	if overflow_bg.global_position.x <= 0:
		position.x = 0;
	else:
		position.x -= SPEED * delta;
