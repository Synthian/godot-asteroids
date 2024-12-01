extends Node2D
class_name Explosion

@export var particleScene: PackedScene
var maxSpeed: int

func init(position: Vector2, maxSpeed: int) -> void:
	self.position = position
	self.maxSpeed = maxSpeed

func _ready() -> void:
	for x in 20:
		var particle: ExplosionParticle = particleScene.instantiate()
		particle.init(Vector2.from_angle(randf_range(0, TAU)) * randi_range(0, maxSpeed))
		add_child(particle)
