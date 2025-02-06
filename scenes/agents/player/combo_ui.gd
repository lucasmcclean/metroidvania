extends Control

@onready var comboTimerDisplay := $ComboTimer as ProgressBar
@onready var comboTimer := Combo.timer as Timer

@onready var comboScoreDisplay:= $ComboScore as Label
var comboScore: int

func _ready() -> void:
	comboTimerDisplay.max_value = comboTimer.wait_time

func _process(_delta: float) -> void:
	comboScore = Combo.score
	comboTimerDisplay.value = comboTimer.time_left
	
	
	comboScoreDisplay.text = str(comboScore)
	if (comboScore <= 0):
		comboScoreDisplay.visible = false
		pass
	else:
		comboScoreDisplay.visible = true
