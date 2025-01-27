extends Node

## Number of effect players to allocate for static usage.
@export var num_effect_players: int = 32

enum Bus {
	MASTER,
	SFX,
	MUSIC,
	DIALOGUE,
	}

var effect_player_pool: Array[AudioStreamPlayer]
var next_effect_player: int = 0

enum SoundEffect {
	# EXAMPLE
	}
var sound_effects: Array[AudioStream] = [
	# preload("res://assets/sfx/example.wav")
	]


func _ready() -> void:
	for i in range(num_effect_players):
		var effect_player: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(effect_player)
		effect_player_pool.append(effect_player)


## Plays the given sound effect and returns a function for stopping it.
func play_effect(sound_effect: SoundEffect) -> Callable:
	var stream: AudioStream = sound_effects[sound_effect]
	var idx: int = next_effect_player_idx()
	var effect_player: AudioStreamPlayer = effect_player_pool[idx]
	effect_player.stream = stream
	effect_player.bus = AudioServer.get_bus_name(Bus.SFX)
	effect_player.play()

	return func() -> void: effect_player.stop()


## Returns the index of the next available effect player.
func next_effect_player_idx() -> int:
	var next: int = next_effect_player
	next_effect_player = (next_effect_player + 1) % num_effect_players
	return next


## Sets the volume of the specified bus given a percentage value for volume.
func set_volume(bus_index: Bus, volume: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))


## Returns the linear volume of the given bus index.
func get_volume(bus_index: Bus) -> float:
	return linear_to_db(AudioServer.get_bus_volume_db(bus_index))


## Mutes the specified bus index. 
func mute_bus(bus_index: Bus) -> void:
	AudioServer.set_bus_mute(bus_index, true)


## Unmutes the specified bus index.
func unmute_bus(bus_index: Bus) -> void:
	AudioServer.set_bus_mute(bus_index, false)


## Fades bus volume from current to given volume, as a percentage,
## over duration.
func fade_in(bus_index: Bus, volume: float, duration: float) -> void:
	var tween := get_tree().create_tween()
	tween.tween_method(set_volume.bind(bus_index), 
	AudioServer.get_bus_volume_db(bus_index), linear_to_db(volume), duration)


## Fades bus volume out over given duration to zero.
func fade_out(bus_index: Bus, duration: float) -> void:
	var tween := get_tree().create_tween()
	tween.tween_method(set_volume.bind(bus_index), 
	AudioServer.get_bus_volume_db(bus_index), 0, duration)
