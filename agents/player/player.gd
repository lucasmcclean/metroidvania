extends CharacterBody2D

const MAX_WALKING_SPEED:float = 700.0
const ACCELERATION:float = 5000.0

@onready var sprite := $Sprite2D as Sprite2D
@onready var collision := $CollisionShape2D as CollisionShape2D

func handle_input(delta: float) -> void:
	var input_direction := Input.get_axis("ui_left", "ui_right")
	if input_direction != 0:
		velocity.x += input_direction * ACCELERATION * delta
		velocity.x = clamp(velocity.x, -MAX_WALKING_SPEED, MAX_WALKING_SPEED)
	else:
		if velocity.x <= (ACCELERATION * delta) && velocity.x >= (-ACCELERATION * delta):
			velocity.x = 0
		else:
			velocity.x -= sign(velocity.x) * ACCELERATION * delta

func _physics_process(delta: float) -> void:
	handle_input(delta)
	move_and_slide()
