class_name AudioManager
extends Node
class_name AudioManager

var audio_player: AudioStreamPlayer
var ambient_player: AudioStreamPlayer
var sample_hz = 44100.0
var ambient_phase = 0.0

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.bus = "SFX"
	add_child(audio_player)

	ambient_player = AudioStreamPlayer.new()
	ambient_player.bus = "Music"
	add_child(ambient_player)
	_setup_ambient()

	EventBus.building_placed.connect(func(_b): play_beep(440, 0.15))
	EventBus.building_upgraded.connect(func(_b): play_beep(880, 0.2))
	EventBus.resource_updated.connect(func(_id, _amount): play_beep(220, 0.05))

func _setup_ambient() -> void:
	var stream = AudioStreamGenerator.new()
	stream.mix_rate = sample_hz
	stream.buffer_length = 0.5
	ambient_player.stream = stream
	ambient_player.play()

func _process(_delta: float) -> void:
	_fill_ambient_buffer()

func _fill_ambient_buffer() -> void:
	if not ambient_player.playing: return
	var playback = ambient_player.get_stream_playback()
	if not playback: return
	var to_fill = playback.get_frames_available()

	while to_fill > 0:
		var t = Time.get_ticks_msec() / 1000.0
		# 60Hz sine wave with slow LFO
		var freq = 60.0 + sin(t * 0.5) * 2.0
		var increment = freq / sample_hz
		ambient_phase = fmod(ambient_phase + increment, 1.0)
		var sample = sin(ambient_phase * TAU) * 0.05
		playback.push_frame(Vector2(sample, sample))
		to_fill -= 1

func play_beep(frequency: float, duration: float) -> void:
	# Avoid excessive spam for resource updates
	if frequency == 220 and randf() > 0.1: return

	var stream = AudioStreamGenerator.new()
	stream.mix_rate = sample_hz
	stream.buffer_length = duration + 0.1

	var temp_player = AudioStreamPlayer.new()
	temp_player.bus = "SFX"
	temp_player.stream = stream
	add_child(temp_player)
	temp_player.play()

	var playback = temp_player.get_stream_playback()
	if not playback:
		temp_player.queue_free()
		return

	var frames = int(sample_hz * duration)
	for i in range(frames):
		var t = float(i) / sample_hz
		var sample = sin(t * frequency * TAU) * 0.3
		if i > frames * 0.8:
			sample *= 1.0 - float(i - frames * 0.8) / (frames * 0.2)
		playback.push_frame(Vector2(sample, sample))

	get_tree().create_timer(duration + 0.1).timeout.connect(func(): temp_player.queue_free())

func play_click() -> void:
	play_beep(330, 0.03)

func _enter_tree():
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node):
	if node is Button:
		if not node.pressed.is_connected(play_click):
			node.pressed.connect(play_click)
