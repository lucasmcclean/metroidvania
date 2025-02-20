class_name ZoneGenerator
extends Node

## Levels to be included in randomized area generation.
@export var level_scenes: Array[PackedScene]


func _ready() -> void:
	var cur_root_pos: Vector2i = Vector2i(0, 0)
	var zone := Zone.new() as Zone
	Game.add_child(zone)
	for scene in level_scenes:
		var level := scene.instantiate() as Level
		zone.add_child(level)
		_position_level_in_area(level, cur_root_pos)
		cur_root_pos = _calculate_new_root_pos(level, cur_root_pos)
	self.queue_free()


func _position_level_in_area(level: Level, cur_root_pos: Vector2i) -> void:
	level.position.x = cur_root_pos.x * Global.TILE_SIZE
	level.position.y = (cur_root_pos.y - level.conn_start_y) * Global.TILE_SIZE


func _calculate_new_root_pos(level: Level, cur_root_pos: Vector2i) -> Vector2i:
	var new_root_pos: Vector2i = cur_root_pos
	new_root_pos.x = cur_root_pos.x + level.conn_end_x + 1
	new_root_pos.y = cur_root_pos.y + (level.conn_end_y - level.conn_start_y)
	return new_root_pos
