class_name TestLevel
extends Node2D


func _on_level_switcher_body_entered(_body: Node2D) -> void:
	Scenes.switch_with_fade(self, "res://scenes/levels/test_level/test_level.tscn")
