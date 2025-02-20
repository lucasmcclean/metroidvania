extends Node

# Max seconds a combo can be
# Can be upgraded?
@export var timeLimit: float = 5.00
var score: int = 0

@onready var timer := $Timer as Timer


func start_combo() -> void:
	timer.start(timeLimit)


func add_score(amount: int) -> void:
	score += amount


func add_time(amount: int) -> void:
	#Checking if Combo has already Started
	if(timer.time_left > 0):
		#Makes sure time doesnt go over limit
		timer.start(min(timer.time_left + amount, timeLimit))
	else:
		start_combo()


func take_time(amount: int) -> void:
	if (timer.time_left - amount > 0):
		timer.start(timer.time_left - amount)
	else:
		pass
		#Possible to add penelty for going negative time


func pause() -> void:
	timer.paused = true


func unpause() -> void:
	timer.paused = false


func _on_timer_timeout() -> void:
	score = 0
