extends Area2D

func _ready() -> void:
	var spin: float = randf_range(1.0, 2.0)
	if randi() % 2 == 0: spin = -spin
	$VelocityComponent.spinVelocity = spin
	
	var speed: int = randi_range(100, 300)
	var direction: float = randf_range(0, TAU)
	$VelocityComponent.linearVelocity = Vector2.from_angle(direction) * speed

func _process(delta: float) -> void: 
	$EdgeComponent.wrap(self, $Sprite2D)
	$VelocityComponent.spin(self, delta)
	$VelocityComponent.move(self, delta)
