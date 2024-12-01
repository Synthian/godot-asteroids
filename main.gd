extends Node

@export var largeAsteroid: PackedScene
@export var mediumAsteroid: PackedScene
@export var smallAsteroid: PackedScene
@export var explosionScene: PackedScene

func _ready() -> void:
	randomize()
	newGame()

func newGame() -> void:
	$Player.start($StartPosition.position)
	for x in 8:
		var asteroid: Asteroid = largeAsteroid.instantiate()
		var randomPosition: Vector2 = $StartPosition.position + Vector2.from_angle(randf_range(0, TAU)) * 500
		var randomDirection := randf_range(0 , TAU)
		asteroid.init(randomPosition, randomDirection)
		asteroid.connect("hit", largeAsteroidHit)
		asteroid.add_to_group("asteroids")
		add_child(asteroid)

func largeAsteroidHit(lgAsteroid: Asteroid) -> void:
	for x in 2:
		var mdAsteroid: Asteroid = mediumAsteroid.instantiate()
		mdAsteroid.init(lgAsteroid.position, lgAsteroid.getVelocity().angle())
		mdAsteroid.connect("hit", mediumAsteroidHit)
		mdAsteroid.add_to_group("asteroids")
		call_deferred("add_child", mdAsteroid)
	explode(lgAsteroid.position, 70)
	lgAsteroid.queue_free()
	
func mediumAsteroidHit(mdAsteroid: Asteroid) -> void:
	for x in 2:
		var smAsteroid: Asteroid = smallAsteroid.instantiate()
		smAsteroid.init(mdAsteroid.position, mdAsteroid.getVelocity().angle())
		smAsteroid.connect("hit", smallAsteroidHit)
		smAsteroid.add_to_group("asteroids")
		call_deferred("add_child", smAsteroid)
	explode(mdAsteroid.position, 50)
	mdAsteroid.queue_free()
	
func smallAsteroidHit(smAsteroid: Asteroid) -> void:
	explode(smAsteroid.position, 30)
	smAsteroid.queue_free()
	
	var asteroids: Array[Node] = get_tree().get_nodes_in_group("asteroids")
	if asteroids.size() == 1:
		call_deferred("newGame")
		
func explode(position: Vector2, size: int) -> void:
	var explosion: Explosion = explosionScene.instantiate()
	explosion.init(position, size)
	call_deferred("add_child", explosion)
	
