extends Node2D


func pause() -> void:
	get_tree().paused = true


func resume() -> void:
	get_tree().paused = false

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("fullscreen")):
		if(get_window().mode == Window.MODE_WINDOWED):
			get_window().mode = Window.MODE_FULLSCREEN
		else:
			get_window().mode = Window.MODE_WINDOWED
			get_window().size = Vector2(1920, 1080)
