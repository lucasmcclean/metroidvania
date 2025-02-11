class_name PlayerState
extends State

var player: Player


func _enter_tree() -> void:
	player = owner as Player
	assert(player != null)


func enter() -> void:
	pass
