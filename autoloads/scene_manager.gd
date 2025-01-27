extends Node

@onready var _loading_screen: PackedScene = preload("res://scenes/loading_screen/loading_screen.tscn")


## Pauses the game and a displays loading screen until [to_scene_path] is loaded.
## After loading, frees [from_scene]—the scene to be replaced—and resumes the game.
func switch(from_scene: Node, to_scene_path: StringName) -> void:
	Game.pause()

	var lc_instance: LoadingScreen = _instantiate_loading_screen()

	await lc_instance.fade_in()

	from_scene.queue_free()
	_load_and_instantiate_scene(to_scene_path)

	await lc_instance.fade_out_and_free()
	Game.resume()


func _instantiate_loading_screen() -> LoadingScreen:
	var instance: Node = _loading_screen.instantiate()
	self.add_child(instance)
	return instance


func _load_and_instantiate_scene(scene_path: StringName) -> void:
	ResourceLoader.load_threaded_request(scene_path)

	while ResourceLoader.load_threaded_get_status(scene_path) != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame

	var scene: PackedScene = ResourceLoader.load_threaded_get(scene_path)
	Game.add_child(scene.instantiate())
