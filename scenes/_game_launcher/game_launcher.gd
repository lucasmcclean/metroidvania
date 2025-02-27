extends Node

@export var initial_scene: PackedScene

@onready var player_scene: PackedScene = preload("res://scenes/agents/player/player.tscn")


func _ready() -> void:
	Game.add_child(initial_scene.instantiate())
	var player: Player = player_scene.instantiate() as Player
	Game.add_child(player)
	player.global_position.y -= 200

	self.queue_free()
