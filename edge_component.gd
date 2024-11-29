extends Node2D
class_name EdgeComponent

@onready var screen_size: Vector2 = get_viewport_rect().size

func wrap(node: Node2D, sprite: Sprite2D) -> void:
	var xMod: float = 0.0
	var yMod: float = 0.0
	if (sprite):
		xMod = sprite.texture.get_width() / 2.0
		yMod = sprite.texture.get_height() / 2.0
	
	node.position.x = wrapf(node.position.x, 0 - xMod, screen_size.x + xMod)
	node.position.y = wrapf(node.position.y, 0 - yMod, screen_size.y + yMod)
