extends Sprite2D

@export var velocityComponent: VelocityComponent
@export var speed: int
@export var direction: float

func _ready() -> void:
	velocityComponent.linearVelocity = Vector2.from_angle(direction) * speed

func _process(delta: float) -> void:
	velocityComponent.move(self, delta)
	velocityComponent.spin(self, delta)
