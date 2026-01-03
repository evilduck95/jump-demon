extends Node2D

@onready var credits = $"ui/pause screen"
@onready var pause_button = $"ui/pause button"

func _on_credits_clicked(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		set_pause(true)
		pause_button.visible = false

func _on_credits_close(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		set_pause(false)
		pause_button.visible = true

func set_pause(state):
	get_tree().paused = state
	credits.visible = state
