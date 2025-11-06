extends RigidBody2D

const AVERAGE_IMPULSE = 200
const IMPULSE_DEVIATION = 100
const AVERAGE_ANGULAR_VELOCITY = 0 # Mu
const ANGULAR_VELOCITY_DEVIATION = PI / 8 # Sigma
const MAX_SIZE_FACTOR = 1.5

@onready var animation = $AnimatedSprite2D
@onready var collider = $collider

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	angular_velocity = gaussian_rng(AVERAGE_ANGULAR_VELOCITY, ANGULAR_VELOCITY_DEVIATION)
	var initial_impulse_deviation = gaussian_rng(200, IMPULSE_DEVIATION)
	if initial_impulse_deviation <= 0:
		initial_impulse_deviation *= -1
	apply_impulse(Vector2.LEFT * (AVERAGE_IMPULSE + initial_impulse_deviation))
	var size_scale = rng.randf_range(1, MAX_SIZE_FACTOR)
	mass *= pow(size_scale, 3)
	
	for child in get_children():
		child.scale *= size_scale
		

# Taken from https://github.com/TheFamousRat/GodotUtility/blob/master/nodes/Random.gd
func gaussian_rng(average: float, standard_dev: float) -> float:
	return average + standard_dev * sqrt(-2 * (ln(randf()))) * cos(TAU * randf())

func ln(input: float) -> float:
	return log(input) / log(exp(1))
	
func explode() -> void:
	collider.queue_free()
	SoundManager.play_sound("explosion")
	animation.play()
	await animation.animation_finished
	queue_free()
