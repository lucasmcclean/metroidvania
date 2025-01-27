class_name StateMachine
extends Node

@export var initial_state: State

var state: State


# TODO: Possibly employ lifecycle method
func initialize() -> void:
	for child in get_children():
		child.state_machine = self
	await owner.ready
	change_state(initial_state)


func change_state(new_state: State) -> void:
	if is_instance_valid(state):
		state.exit()
	state = new_state
	state.enter()


func physics_update(delta: float) -> void:
	state.physics_update(delta)


func update(delta: float) -> void:
	state.update(delta)
