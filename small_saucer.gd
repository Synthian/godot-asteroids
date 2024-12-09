extends Area2D
class_name SmallSaucer

# enter from random Y value travelling east/west
# periodically change direction towards player
# shots aim toward player

signal hit

static var Y_PADDING := 30
enum Direction {LEFT, RIGHT}

@export var bulletScene: PackedScene

var player: Area2D

@onready var screen_size: Vector2 = get_viewport_rect().size

func init(player: Area2D) -> void:
	self.player = player

func _ready() -> void:
	var height := randf_range(Y_PADDING, screen_size.y - Y_PADDING)
	var spawnSide: Direction = Direction.values().pick_random()
	match spawnSide:
		Direction.LEFT:
			position.x = screen_size.x + $Sprite2D.texture.get_width()
			position.y = height
			$VelocityComponent.linearVelocity = Vector2(-1, 0) * $VelocityComponent.maxSpeed
		Direction.RIGHT:
			position.x = 0 - $Sprite2D.texture.get_width()
			position.y = height
			$VelocityComponent.linearVelocity = Vector2(1, 0) * $VelocityComponent.maxSpeed

func _process(delta: float) -> void:
	$VelocityComponent.move(self, delta)
	$EdgeComponent.wrap(self, $Sprite2D.texture)

func changeDirection() -> void:
	if player:
		var direction := (player.position - position).normalized()
		$VelocityComponent.linearVelocity = direction * $VelocityComponent.maxSpeed

func shoot() -> void:
	if player:
		var bullet: Bullet = bulletScene.instantiate()
		bullet.initEnemy(position, (player.position - position).normalized())
		add_sibling(bullet)

func _on_area_entered(bullet: Area2D) -> void:
	bullet.queue_free()
	hit.emit(self)
