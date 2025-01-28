class_name LoadingScreen
extends CanvasLayer

var _is_fading: bool = false

@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	self.visible = false


## Fades in the loading screen.
func fade_in() -> void:
	_is_fading = true
	_animation_player.play("fade")
	self.visible = true
	await _finished()


## Fades out the loading screen and frees it.
func fade_out() -> void:
	_is_fading = true
	_animation_player.play_backwards("fade")
	await _finished()
	self.visible = false


func _finished() -> void:
	while _is_fading:
		await get_tree().process_frame
	return


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_is_fading = false
