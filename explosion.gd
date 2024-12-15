extends Node2D
class_name Explosion

static var PARTICLE_COUNT := 20
static var EXPLOSION_SIZE: Dictionary = {
	"LARGE": 70,
	"MEDIUM": 50,
	"SMALL": 30,
	"SAUCER": 60
}

@export var particleScene: PackedScene
var maxSpeed: int
var type: String

func init(position: Vector2, type: String) -> void:
	self.position = position
	self.type = type
	maxSpeed = EXPLOSION_SIZE[type]

func setColor(color: Color) -> void:
	modulate = color

func _ready() -> void:
	for x in PARTICLE_COUNT:
		var particle: ExplosionParticle = particleScene.instantiate()
		particle.init(Vector2.from_angle(randf_range(0, TAU)) * randi_range(0, maxSpeed))
		add_child(particle)
	
	if type == "LARGE":
		$LargeExplosion.play()
	elif type == "MEDIUM":
		$MediumExplosion.play()
	elif type == "SMALL":
		$SmallExplosion.play()
	else:
		$SaucerExplosion.play()
