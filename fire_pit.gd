extends Node2D

func _ready() -> void:
	for fire in get_children():
		if fire is AnimatedSprite2D:
			await get_tree().create_timer(randf() / 1000).timeout
			fire.play()
