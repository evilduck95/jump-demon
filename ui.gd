extends Node2D

@onready var score_label = $score
@onready var intro_label = $intro
@onready var game_over_screen = $"game over screen"
@onready var credits = $credits

var current_score: int = 0
var game_over = false

func _ready() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	await tween.tween_property(intro_label, "modulate:a", 0, 1).finished

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		credits.visible = !credits.visible
		get_tree().paused = !get_tree().paused
			 
func _on_asteroid_detector_body_entered(body: Node2D) -> void:
	if not game_over:
		var asteroid_scale = body.get_child(0).scale.x
		current_score += round((asteroid_scale * 10))
		score_label.text = "Score " + str(current_score)

func _on_player_dead() -> void:
	game_over = true
	var game_over_screen_tween = create_tween().set_trans(Tween.TRANS_SINE)
	game_over_screen_tween.tween_property(game_over_screen, "modulate:a", 1, 3)
	var score_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	score_tween.tween_property(score_label, "position", Vector2(1200, 500), 2)
