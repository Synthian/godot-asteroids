extends Node

static var STARTING_ASTEROIDS := 6
static var STARTING_LIVES := 3
static var EXPLOSION_SIZE: Dictionary = {
	"LARGE": 70,
	"MEDIUM": 50,
	"SMALL": 30
}
static var POINT_VALUE: Dictionary = {
	"LARGE": 10,
	"MEDIUM": 20,
	"SMALL": 30
}
static var LEVEL_MULTIPLIER := 0.1

@export var largeAsteroid: PackedScene
@export var mediumAsteroid: PackedScene
@export var smallAsteroid: PackedScene
@export var asteroidExplosionScene: PackedScene
@export var playerExplosionScene: PackedScene

var level := -1
var lives := STARTING_LIVES
var score := 0
var gameActive := false

func _ready() -> void:
	randomize()
	openMainMenu()

func openMainMenu() -> void:
	$UI.setTitleVisibility(true)
	$UI.setHudVisibility(false)
	$Player.disable()
	clearAsteroids()
	spawnAsteroids()

func newGame() -> void:
	level = 0
	score = 0
	lives = STARTING_LIVES
	$UI.setLifeCount(lives)
	$UI.setScore(score)
	$UI.setHudVisibility(true)
	newLevel()

func newLevel() -> void:
	clearAsteroids()
	$Player.disable()
	$UI.setLevel(level)
	$UI.setGetReadyVisibility(true)
	$ReadyTimer.start()

func startLevel() -> void:
	$UI.setGetReadyVisibility(false)
	$Player.start($StartPosition.position, false)
	gameActive = true
	spawnAsteroids()

func spawnAsteroids() -> void:
	for x in STARTING_ASTEROIDS:
		var asteroid: Asteroid = largeAsteroid.instantiate()
		var randomPosition: Vector2 = $StartPosition.position + Vector2.from_angle(randf_range(0, TAU)) * 500
		var randomDirection := randf_range(0 , TAU)
		asteroid.init(randomPosition, randomDirection, level)
		asteroid.connect("hit", largeAsteroidHit)
		asteroid.add_to_group("asteroids")
		add_child(asteroid)

func _process(_delta: float) -> void:
	var asteroids := get_tree().get_nodes_in_group("asteroids")
	if asteroids.size() == 0 && gameActive:
		level += 1
		$LevelFinishTimer.start()
		$RespawnTimer.stop()
		gameActive = false

func largeAsteroidHit(lgAsteroid: Asteroid) -> void:
	addPoints(POINT_VALUE["LARGE"])
	for x in 2:
		var mdAsteroid: Asteroid = mediumAsteroid.instantiate()
		mdAsteroid.init(lgAsteroid.position, lgAsteroid.getVelocity().angle(), level)
		mdAsteroid.connect("hit", mediumAsteroidHit)
		mdAsteroid.add_to_group("asteroids")
		call_deferred("add_child", mdAsteroid)
	explodeAsteroid(lgAsteroid.position, EXPLOSION_SIZE["LARGE"])
	lgAsteroid.queue_free()

func mediumAsteroidHit(mdAsteroid: Asteroid) -> void:
	addPoints(POINT_VALUE["MEDIUM"])
	for x in 2:
		var smAsteroid: Asteroid = smallAsteroid.instantiate()
		smAsteroid.init(mdAsteroid.position, mdAsteroid.getVelocity().angle(), level)
		smAsteroid.connect("hit", smallAsteroidHit)
		smAsteroid.add_to_group("asteroids")
		call_deferred("add_child", smAsteroid)
	explodeAsteroid(mdAsteroid.position, EXPLOSION_SIZE["MEDIUM"])
	mdAsteroid.queue_free()
	
func smallAsteroidHit(smAsteroid: Asteroid) -> void:
	addPoints(POINT_VALUE["SMALL"])
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
	else:
		gameActive = false
		$UI.gameOver()

func respawn() -> void:
	$Player.start($StartPosition.position, true)

func addPoints(pts: int) -> void:
	score += ceil(pts * (1 + LEVEL_MULTIPLIER * level))
	$UI.setScore(score)

func clearAsteroids() -> void:
	var asteroids := get_tree().get_nodes_in_group("asteroids")
	for asteroid in asteroids:
		asteroid.queue_free()
