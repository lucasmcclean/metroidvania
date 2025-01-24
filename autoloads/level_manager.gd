extends Node

var current_level: Level = null
var next_level: Level = null

func unload_current_level() -> void:
	current_level.queue_free()
	current_level = null

func load_level(level_to_load: PackedScene, player: Player = null) -> void:
	if is_instance_valid(current_level):
		unload_current_level()
	current_level = level_to_load.instantiate()
	if is_instance_valid(player):
		current_level.current_player = player
	add_sibling(current_level)

func load_next_level(level_to_load: PackedScene, level_position: Vector2) -> void:
	next_level = level_to_load.instantiate()
	next_level.global_position = level_position
	pass

func switch_level() -> void:
	var temp: Level = current_level
	current_level = next_level
	temp.queue_free()
	next_level = null
	pass
