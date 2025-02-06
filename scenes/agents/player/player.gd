class_name Player
extends CharacterBody2D

const MAX_WALKING_SPEED: float = 800.0
const GROUNDED_ACCELERATION: float = 7000.0
const JUMP_VELOCITY: float = -1500.0
const JUMP_BUFFER_TIME: float = 0.083333

var has_control: bool = true

@onready var sprite := $Sprite2D as Sprite2D
@onready var collision := $CollisionShape2D as CollisionShape2D
@onready var state_machine := $StateMachine as StateMachine


func _ready() -> void:
	state_machine.initialize()


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	self.move_and_slide()


func _process(delta: float) -> void:
	state_machine.update(delta)


func get_input_direction() -> float:
	return Input.get_axis("ui_left", "ui_right")


func apply_gravity(delta: float) -> void:
	velocity.y += Globals.GRAVITY * delta


func update_velocity(movement_direction: float, delta: float, acceleration: float, deceleration: float) -> void:
	if movement_direction != 0:
		velocity.x += movement_direction * acceleration * delta
		velocity.x = clampf(velocity.x, -MAX_WALKING_SPEED, MAX_WALKING_SPEED)
	else:
		if velocity.x <= (deceleration * delta) && velocity.x >= (-deceleration * delta):
			velocity.x = 0
		else:
			velocity.x -= signf(velocity.x) * deceleration * delta
