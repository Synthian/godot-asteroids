extends Area2D
class_name Bullet

@export var speed: float

func init(position: Vector2, rotation: float, impartedVelocity: Vector2) -> void:
	self.position = position
	self.rotation = rotation
	var aimedVelocity: Vector2 = Vector2.from_angle(rotation) * speed
	$VelocityComponent.linearVelocity = aimedVelocity + impartedVelocity

func _process(delta: float) -> void:
	$VelocityComponent.move(self, delta)
	$EdgeComponent.wrap(self, $Sprite2D.texture)

func cull() -> void:
	queue_free()
