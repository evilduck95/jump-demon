extends RigidBody2D

signal dead

@onready var sprite = $sprite

const FLYING_POWER = .5  
const MAX_HEIGHT = 25

var hits = 0
var flying = false
var invulnerable = false
var start_x_position = 0

func _ready() -> void:
	sprite.play("fly")
	start_x_position = position.x

func _process(_delta: float) -> void:
	if linear_velocity.y < 0:
		if flying:
			sprite.play("fly")
		else:
			sprite.play("float")
	else:                      
		sprite.play("glide")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("fly"):  
		flying = true
	if Input.is_action_just_released("fly"):
		flying = false
		# Unstuck when against top collider
		apply_impulse(Vector2.DOWN)
	if flying:
		apply_force(Vector2.UP * get_gravity() * FLYING_POWER)


func _on_fire_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var escape_vector
		if position.y > 500:
			escape_vector = Vector2.UP
		else: 
			escape_vector = Vector2.DOWN
		apply_impulse(escape_vector * 160)
		take_damage()
		
func take_damage() -> void: 
	if not invulnerable: 
		SoundManager.play_sound("hurt")
		hits += 1
		if hits == 1:
			modulate = Color(1, 0, 0)
		elif hits == 2:
			modulate = Color(2, 0, 0)
		elif hits == 3:
			die()
		else:
			modulate = Color(5, 0, 0)
		flash()
	
func flash() -> void:
	invulnerable = true
	await get_tree().create_timer(.2).timeout
	visible = false
	await get_tree().create_timer(.2).timeout
	for i in range(3):
		visible = true
		await get_tree().create_timer(.3).timeout
		visible = false
		await get_tree().create_timer(.2).timeout
	visible = true
	invulnerable = false


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("asteroid"):
		take_damage()
		body.explode()

func die() -> void: 
	dead.emit()
	gravity_scale = 0
	linear_damp = 1
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	await tween.tween_property(self, "modulate:a", 0, 3).finished
	queue_free()
	
