extends PlayerState

@export var ground_state: PlayerState
@export var jump_state: PlayerState

var _jump_buffer_timer: Timer

func _ready() -> void:
	_jump_buffer_timer = Timer.new()
	_jump_buffer_timer.wait_time = player.JUMP_BUFFER_TIME
	_jump_buffer_timer.autostart = false
	_jump_buffer_timer.one_shot = true
	_jump_buffer_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	add_child(_jump_buffer_timer)


func _check_jumping() -> void:
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer.start()


func _check_hit_ground() -> void:
	if player.is_on_floor():
		if !_jump_buffer_timer.is_stopped():
			state_machine.change_state(jump_state)
		else:
			state_machine.change_state(ground_state)


func physics_update(delta: float) -> void:
	player.apply_gravity_scaled(delta, player.FALLING_GRAVITY_SCALE)
	if player.has_control:
		player.update_velocity(player.get_input_direction(), delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
		_check_jumping()
	else:
		player.update_velocity(0, delta, player.GROUNDED_ACCELERATION, player.GROUNDED_ACCELERATION)
	_check_hit_ground()
