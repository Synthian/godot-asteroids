extends Node

static var STARTING_ASTEROIDS := 2
static var MAX_ASTEROIDS := 8
static var ASTEROID_INCREMENT := 2
static var SAUCER_KILL_REQ := 20
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
@export var smallSaucerScene: PackedScene
@export var largeSaucerScene: PackedScene

var level := 0
var score := 0
var lives := STARTING_LIVES
var gameActive := false

var asteroidsKilledCurrentLevel := 0

func _ready() -> void:
	randomize()
	openMainMenu()

func _process(_delta: float) -> void:
	var asteroids := get_tree().get_nodes_in_group("enemies")
	if asteroids.size() == 0 && gameActive:
		level += 1
		$LevelFinishTimer.start()
		$RespawnTimer.stop()
		gameActive = false

func openMainMenu() -> void:
	$UI.setTitleVisibility(true)
	$UI.setHudVisibility(false)
	$Player.disable()
	clearEnemies()
	spawnAsteroids(6)
	spawnLargeSaucer()

func newGame() -> void:
	level = 0
	score = 0
	lives = STARTING_LIVES
	$UI.setLifeCount(lives)
	$UI.setScore(score)
	$UI.setHudVisibility(true)
	newLevel()

func newLevel() -> void:
	clearEnemies()
	asteroidsKilledCurrentLevel = 0
	$Player.disable()
	$UI.setLevel(level)
	$UI.setGetReadyVisibility(true)
	$ReadyTimer.start()

func startLevel() -> void:
	$UI.setGetReadyVisibility(false)
	$Player.start($StartPosition.position, false)
	gameActive = true
	spawnAsteroids(clampi(level * ASTEROID_INCREMENT + STARTING_ASTEROIDS, STARTING_ASTEROIDS, MAX_ASTEROIDS))

func spawnAsteroids(asteroidCount: int) -> void:
	for x in asteroidCount:
		var asteroid: Asteroid = largeAsteroid.instantiate()
		var randomPosition: Vector2 = $StartPosition.position + Vector2.from_angle(randf_range(0, TAU)) * 500
		var randomDirection := randf_range(0 , TAU)
		asteroid.init(randomPosition, randomDirection, level)
		asteroid.connect("hit", largeAsteroidHit)
		asteroid.add_to_group("enemies")
		add_child(asteroid)

#region Asteroid Explosions + Spawning
func largeAsteroidHit(lgAsteroid: Asteroid) -> void:
	addPoints(POINT_VALUE["LARGE"])
	for x in 2:
		var mdAsteroid: Asteroid = mediumAsteroid.instantiate()
		mdAsteroid.init(lgAsteroid.position, lgAsteroid.getVelocity().angle(), level)
		mdAsteroid.connect("hit", mediumAsteroidHit)
		mdAsteroid.add_to_group("enemies")
		call_deferred("add_child", mdAsteroid)
	explodeAsteroid(lgAsteroid.position, EXPLOSION_SIZE["LARGE"])
	lgAsteroid.queue_free()

func mediumAsteroidHit(mdAsteroid: Asteroid) -> void:
	addPoints(POINT_VALUE["MEDIUM"])
	for x in 2:
		var smAsteroid: Asteroid = smallAsteroid.instantiate()
		smAsteroid.init(mdAsteroid.position, mdAsteroid.getVelocity().angle(), level)
		smAsteroid.connect("hit", smallAsteroidHit)
		smAsteroid.add_to_group("enemies")
		call_deferred("add_child", smAsteroid)
	explodeAsteroid(mdAsteroid.position, EXPLOSION_SIZE["MEDIUM"])
	mdAsteroid.queue_free()
	
func smallAsteroidHit(smAsteroid: Asteroid) -> void:
	addPoints(POINT_VALUE["SMALL"])
	explodeAsteroid(smAsteroid.position, EXPLOSION_SIZE["SMALL"])
	smAsteroid.queue_free()

func explodeAsteroid(position: Vector2, size: int) -> void:
	asteroidsKilledCurrentLevel += 1
	spawnSaucerIfNeeded()
	var explosion: Explosion = asteroidExplosionScene.instantiate()
	explosion.init(position, size)
	call_deferred("add_child", explosion)
#endregion

func spawnSaucerIfNeeded() -> void:
	if asteroidsKilledCurrentLevel % SAUCER_KILL_REQ == 0:
		if randi() % 2 == 0 :
			spawnSmallSaucer()
		else:
			spawnLargeSaucer()

func spawnSmallSaucer() -> void:
	var saucer: SmallSaucer = smallSaucerScene.instantiate()
	saucer.init($Player)
	saucer.add_to_group("enemies")
	saucer.connect("hit", saucerHit)
	call_deferred("add_child", saucer)

func spawnLargeSaucer() -> void:
	var saucer: LargeSaucer = largeSaucerScene.instantiate()
	$SpawnPath/SaucerSpawnLocation.progress_ratio = randf()
	saucer.position = $SpawnPath/SaucerSpawnLocation.position
	saucer.add_to_group("enemies")
	saucer.connect("hit", saucerHit)
	call_deferred("add_child", saucer)

func saucerHit(saucer: Area2D) -> void:
	addPoints(100)
	var explosion: Explosion = asteroidExplosionScene.instantiate()
	explosion.init(saucer.position, 50)
	explosion.setColor(Color.RED)
	call_deferred("add_child", explosion)
	saucer.queue_free()

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

func clearEnemies() -> void:
	var asteroids := get_tree().get_nodes_in_group("enemies")
	for asteroid in asteroids:
		asteroid.queue_free()
