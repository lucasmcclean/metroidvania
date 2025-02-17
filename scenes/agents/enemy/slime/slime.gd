class_name Slime
extends CharacterBody2D

const _speed = 50
var _is_slime_chase: bool = true

# var _health: int = 10
# var _health_max: int = 80

var _dead: bool = false
var _taking_damage: bool = false
# var _dealt_damage: int = 10
var _is_dealing_damage: bool = false

var _dir: Vector2
var _dir_copy: Vector2
const _gravity = 900
var _knockback_force: int = -200
var _is_roaming: bool = true
# var _player_in_area: bool = false

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _process(_delta: float) -> void:
	if !is_on_floor():
		velocity.y += _gravity * _delta
		velocity.x = 0
	_move(_delta)
	_handle_animation()
	move_and_slide()


func _move(_delta: float) -> void:
	if !_dead:
		if !_is_slime_chase:
			velocity += _dir * _speed * _delta
		elif _is_slime_chase and !_taking_damage:
			$JumpTimer.wait_time = 2
			var _dir_to_player: Vector2 = (Global.player_position - global_position).normalized()
			if !is_on_floor():
				velocity.x = _dir_to_player.x * 200
				_dir.x = abs(velocity.x) / velocity.x
			else:
				velocity.x = 0
		elif _taking_damage:
			var _knockback_dir: Vector2 = position.direction_to(Global.player_position) * _knockback_force
			velocity.x = _knockback_dir.x
		_is_roaming = true
	elif _dead:
		velocity.x = 0


func _handle_animation() -> void:
	if !_dead and !_taking_damage and !_is_dealing_damage:
		_sprite.play("walk")
		if _dir.x == -1:
			_sprite.flip_h = true
		elif _dir.x == 1:
			_sprite.flip_h = false 
	elif !_dead and _taking_damage and !_is_dealing_damage:
		_sprite.play("hurt")
		await get_tree().create_timer(.08).timeout
		_taking_damage = false
	elif _dead and _is_roaming:
		_is_roaming = false
		_sprite.play("death")
		await get_tree().create_timer(1.0).timeout
		_handle_death()


func _handle_death() -> void:
	self.queue_free()


func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = [1.5, 2.0, 2.5].pick_random()
	if !_is_slime_chase:
		_dir_copy = _dir
		_dir = [Vector2.RIGHT, Vector2.LEFT].pick_random()
		if _dir != _dir_copy:
			velocity.x = 0


func _on_slime_hitbox_area_entered(_area: Area2D) -> void:
	## Talk this over with Stovehead because I believe that each area may handle
	## its own damage value rather than there being a global
	var _damage: int = Global.player_damage
	## To be implemented once the attack is created


func _on_jump_timer_timeout() -> void:
	if _is_slime_chase:
		velocity.y = -600
		var _dir_to_player: Vector2 = (Global.player_position - global_position).normalized()
		velocity.x = _dir_to_player.x * 100
