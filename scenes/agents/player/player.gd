class_name Player
extends CharacterBody2D

@onready var sprite := $Sprite2D as Sprite2D
@onready var collision := $CollisionShape2D as CollisionShape2D
@onready var state_machine := $StateMachine as StateMachine

func _ready() -> void:
	state_machine.initialize()

func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)

func _process(delta: float) -> void:
	state_machine.update(delta)

# const MAX_WALKING_SPEED:float = 700.0
# const ACCELERATION:float = 5000.0

# var has_control: bool = true
# var current_state: States = States.GROUNDED

# func update_velocity(movement_direction: float, delta: float) -> void:
# 	if movement_direction != 0:
# 		velocity.x += movement_direction * ACCELERATION * delta
# 		velocity.x = clamp(velocity.x, -MAX_WALKING_SPEED, MAX_WALKING_SPEED)
# 	else:
# 		if velocity.x <= (ACCELERATION * delta) && velocity.x >= (-ACCELERATION * delta):
# 			velocity.x = 0
# 		else:
# 			velocity.x -= sign(velocity.x) * ACCELERATION * delta

# func ground_movement(delta: float) -> void:
# 	if has_control:
# 		update_velocity(Input.get_axis("ui_left", "ui_right"), delta)
# 	else:
# 		update_velocity(0, delta)

# func handle_input(delta: float) -> void:
# 	match current_state:
# 		States.GROUNDED:
# 			ground_movement(delta)

# func _physics_process(delta: float) -> void:
# 	handle_input(delta)
# 	move_and_slide()
