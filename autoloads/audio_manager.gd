extends Node

var sound_effects: Array[Resource] = [
	
]

var playing_sounds: Array[AudioStreamPlayer]
enum {
	
}

func _audio_finished(audio_player:AudioStreamPlayer):
	audio_player.queue_free()

func play_sound_effect(effect_id: int) -> AudioStreamPlayer:
	var new_audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	new_audio_player.stream = sound_effects[effect_id] as AudioStream
	new_audio_player.finished.connect(_audio_finished.bind(new_audio_player))
	add_child(new_audio_player)
	# new_audio_player.volume_db = linear_to_db(Settings.sfx_volume_percentage/100.0)
	new_audio_player.play()
	return new_audio_player

func stop_sound_effect(effect: AudioStreamPlayer):
	effect.stop()
	effect.queue_free()

func play_sound_effect_no_overlap(effect_id: int) -> AudioStreamPlayer:
	if(is_instance_valid(playing_sounds[effect_id]) && playing_sounds[effect_id] is AudioStreamPlayer):
		stop_sound_effect(playing_sounds[effect_id])
	var new_audio_player := play_sound_effect(effect_id)
	playing_sounds[effect_id] = new_audio_player
	return new_audio_player

func _ready():
	playing_sounds.resize(sound_effects.size())
