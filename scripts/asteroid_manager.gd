extends Node2D

const CHECK_INTERVAL = 1000

const MIN_SPAWN_DELAY = 500
const RANDOM_SPAWN_DELAY_SPREAD = 500
const SPAWN_POSITION_MIN_SPREAD = 100
const SPAWN_AREA_SIZE: float = 980
const SPAWN_AREA_OFFSET: float = 50


var rng = RandomNumberGenerator.new()
var asteroid_scene = preload("res://scenes/asteroid.tscn")
var next_spawn_time = 0
var next_spawn_position: float = rng.randf_range(SPAWN_AREA_OFFSET, SPAWN_AREA_SIZE + SPAWN_AREA_OFFSET)
var next_check_time = 5000
var spawn_delay = 2000

func _process(delta: float) -> void:
	var now = Time.get_ticks_msec()
	if now > next_spawn_time:
		var asteroid = asteroid_scene.instantiate()
		asteroid.position = Vector2(0, next_spawn_position)
		add_child(asteroid)
		asteroid.rotation = rng.randf_range(0, TAU)
		next_spawn_time = now + spawn_delay + rng.randf_range(0, RANDOM_SPAWN_DELAY_SPREAD)
		if spawn_delay > MIN_SPAWN_DELAY:
			spawn_delay -= 1500 * delta
			print(str(spawn_delay))
		var prev_spawn_position: float = next_spawn_position
		var next_furthest_spawn_position = prev_spawn_position + (SPAWN_AREA_SIZE - SPAWN_POSITION_MIN_SPREAD)
		var wanted_spawn_position = prev_spawn_position + rng.randf_range(SPAWN_POSITION_MIN_SPREAD, next_furthest_spawn_position)
		next_spawn_position = fposmod(wanted_spawn_position, SPAWN_AREA_SIZE) + SPAWN_AREA_OFFSET
	if now > next_check_time:
		var asteroids = get_children()
		if asteroids.size() > 20:
			for asteroid in asteroids:
				var asteroid_position = asteroid.global_position
				if asteroid_position.x < 0 or asteroid_position.y < 0 or asteroid_position.y > SPAWN_AREA_SIZE + (SPAWN_AREA_OFFSET * 2):
					asteroid.queue_free()
