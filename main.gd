extends Node

static var STARTING_ASTEROIDS := 8
static var STARTING_LIVES := 3
static var EXPLOSION_SIZE: Dictionary = {
	"LARGE": 70,
	"MEDIUM": 50,
	"SMALL": 30
}

@export var largeAsteroid: PackedScene
@export var mediumAsteroid: PackedScene
@export var smallAsteroid: PackedScene
@export var asteroidExplosionScene: PackedScene
@export var playerExplosionScene: PackedScene

var level := 0
var lives := STARTING_LIVES

func _ready() -> void:
	randomize()
	get_tree().paused = true
	openMainMenu()

func openMainMenu() -> void:
	$UI.setTitleVisibility(true)

func newGame() -> void:
	level = 1
	get_tree().paused = false
	$UI.setGetReadyVisibility(true)
	$UI.setLifeCount(3)
	$ReadyTimer.start()

func startLevel() -> void:
	$UI.setGetReadyVisibility(false)
	initLevel()
	$Player.start($StartPosition.position, false)

func initLevel() -> void:
	for x in STARTING_ASTEROIDS:
		var asteroid: Asteroid = largeAsteroid.instantiate()
		var randomPosition: Vector2 = $StartPosition.position + Vector2.from_angle(randf_range(0, TAU)) * 500
		var randomDirection := randf_range(0 , TAU)
		asteroid.init(randomPosition, randomDirection)
		asteroid.connect("hit", largeAsteroidHit)
		asteroid.add_to_group("asteroids")
		add_child(asteroid)

#func _process(_delta: float) -> void:
	# var asteroids := get_tree().get_nodes_in_group("asteroids")
	# if asteroids.size() == 0:
		# call_deferred("newGame")

func largeAsteroidHit(lgAsteroid: Asteroid) -> void:
	for x in 2:
		var mdAsteroid: Asteroid = mediumAsteroid.instantiate()
		mdAsteroid.init(lgAsteroid.position, lgAsteroid.getVelocity().angle())
		mdAsteroid.connect("hit", mediumAsteroidHit)
		mdAsteroid.add_to_group("asteroids")
		call_deferred("add_child", mdAsteroid)
	explodeAsteroid(lgAsteroid.position, EXPLOSION_SIZE["LARGE"])
	lgAsteroid.queue_free()
	
func mediumAsteroidHit(mdAsteroid: Asteroid) -> void:
	for x in 2:
		var smAsteroid: Asteroid = smallAsteroid.instantiate()
		smAsteroid.init(mdAsteroid.position, mdAsteroid.getVelocity().angle())
		smAsteroid.connect("hit", smallAsteroidHit)
		smAsteroid.add_to_group("asteroids")
		call_deferred("add_child", smAsteroid)
	explodeAsteroid(mdAsteroid.position, EXPLOSION_SIZE["MEDIUM"])
	mdAsteroid.queue_free()
	
func smallAsteroidHit(smAsteroid: Asteroid) -> void:
	explodeAsteroid(smAsteroid.position, EXPLOSION_SIZE["SMALL"])
	smAsteroid.queue_free()

func explodeAsteroid(position: Vector2, size: int) -> void:
	var explosion: Explosion = asteroidExplosionScene.instantiate()
	explosion.init(position, size)
	call_deferred("add_child", explosion)
	
func playerDeath() -> void:
	lives -= 1
	$UI.setLifeCount(lives)
	if (lives > 0):
		$RespawnTimer.start()

func respawn() -> void:
	$Player.start($StartPosition.position, true)
