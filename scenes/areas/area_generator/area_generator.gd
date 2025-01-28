class_name AreaGenerator
extends Node

## Levels to be included in randomized area generation.
@export var level_scenes: Array[PackedScene]


func _ready() -> void:
	var area := Area.new() as Area
	Game.add_child(area)
	for scene in level_scenes:
		var level := scene.instantiate() as Level
		area.add_child(level)
		_position_level_in_area(level, area)

func _position_level_in_area(level: Level, area: Area) -> void:
	pass
