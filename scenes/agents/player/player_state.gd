class_name PlayerState
extends State

var player: Player
var playerBody: CharacterBody2D


func _enter_tree() -> void:
	player = owner as Player
	assert(player != null)


func enter() -> void:
	pass
