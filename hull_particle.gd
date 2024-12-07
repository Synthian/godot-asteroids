extends Sprite2D

@export var velocityComponent: VelocityComponent
@export var speed: int
@export var direction: float
@export var time: float

func _ready() -> void:
	velocityComponent.linearVelocity = Vector2.from_angle(direction) * speed
	await get_tree().create_timer(time).timeout
	var tween := get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 1)
	tween.tween_callback(queue_free)

func _process(delta: float) -> void:
	velocityComponent.move(self, delta)
	velocityComponent.spin(self, delta)
