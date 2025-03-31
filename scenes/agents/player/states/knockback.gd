class_name PlayerKnockbackState
extends PlayerState

@export var stunned_state: PlayerStunnedState

var last_attacker: Hurtbox

func enter() -> void:
	player.hitbox.set_deferred("monitoring", false)
	if player.is_attacking:
		player.is_attacking = false
		player.attack.set_deferred("monitoring", false)
		player.attack_timer.stop()
	if is_instance_valid(last_attacker):
		if(last_attacker.global_position.x < player.global_position.x):
			player.velocity.x = player.KNOCKBACK_VELOCITY_X
		else:
			player.velocity.x = -player.KNOCKBACK_VELOCITY_X
	else:
		player.velocity.x = player.KNOCKBACK_VELOCITY_X * player.facing_direction
	player.velocity.y = player.KNOCKBACK_VELOCITY_Y
	player.animation_player.play("fall")


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	if player.is_on_floor():
		stunned_state.was_knocked_back = true
		state_machine.change_state(stunned_state)
