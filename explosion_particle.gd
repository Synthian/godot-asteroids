extends Node2D
class_name ExplosionParticle

func init(velocity: Vector2) -> void:
	$VelocityComponent.linearVelocity = velocity

func _process(delta: float) -> void:
	$VelocityComponent.move(self, delta)

func fadeOut() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.TRANSPARENT, 1)
	tween.tween_callback(queue_free)
