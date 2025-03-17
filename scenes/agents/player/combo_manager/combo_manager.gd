extends Node

signal score_update(newScore: int)
signal timer_update(newTime: float)
signal timer_pause()
signal timer_unpause()
signal rage_on()
signal rage_off()

# Max seconds a combo can be
# Can be upgraded?
@export var timeLimit: float = 5.00
var score: int = 0
@onready var timer := $Timer as Timer

func _ready() -> void:
	timer_pause.connect(pause)
	timer_unpause.connect(unpause)

func _physics_process(_delta) -> void:
	if (score == 15):
		rage_on.emit()

#
# Timer Functions
#
func start_combo() -> void:
	timer.start(timeLimit)
	timer_update.emit(timeLimit)

func add_score(amount: int) -> void:
	score += amount
	score_update.emit(score)

func add_time(amount: int) -> void:
	#Checking if Combo has already Started
	if(timer.time_left > 0):
		#Makes sure time doesnt go over limit
		timer.start(min(timer.time_left + amount, timeLimit))
		timer_update.emit(min(timer.time_left + amount, timeLimit))
	else:
		start_combo()

func take_time(amount: int) -> void:
	if (timer.time_left - amount > 0):
		timer.start(timer.time_left - amount)
		timer_update.emit(timer.time_left - amount)
	else:
		pass
		#Possible to add penelty for going negative time

func pause() -> void:
	timer.paused = true

func unpause() -> void:
	timer.paused = false

#
# Signals
#
func _on_timer_timeout() -> void:
	score = 0
	score_update.emit(score)
	rage_off.emit()

func _on_combo_ui_test() -> void:
	add_time(1)
	add_score(1)


func _on_slime_died() -> void:
	add_time(1)
	add_score(2)
