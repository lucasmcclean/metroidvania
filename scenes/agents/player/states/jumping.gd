extends PlayerState

@export var fall_state: PlayerState
@export var ground_state: PlayerState

func enter() -> void:
	super()
	player.velocity.y += player.JUMP_VELOCITY

func _check_falling() -> bool:
	if player.velocity.y >= 0:
		state_machine.change_state(fall_state)
		return true
	return false

func _check_released_jump() -> bool:
	if Input.is_action_just_released("jump"):
		state_machine.change_state(fall_state)
		player.velocity.y *= 0.2
		return true
	return false

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	if player.has_control:
		player.update_velocity(player.get_input_direction(), delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	else:
		player.update_velocity(0, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	if _check_falling():
		return
	if _check_released_jump():
		return
