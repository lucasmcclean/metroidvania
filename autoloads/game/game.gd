extends Node2D

func pause() -> void:
	get_tree().paused = true

func resume() -> void:
	get_tree().paused = false
