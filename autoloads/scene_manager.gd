extends Node

@onready var loading_screen: PackedScene = preload("res://scenes/loading_screen/loading_screen.tscn")

func switch(from_scene: Node, to_scene_path: StringName) -> void:
	Game.pause()

	var loading_screen_instance: Node = loading_screen.instantiate()
	add_child(loading_screen_instance)
	loading_screen_instance.fade_in()

	await loading_screen_instance.finished()
	from_scene.queue_free()
	ResourceLoader.load_threaded_request(to_scene_path)

	while ResourceLoader.load_threaded_get_status(to_scene_path) != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame

	await get_tree().create_timer(10.0).timeout
	var to_scene: PackedScene = ResourceLoader.load_threaded_get(to_scene_path)
	Game.add_child(to_scene.instantiate())

	await loading_screen_instance.finished()

	loading_screen_instance.fade_out_and_free()
	Game.resume()
