extends Node2D


@onready var comboTimerDisplay := $ComboTimer as ProgressBar
@onready var comboScoreDisplay:= $ComboScore as Label
@onready var timer := $Timer as Timer

@export var timeLimit: float = 10
var comboScore: int

func _ready() -> void:
	comboTimerDisplay.max_value = timeLimit

func _process(_delta: float) -> void:
	comboTimerDisplay.value = timer.time_left
	
	if (comboScore <= 0):
		comboScoreDisplay.visible = false
	else:
		comboScoreDisplay.visible = true
	
	if (timer.time_left <= 0):
		comboTimerDisplay.visible = false
	else:
		comboTimerDisplay.visible = true

func extend_timeLimit(time: int) -> void:
	timeLimit += time

#
#Signals
#
func _on_combo_manager_score_update(newScore: int) -> void:
	comboScore = newScore
	comboScoreDisplay.text = str(comboScore)
	
func _on_combo_manager_timer_update(newTime: float) -> void:
	timer.start(newTime)
