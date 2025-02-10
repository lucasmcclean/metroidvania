class_name Hitbox
extends Area2D

signal got_hit(attacker: Hurtbox)

@export var health_component: HealthComponent


func _on_area_entered(area: Area2D) -> void:
	var hurtbox: Hurtbox
	if area is Hurtbox:
		hurtbox = area as Hurtbox
	else:
		return
	health_component.change_hp()
