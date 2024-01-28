extends Resource

class_name MapData

var _reader: OsuReader = OsuReader.new()
@export_file("*.osu") var beatmap_filename: String:
    get:
        return beatmap_filename
    set(value):
        beatmap_filename = value
        _reader.read_beatmap(beatmap_filename)

var hit_objects: Array[HitObject]:
    get:
        return _reader.hit_objects

var timing_points: Array[TimingPoint]:
    get:
        return _reader.timing_points

var general_data: Dictionary:
    get:
        return _reader.general_data

@export var tracks: Array[AudioStream]
