extends Node

class_name AudioStreamManager

@export var level_data: MapData:
    get:
        return level_data
    set(value):
        level_data = value
        for child: Node in get_children():
            child.queue_free()
        for song: AudioStream in level_data.tracks:
            var new_player: AudioStreamPlayer = AudioStreamPlayer.new()
            new_player.stream = song
            _track_players.append(new_player)
            add_child(new_player)

@export var approach_rate: IntVar

var _track_players: Array[AudioStreamPlayer] = []
@export var songs: Array[AudioStream] = []:
    get:
        return level_data.tracks

@export var insanity_level: FloatVar
#var _current_insanity_level: int = 0

var playing: bool:
    get:
        return _track_players[0].playing

func play(msec: float = 0.0) -> void:
    for player: AudioStreamPlayer in _track_players:
        player.play(msec)

func stop() -> void:
    for player: AudioStreamPlayer in _track_players:
        player.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
    play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    _modulate_insanity(insanity_level.get_value())

func _modulate_insanity(new_insanity_level) -> void:
    for track: AudioStreamPlayer in _track_players:
        track.volume_db = linear_to_db(0) 
    var low_track: int = floor(new_insanity_level)
    _track_players[low_track].volume_db = _lower_level_db(new_insanity_level)
    var high_track: int = ceil(new_insanity_level)
    if (low_track != high_track):
        _track_players[high_track].volume_db = _higher_level_db(new_insanity_level)
    #if low_track != high_track:

func _higher_level_db(insanity_level) -> float:
    var high_track_db: float = linear_to_db(fmod(insanity_level, 1.0))
    return high_track_db

func _lower_level_db(insanity_level) -> float:
    var low_track_db : float = linear_to_db(1.0-fmod(insanity_level, 1.0))
    return low_track_db

func get_playback_position() -> float:
    return _track_players[0].get_playback_position()

