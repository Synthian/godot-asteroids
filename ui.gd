extends CanvasLayer
class_name UI

signal start
signal gameOverFinish

@export var lifeTexture: Texture

func setTitleVisibility(visible: bool) -> void:
	$MainMenu.visible = visible

func setGetReadyVisibility(visible: bool) -> void:
	$GetReady.visible = visible

func setHudVisibility(visible: bool) -> void:
	$LevelMargin/Level.visible = visible
	$ScoreMargin/Score.visible = visible

func gameOver() -> void:
	$GameOver/Title.visible = true
	$GameOverTimer.start()

func gameOverTimeout() -> void:
	$GameOver/Instructions.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if $MainMenu.visible:
			start.emit()
			$MainMenu.hide()
		elif $GameOver/Instructions.visible:
			$GameOver/Instructions.visible = false
			$GameOver/Title.visible = false
			gameOverFinish.emit()

func setLifeCount(lives: int) -> void:
	for n in $LivesMargin/Lives.get_children():
		n.queue_free()
	for x in lives:
		var life := TextureRect.new()
		life.texture = lifeTexture
		$LivesMargin/Lives.add_child(life)

func setLevel(level: int) -> void:
	$LevelMargin/Level.text = "LEVEL %d" % (level + 1)

func setScore(score: int) -> void:
	$ScoreMargin/Score.text = "%d" % score
