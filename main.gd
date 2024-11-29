extends Node

func _ready() -> void:
	randomize()
	newGame()

func newGame() -> void:
	$Player.start($StartPosition.position)
