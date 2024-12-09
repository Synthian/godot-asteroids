extends Node2D
class_name Explosion

static var PARTICLE_COUNT := 20

@export var particleScene: PackedScene
var maxSpeed: int

func init(position: Vector2, maxSpeed: int) -> void:
	self.position = position
	self.maxSpeed = maxSpeed

func setColor(color: Color) -> void:
	modulate = color

func _ready() -> void:
	for x in PARTICLE_COUNT:
		var particle: ExplosionParticle = particleScene.instantiate()
		particle.init(Vector2.from_angle(randf_range(0, TAU)) * randi_range(0, maxSpeed))
		add_child(particle)
