extends Node
class_name VelocityComponent

@export var maxSpeed: float = INF # Pixels per second
@export var acceleration: float = 0.0 # Pixels per second squared
@export var friction: float = 0.0 # Pixels per second squared
@export var spinVelocity: float = 0.0 # Radians per second (clockwise positive)

var linearVelocity: Vector2 = Vector2(0.0, 0.0)

### LINEAR ###

# Adds a vector to the current velocity and returns the new value
func add(addend: Vector2) -> Vector2:
	linearVelocity = linearVelocity + addend
	if linearVelocity.length() > maxSpeed:
		linearVelocity = linearVelocity.normalized() * maxSpeed
	return linearVelocity

# Increases the speed (length) of velocity vector and returns the new value
func addSpeed(addend: float) -> Vector2:
	var speed: float = linearVelocity.length() + addend
	speed = clamp(speed, 0, maxSpeed)
	linearVelocity = linearVelocity.normalized() * speed
	return linearVelocity

# Adds acceleration 
func accelerateInDirection(rads: float, delta: float) -> Vector2:
	var addedVelocity: Vector2 = acceleration * Vector2.from_angle(rads) * delta
	return add(addedVelocity)

# Executes linear movement
func move(node: Node2D, delta: float) -> void:
	var speed: float = linearVelocity.length() - friction * delta
	speed = clamp(speed, 0, maxSpeed)
	linearVelocity = linearVelocity.normalized() * speed
	node.position += linearVelocity * delta

### SPIN ###

# Executes rotation
func spin(node: Node2D, delta: float) -> void:
	node.rotation = wrapf(node.rotation + spinVelocity * delta, 0.0, TAU)
