class_name PlayerStunnedState
extends PlayerState

@export var ground_state: PlayerState

var was_knocked_back: bool = false

var stun_timer: Timer

func _ready() -> void:
	stun_timer = Timer.new()
	stun_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	stun_timer.one_shot = true
	stun_timer.autostart = false
	stun_timer.timeout.connect(_on_stun_finished)
	add_child(stun_timer)


func _on_stun_finished() -> void:
	player.is_invulnerable = true
	player.invulnerability_timer.start()
	state_machine.change_state(ground_state)


func enter() -> void:
	player.velocity.x = 0
	if player.is_attacking:
		player.is_attacking = false
		player.attack.set_deferred("monitoring", false)
		player.attack_timer.stop()
	if was_knocked_back:
		player.animation_player.play("fall")
		was_knocked_back = false
		stun_timer.start(player.POST_KNOCKBACK_STUN_TIME)
	else:
		player.hitbox.set_deferred("monitoring", false)
		player.animation_player.play("fall")
		stun_timer.start(player.STUN_TIME)


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
