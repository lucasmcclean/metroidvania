extends PlayerState

@export var fall_state: PlayerState
@export var jump_state: PlayerState
@export var stunned_state: PlayerState


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
		var input_direction := player.get_input_direction()
		player.update_facing_direction(input_direction)
		if input_direction != 0:
			if(player.is_attacking):
				player.animation_player.play("walk_attack")
			else:
				player.animation_player.play("walk")
		else:
			if(player.is_attacking):
				player.animation_player.play("idle_attack")
			else:
				player.animation_player.play("idle")
		player.update_velocity(input_direction, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
		player.check_attack_input()
		if _check_jumping():
			return
	else:
		player.update_velocity(0, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	if _check_falling():
		return


func handle_hit(_attacker: Hurtbox) -> void:
	state_machine.change_state(stunned_state)
