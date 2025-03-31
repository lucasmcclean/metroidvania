class_name Slime
extends CharacterBody2D


const GRAVITY: int = 900
const SPEED: float = 50.0
const DIRECTION_WAIT_TIMES: Array[float] = [1.5, 2.0, 2.5]

var _is_slime_chase: bool = true
var _dead: bool = false
var _taking_damage: bool = false
var _is_dealing_damage: bool = false
var _dir: Vector2
var _dir_copy: Vector2
const _gravity = 900
var _knockback_force: int = -800
var _is_roaming: bool = true

## Change to animation player regular sprite
@onready var _sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var _jump_timer := $JumpTimer as Timer
@onready var _direction_timer := $DirectionTimer as Timer
@onready var _health_component := $HealthComponent as HealthComponent



func _process(_delta: float) -> void:
	Global.slime_position = self.global_position
	if !is_on_floor():
		velocity.y += _gravity * _delta
	
	if _dead:
		velocity.y += _gravity * _delta
		_handle_animation()
		
	
	_decide_behaivor()
	_move(_delta)
	_handle_animation()
	move_and_slide()


func _move(_delta: float) -> void:
	if !_dead:
		if !_is_slime_chase:
			velocity += _dir * SPEED * _delta
		elif _is_slime_chase and !_taking_damage:
			_jump_timer.wait_time = 2
			var _dir_to_player: Vector2 = (Global.player_position - global_position).normalized()
			if !is_on_floor():
				velocity.x = _dir_to_player.x * 200
				_dir.x = absf(velocity.x) / velocity.x
			else:
				velocity.x = 0
		elif _taking_damage:
			var _knockback_dir: Vector2 = position.direction_to(Global.player_position) * _knockback_force
			velocity.x = _knockback_dir.x
		_is_roaming = true
	elif _dead:
		velocity.x = 0
		return
		
	if is_on_floor() and _taking_damage:
		velocity.x *= pow(0.05, _delta)

	if !_is_slime_chase and !_taking_damage:
		$JumpTimer.wait_time = 1
		if !is_on_floor():
			velocity.x = _dir.x * 200
		else:
			velocity.x = 0
	elif _is_slime_chase and !_taking_damage:
		$JumpTimer.wait_time = 2
		var _dir_to_player: Vector2 = (Global.player_position - global_position).normalized()
		if !is_on_floor():
			velocity.x = _dir_to_player.x * 200
			_dir.x = abs(velocity.x) / velocity.x
		else:
			velocity.x = 0
	_is_roaming = true


func _handle_animation() -> void:
	if !_dead and !_taking_damage and !_is_dealing_damage:
		_sprite.play("walk")
		if _dir.x == -1:
			_sprite.flip_h = true
		elif _dir.x == 1:
			_sprite.flip_h = false 
	elif !_dead and _taking_damage and !_is_dealing_damage:
		_sprite.play("hurt")
		await get_tree().create_timer(.08, true, true).timeout
		_taking_damage = false
	elif _dead and _is_roaming:
		_is_roaming = false
		_sprite.play("death")
		await get_tree().create_timer(1.0, true, true).timeout
		_handle_death()


func _handle_death() -> void:
	self.queue_free()


func _on_direction_timer_timeout() -> void:
	_direction_timer.wait_time = DIRECTION_WAIT_TIMES[randi() % DIRECTION_WAIT_TIMES.size()]
	if !_is_slime_chase:
		_dir_copy = _dir
		if randi() % 2 == 0:
			_dir = Vector2.LEFT
		else:
			_dir = Vector2.RIGHT
		if _dir != _dir_copy:
			velocity.x = 0


func _on_slime_hitbox_area_entered(_area: Area2D) -> void:
	## Talk this over with Stovehead because I believe that each area may handle
	## its own damage value rather than there being a global
	var _damage: int = Global.player_damage
	## To be implemented once the attack is created

func _on_slime_hit(_attacker: Hurtbox) -> void:
	var _knockback_dir: Vector2 = position.direction_to(Global.player_position).normalized() * _knockback_force
	velocity.x = _knockback_dir.x
	_taking_damage = true;
	if _health_component._remaining_hp == 0:
		_dead = true


func _on_jump_timer_timeout() -> void:
	if _is_slime_chase:
		velocity.y = -600
		var _dir_to_player: Vector2 = (Global.player_position - global_position).normalized()
		velocity.x = _dir_to_player.x * 100
	if !_is_slime_chase:
		velocity.y = -300


func _decide_behaivor() -> void:
	var _dir_to_player: float = (Global.player_position - global_position).length()
	if _dir_to_player < 500:
		_is_slime_chase = true
		_is_roaming = false
	else:
		_is_slime_chase = false
		_is_roaming = true
