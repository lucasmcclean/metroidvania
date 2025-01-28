extends Node

@onready var _loading_screen_scene: PackedScene = preload("res://scenes/loading_screen/loading_screen.tscn")

var _loading_screen: LoadingScreen

func _ready() -> void:
	_loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	self.add_child(_loading_screen)


## Pauses the game and a displays loading screen until [to_scene_path] is loaded.
## After loading, frees [from_scene]—the scene to be replaced—and resumes the game.
func switch_with_fade(from_scene: Node, to_scene_path: StringName) -> void:
	Game.pause()

	await _loading_screen.fade_in()

	from_scene.queue_free()
	_load_and_instantiate_scene(to_scene_path)

	await _loading_screen.fade_out()
	Game.resume()


func _load_and_instantiate_scene(scene_path: StringName) -> void:
	ResourceLoader.load_threaded_request(scene_path)

	while ResourceLoader.load_threaded_get_status(scene_path) != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame

	var scene := ResourceLoader.load_threaded_get(scene_path) as PackedScene
	Game.add_child(scene.instantiate())
