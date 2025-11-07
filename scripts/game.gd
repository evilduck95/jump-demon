extends Node2D

@onready var credits = $"ui/pause screen"

func _on_credits_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		set_pause(true)

func _on_credits_close(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		set_pause(false)

func set_pause(state):
	get_tree().paused = state
	credits.visible = state
