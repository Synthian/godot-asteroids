extends Area2D
class_name LargeSaucer

# enter from random location, travelling static direction
# shots aim randomly

signal hit

static var X_WRAP_PAD := 60
static var Y_WRAP_PAD := 40

@export var bulletScene: PackedScene

@onready var screen_size: Vector2 = get_viewport_rect().size

func _ready() -> void:
	$VelocityComponent.linearVelocity = Vector2.from_angle(randf_range(0, TAU)) * $VelocityComponent.maxSpeed

func _process(delta: float) -> void:
	$VelocityComponent.move(self, delta)
	$EdgeComponent.wrapWithPadding(self, X_WRAP_PAD, Y_WRAP_PAD)

func shoot() -> void:
	if position.x > 0 && position.y > 0 && position.x < screen_size.x && position.y < screen_size.y:
		var bullet: Bullet = bulletScene.instantiate()
		bullet.initEnemy(position, Vector2.from_angle(randf_range(0, TAU)))
		add_sibling(bullet)

func _on_area_entered(bullet: Area2D) -> void:
	bullet.queue_free()
	hit.emit(self)
