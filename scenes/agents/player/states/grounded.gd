extends PlayerState

@export var fall_state: PlayerState
@export var jump_state: PlayerState


func enter() -> void:
	super()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func _check_jumping() -> bool:
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(jump_state)
		return true
	return false


func _check_falling() -> bool:
	if !player.is_on_floor():
		state_machine.change_state(fall_state)
		return true
	return false


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	if player.has_control:
		player.update_velocity(player.get_input_direction(), delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
		if _check_jumping():
			return
	else:
		player.update_velocity(0, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	if _check_falling():
		return
