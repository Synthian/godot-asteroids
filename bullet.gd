extends Area2D
class_name Bullet

static var COLOR_INTENSITY := 7

@export var speed: float

func initAlly(position: Vector2, rotation: float, impartedVelocity: Vector2) -> void:
	self.position = position
	self.rotation = rotation
	$Sprite2D.self_modulate = Color(0, COLOR_INTENSITY, 0)
	var aimedVelocity: Vector2 = Vector2.from_angle(rotation) * speed
	$VelocityComponent.linearVelocity = aimedVelocity + impartedVelocity

func initEnemy(position: Vector2, direction: Vector2) -> void:
	self.position = position
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)
	$Sprite2D.self_modulate = Color(COLOR_INTENSITY, 0, 0)
	$VelocityComponent.linearVelocity = direction * speed

func _process(delta: float) -> void:
	$VelocityComponent.move(self, delta)
	$EdgeComponent.wrap(self, $Sprite2D.texture)

func cull() -> void:
	queue_free()
