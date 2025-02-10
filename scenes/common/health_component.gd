class_name HealthComponent
extends Node

signal hp_changed(new_value: int)


@export var max_hp: int
var remaining_hp: int:
	set(new_value):
		remaining_hp = new_value
		hp_changed.emit(new_value)


func _ready() -> void:
	remaining_hp = max_hp


func change_hp(change_amount: int) -> void:
	remaining_hp = clampi(remaining_hp, 0, max_hp)
