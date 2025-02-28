class_name HealthComponent
extends Node

signal hp_changed(new_value: int)


@export var max_hp: int
var _remaining_hp: int


func _ready() -> void:
	_remaining_hp = max_hp


func set_hp(new_amount: int) -> void:
	_remaining_hp = new_amount
	hp_changed.emit(_remaining_hp)


func change_hp(change_amount: int) -> void:
	var new_amount: int = clampi(_remaining_hp + change_amount, 0, max_hp)
	if new_amount != _remaining_hp:
		_remaining_hp = new_amount
		hp_changed.emit(_remaining_hp)
