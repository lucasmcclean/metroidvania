extends PlayerState

@export var fall_state: PlayerState
@export var ground_state: PlayerState
@export var knockback_state: PlayerKnockbackState

func enter() -> void:
	super()
	player.velocity.y += player.JUMP_VELOCITY
	if(player.is_attacking):
		player.animation_player.play("jump_attack")
	else:
		player.animation_player.play("jump")


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
		var input_direction := player.get_input_direction()
		player.update_facing_direction(input_direction)
		player.update_velocity(input_direction, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
		player.check_attack_input()
	else:
		player.update_velocity(0, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	if _check_falling():
		return
	if _check_released_jump():
		return


func handle_hit(attacker: Hurtbox) -> void:
	knockback_state.last_attacker = attacker
	state_machine.change_state(knockback_state)
