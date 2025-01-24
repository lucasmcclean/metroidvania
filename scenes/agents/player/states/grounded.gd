extends PlayerState

@export var fall_state: State
@export var jump_state: State

func enter() -> void:
	super()

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func apply_gravity(delta: float) -> void:
	player.velocity.y += Globals.GRAVITY * delta

func physics_update(delta: float) -> void:
	if player.has_control:
		player.update_velocity(player.get_input_direction(), delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	else:
		player.update_velocity(0, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	apply_gravity(delta)
