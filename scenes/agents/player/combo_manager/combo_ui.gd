extends Control

@onready var comboTimerDisplay := $ComboTimer as ProgressBar
@onready var comboScoreDisplay:= $ComboScore as Label
var comboScore: int
var comboTime: int

func _ready() -> void:
	comboTimerDisplay.max_value = 5 #placeholder
	

func _process(_delta: float) -> void:
	
	if (comboScore <= 0):
		comboScoreDisplay.visible = false
		pass
	else:
		comboScoreDisplay.visible = true
	
	if (comboTime <= 0):
		comboTimerDisplay.visible = false
		pass
	else:
		comboTimerDisplay.visible = true


func _on_combo_manager_score_update(newScore: int) -> void:
	comboScore = newScore
	comboScoreDisplay.text = str(comboScore)


func _on_combo_manager_timer_update(newTime: float) -> void:
	comboTime = newTime
	comboTimerDisplay.value = comboTime
