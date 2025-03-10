class_name Player
extends CharacterBody2D

const MAX_WALKING_SPEED: float = 800.0
const GROUNDED_ACCELERATION: float = 7000.0
const JUMP_VELOCITY: float = -1500.0
const JUMP_BUFFER_TIME: float = 0.083333
const FALLING_GRAVITY_SCALE: float = 1.3
const ATTACK_TIME: float = 0.15
const KNOCKBACK_FORCE: float = -200
const ATTACK_ANIMATIONS: Dictionary = {
	"idle": "idle_attack",
	"walk": "walk_attack",
	"fall": "fall_attack",
	"jump": "jump_attack"
}
const NON_ATTACK_ANIMATIONS: Dictionary = {
	"idle_attack": "idle",
	"walk_attack": "walk",
	"fall_attack": "fall",
	"jump_attack": "jump"
}

var has_control: bool = true
var facing_direction: float = 1
var is_attacking: bool = false
var attack_timer: Timer

@onready var sprite := $Sprite2D as Sprite2D
@onready var collision := $CollisionShape2D as CollisionShape2D
@onready var state_machine := $StateMachine as StateMachine
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var attack := $Attack as Hurtbox

func _ready() -> void:
	state_machine.initialize()
	attack_timer = Timer.new()
	attack_timer.wait_time = ATTACK_TIME
	attack_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	attack_timer.one_shot = true
	attack_timer.autostart = false
	attack_timer.timeout.connect(_on_attack_finished)
	add_child(attack_timer)


func _physics_process(delta: float) -> void:
	Global.player_position = self.global_position
	state_machine.physics_update(delta)
	self.move_and_slide()


func _process(delta: float) -> void:
	state_machine.update(delta)


func get_input_direction() -> float:
	return Input.get_axis("ui_left", "ui_right")


func apply_gravity(delta: float) -> void:
	velocity.y += Globals.GRAVITY * delta


func apply_gravity_scaled(delta: float, gravity_scale: float) -> void:
	velocity.y += Globals.GRAVITY * delta * gravity_scale


func update_facing_direction(input_direction: float) -> void:
	if input_direction != -1 && input_direction != 1:
		return
	facing_direction = input_direction
	if(input_direction == 1):
		rotation = 0
		scale.y = 1
	else:
		rotation = PI
		scale.y = -1


func update_velocity(movement_direction: float, delta: float, acceleration: float, deceleration: float) -> void:
	if movement_direction != 0:
		velocity.x += movement_direction * acceleration * delta
		velocity.x = clampf(velocity.x, -MAX_WALKING_SPEED, MAX_WALKING_SPEED)
	else:
		if velocity.x <= (deceleration * delta) && velocity.x >= (-deceleration * delta):
			velocity.x = 0
		else:
			velocity.x -= signf(velocity.x) * deceleration * delta


func play_attack_animation() -> void:
	var current_animation_name := animation_player.assigned_animation
	var new_animation_name := ATTACK_ANIMATIONS[current_animation_name] as String
	var current_animation_position := animation_player.current_animation_position
	animation_player.play(new_animation_name)
	animation_player.seek(current_animation_position, true)


func _on_attack_finished() -> void:
	attack.monitorable = false
	var current_animation_name := animation_player.assigned_animation
	var new_animation_name := NON_ATTACK_ANIMATIONS[current_animation_name] as String
	var current_animation_position := animation_player.current_animation_position
	animation_player.play(new_animation_name)
	animation_player.seek(current_animation_position, true)
	attack.monitorable = false
	is_attacking = false


func check_attack_input() -> void:
	if !attack_timer.is_stopped():
		return
	if !Input.is_action_just_pressed("attack"):
		return
	is_attacking = true
	attack.monitorable = true
	play_attack_animation()
	attack_timer.start()
