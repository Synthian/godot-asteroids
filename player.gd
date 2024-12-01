extends Area2D
signal hit

@export var rotationSpeed: float = 3 # Radians per second
@export var bulletScene: PackedScene

func _process(delta: float) -> void:
	if !visible: return
	
	var spinVelocity: float = 0.0
	if Input.is_action_pressed("move_right"):
		spinVelocity += rotationSpeed
	if Input.is_action_pressed("move_left"):
		spinVelocity -= rotationSpeed
	$VelocityComponent.spinVelocity = spinVelocity
	
	if Input.is_action_pressed("boost"):
		$VelocityComponent.accelerateInDirection(rotation, delta)
		$AnimatedSprite2D.animation = "boost"
	else:
		$AnimatedSprite2D.animation = "default"
	
	$VelocityComponent.move(self, delta)
	$VelocityComponent.spin(self, delta)
	var spriteFrames: SpriteFrames = $AnimatedSprite2D.get_sprite_frames()
	var texture: Texture2D = spriteFrames.get_frame_texture("default", 0)
	$EdgeComponent.wrap(self, texture)
	
	if Input.is_action_just_pressed("shoot"):
		var bullet: Bullet = bulletScene.instantiate()
		bullet.init($GunPosition.global_position, rotation, $VelocityComponent.linearVelocity)
		add_sibling(bullet)

func _on_area_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionPolygon2D.set_deferred("disabled", true)
	
func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionPolygon2D.disabled = false
