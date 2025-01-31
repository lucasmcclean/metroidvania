class_name TestLevel2
extends Level


func _on_zone_switcher_body_entered(_body: Node2D) -> void:
	Scenes.switch_with_fade(self, "res://scenes/levels/test_level/test_level.tscn")
