extends Node2D

@onready var score_label = $score
@onready var intro_label = $intro
@onready var tutorial = $tutorial
@onready var game_over_screen = $"game over screen"
@onready var credits = $credits
@onready var tutorial_platform = $"../temporary platform"

var current_score: int = 0
var game_over = false

func _ready() -> void:
	var intro_tween = create_tween().set_trans(Tween.TRANS_SINE)
	await intro_tween.tween_property(intro_label, "modulate:a", 0, 1).finished
	var tutorial_in_tween = create_tween().set_trans(Tween.TRANS_SINE)
	await tutorial_in_tween.tween_property(tutorial, "modulate:a", 1, 1).finished

func hide_tutorial():
	tutorial_platform.queue_free()
	var tutorial_out_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	return tutorial_out_tween.tween_property(tutorial, "modulate:a", 0, 2).finished
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		credits.visible = !credits.visible
		get_tree().paused = !get_tree().paused
	if GameGlobals.tutorial_active && Input.is_action_just_pressed("fly"):
		GameGlobals.tutorial_active = false
		await hide_tutorial()
			 
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
