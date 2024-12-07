extends Area2D
class_name Asteroid

signal hit

static var LEVEL_MULTIPLIER := 0.1

@export var velocityComponent: VelocityComponent
@export var edgeComponent: EdgeComponent
@export var animatedSprite: AnimatedSprite2D
@export var maxSpeed: int

func init(position: Vector2, initialDirection: float, level: int) -> void:
	self.position = position
	animatedSprite.frame = randi_range(0, 2)
	
	# Set spin
	var spin: float = randf_range(1.0, 2.0)
	if randi() % 2 == 0: spin = -spin
	velocityComponent.spinVelocity = spin
	
	# Set motion
	var direction := randf_range(initialDirection - PI/2, initialDirection + PI/2)
	var mult := 1 + LEVEL_MULTIPLIER * level
	var speed := randi_range(100, maxSpeed) * mult
	velocityComponent.linearVelocity = Vector2.from_angle(direction) * speed

func _process(delta: float) -> void: 
	var spriteFrames: SpriteFrames = animatedSprite.get_sprite_frames()
	var texture: Texture2D = spriteFrames.get_frame_texture("default", 0)
	edgeComponent.wrap(self, texture)
	velocityComponent.spin(self, delta)
	velocityComponent.move(self, delta)
	
func _on_area_entered(bullet: Area2D) -> void:
	bullet.queue_free()
	hit.emit(self)

func getVelocity() -> Vector2:
	return velocityComponent.linearVelocity
