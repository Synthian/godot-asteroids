extends CanvasLayer
class_name UI

signal start

@export var lifeTexture: Texture

func setTitleVisibility(visible: bool) -> void:
	$MainMenu.visible = visible

func setGetReadyVisibility(visible: bool) -> void:
	$GetReady.visible = visible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") && $MainMenu.visible:
		start.emit()
		$MainMenu.hide()

func setLifeCount(lives: int) -> void:
	for n in $Lives.get_children():
		n.queue_free()
	for x in lives:
		var life := TextureRect.new()
		life.texture = lifeTexture
		$Lives.add_child(life)
