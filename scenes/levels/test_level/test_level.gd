class_name TestLevel
extends Node2D


func _on_level_switcher_body_entered(_body: Node2D) -> void:
	Scenes.switch(self, "res://scenes/levels/test_level/test_level.tscn")
