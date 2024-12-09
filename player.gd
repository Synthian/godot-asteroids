extends Area2D
signal hit

@export var rotationSpeed: float = 3 # Radians per second
@export var bulletScene: PackedScene
@export var explosionScene: PackedScene

var alive := false
var invincible := false

func _process(delta: float) -> void:
	if !alive: return
	
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
		bullet.initAlly($GunPosition.global_position, rotation, $VelocityComponent.linearVelocity)
		add_sibling(bullet)
		
		if (invincible):
			invulnExpire()
			$InvulnTimer.stop()

func _on_area_entered(_body: Node2D) -> void:
	self.alive = false
	visible = false
	var explosion: DeathExplosion = explosionScene.instantiate()
	explosion.init(position, rotation)
	call_deferred("add_sibling", explosion)
	$CollisionPolygon2D.set_deferred("disabled", true)
	hit.emit()

func start(pos: Vector2, iframes: bool) -> void:
	alive = true
	visible = true
	position = pos
	rotation = 0
	$VelocityComponent.linearVelocity = Vector2(0,0)
	if iframes:
		invincible = true
		$BlinkTimer.start()
		$InvulnTimer.start()
	else:
		$CollisionPolygon2D.set_deferred("disabled", false)

func disable() -> void:
	$CollisionPolygon2D.set_deferred("disabled", true)
	alive = false
	visible = false

func invulnExpire() -> void:
	invincible = false
	visible = true
	$BlinkTimer.stop()
	$CollisionPolygon2D.set_deferred("disabled", false)

func blink() -> void:
	visible = !visible
