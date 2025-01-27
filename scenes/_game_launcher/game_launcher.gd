extends Node

@export var initial_scene: PackedScene


func _ready() -> void:
	Game.add_child(initial_scene.instantiate())
	self.queue_free()
