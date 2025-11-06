extends Node

var sounds = {
	"hurt": preload("res://sounds/hurt.wav"),
	"explosion": preload("res://sounds/explosion.wav")
}

func play_sound(sound_key: String):  
	for audio_player: AudioStreamPlayer in get_children():
		if not audio_player.is_playing() and audio_player.name != "Song":
			audio_player.stream = sounds[sound_key]
			audio_player.play()
			return
	push_error("Failed to play sound. No available Audio Stream Players in Sound Manager")
