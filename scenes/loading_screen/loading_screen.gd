class_name LoadingScreen
extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_fading: bool = false

func fade_in() -> void:
	is_fading = true
	animation_player.play("fade")

func fade_out_and_free() -> void:
	if is_fading:
		await animation_player.animation_finished

	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	self.call_deferred("queue_free")

func finished() -> void:
	while is_fading:
		await get_tree().process_frame
	return

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	is_fading = false
