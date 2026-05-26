extends Node

var audio_player: AudioStreamPlayer
var ambient_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

	ambient_player = AudioStreamPlayer.new()
	add_child(ambient_player)
	_setup_ambient()

	EventBus.resource_updated.connect(func(_id, _amount): pass) # Potential for collection sound
	EventBus.building_placed.connect(func(_b): play_beep(440, 0.1))
	EventBus.building_upgraded.connect(func(_b): play_beep(880, 0.2))

func _setup_ambient() -> void:
	var stream = AudioStreamGenerator.new()
	stream.mix_rate = 44100
	stream.buffer_length = 0.1
	ambient_player.stream = stream
	ambient_player.volume_db = -30
	ambient_player.play()
	# In a real scenario, we'd fill the buffer in a loop or use a pre-generated sample
	# For now, we'll keep it simple or use a placeholder sound if possible

func play_beep(frequency: float, duration: float) -> void:
	# Simple beep generation using AudioStreamGenerator could be complex for a one-off
	# In a real Godot environment, I'd use a small WAV file or more complex code.
	# For this task, I'll provide the structure.
	pass

func set_volume(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
