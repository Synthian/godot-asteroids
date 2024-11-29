extends Area2D
class_name Bullet

@export var speed: float
var impartedVelocity: Vector2

func _ready() -> void:
	var aimedVelocity: Vector2 = Vector2.from_angle(rotation) * speed
	$VelocityComponent.linearVelocity = aimedVelocity + impartedVelocity

func _process(delta: float) -> void:
	$VelocityComponent.move(self, delta)

func cull() -> void:
	queue_free()
