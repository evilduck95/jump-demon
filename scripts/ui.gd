extends Node2D

@onready var pause_button = $"pause button"
@onready var score_label = $score
@onready var intro_label = $intro
@onready var tutorial = $tutorial
@onready var game_over_screen = $"game over screen"
@onready var pause_screen = $"pause screen"
@onready var tutorial_platform = $"../temporary platform"
@onready var high_score = $"pause screen/high score"

var current_score: int = 0
var game_over = false

func _ready() -> void:
	var intro_tween = create_tween().set_trans(Tween.TRANS_SINE)
	await intro_tween.tween_property(intro_label, "modulate:a", 0, 1).finished
	var tutorial_in_tween = create_tween().set_trans(Tween.TRANS_SINE)
	await tutorial_in_tween.tween_property(tutorial, "modulate:a", 1, 1).finished
	high_score.text = "High Score: " + str(load_score())
	

func hide_tutorial():
	tutorial_platform.queue_free()
	var tutorial_out_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tutorial_out_tween.tween_property(tutorial, "modulate:a", 0, 2)

func flip_visibility(node: Node):
	node.visible = !node.visible

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		flip_visibility(pause_screen)
		flip_visibility(intro_label)
		flip_visibility(tutorial)
		flip_visibility(pause_button)
		flip_visibility(game_over_screen)
		if game_over:
			flip_visibility(score_label)
		get_tree().paused = !get_tree().paused
	if GameGlobals.tutorial_active && Input.is_action_just_pressed("fly"):
		GameGlobals.tutorial_active = false
		await get_tree().create_timer(0.5).timeout
		hide_tutorial()
	if game_over and Input.is_action_just_released("confirm"):
		get_tree().reload_current_scene()

func _on_asteroid_detector_body_entered(body: Node2D) -> void:
	if not game_over:
		var asteroid_scale = body.get_child(0).scale.x
		current_score += round((asteroid_scale * 10))
		score_label.text = "Score " + str(current_score)

func _on_player_dead() -> void:
	save_score(current_score)
	game_over = true
	var game_over_screen_tween = create_tween().set_trans(Tween.TRANS_SINE)
	game_over_screen_tween.tween_property(game_over_screen, "modulate:a", 1, 3)
	var score_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	score_tween.tween_property(score_label, "position", Vector2(1200, 500), 2)

func save_score(score_to_save):
	var config = ConfigFile.new()
	var err = config.load("user://save_data.txt")
	if err == 7:
		print("Score data already exists. Updating")
	if score_to_save > config.get_value("savedata", "score", 0):
		config.set_value("savedata", "score", score_to_save)
		config.save("user://save_data.txt")
	
func load_score() -> int:
	var config = ConfigFile.new()
	var err = config.load("user://save_data.txt")
	if err != OK:
		print("No save data could be loaded")
		return 0
	return config.get_value("savedata", "score")
	
