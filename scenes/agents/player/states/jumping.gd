extends PlayerState

@export var fall_state: PlayerState
@export var ground_state: PlayerState

func enter() -> void:
	super()
	player.velocity.y += player.JUMP_VELOCITY

func _check_falling() -> void:
	if player.velocity.y >= 0:
		state_machine.change_state(fall_state)

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	if player.has_control:
		player.update_velocity(player.get_input_direction(), delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	else:
		player.update_velocity(0, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	_check_falling()
