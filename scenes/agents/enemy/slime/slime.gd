class_name Slime
extends CharacterBody2D

const speed = 50
var is_slime_chase: bool = true

var health = 10
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var dealt_damage = 10
var is_dealing_damage: bool = false

var dir: Vector2
var dirCopy: Vector2
const gravity = 900
var knockback_force = -200
var is_roaming: bool = true
var player_in_area = false

		
func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:
		if !is_slime_chase:
				velocity += dir * speed * delta
		elif is_slime_chase and !taking_damage:
			$JumpTimer.wait_time = 2
			var dir_to_player = (Global.player_position - global_position).normalized()
			if !is_on_floor():
				velocity.x = dir_to_player.x * 200
				dir.x = abs(velocity.x) / velocity.x
			else:
				velocity.x = 0
		elif taking_damage:
			var knockback_dir = position.direction_to(Global.player_position) * knockback_force
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("walk")
		if dir.x == -1:
			anim_sprite.flip_h = true
		elif dir.x == 1:
			anim_sprite.flip_h = false 
	elif !dead and taking_damage and !is_dealing_damage:
		anim_sprite.play("hurt")
		await get_tree().create_timer(.08).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.play("death")
		await get_tree().create_timer(1.0).timeout
		handle_death()
		

func handle_death():
	self.queue_free()

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5, 2.0, 2.5])
	if !is_slime_chase:
		dirCopy = dir
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		if dir != dirCopy:
			velocity.x = 0
		

func choose(array):
	array.shuffle()
	return array.front()

func _on_slime_hitbox_area_entered(area: Area2D) -> void:
	var damage = Global.player_damage
	##To be implemented once the attack is created


func _on_jump_timer_timeout() -> void:
	if is_slime_chase:
		velocity.y = -600
		var dir_to_player = (Global.player_position - global_position).normalized()
		velocity.x = dir_to_player.x * 100
