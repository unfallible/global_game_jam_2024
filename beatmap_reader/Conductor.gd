extends Node

class_name Conductor

enum {SEC, MSEC}

const USEC_PER_SEC = 1000000.0
const USEC_PER_MSEC = 1000.0
const MSEC_PER_SEC = 1000.0
const SEC_PER_MIN = 60.0

const GRACE_PERIOD_MSEC = 100.0 # the amount of time before two actions are no longer considered simultaneous

@export var map_data: MapData:
    get:
        return map_data
    set(value):
        map_data = value
        stream_manager.level_data = value
    
@export var hardware_clock: bool = true

@export var global_latency_sec: float = 0.0 #seconds
#@export var loop: bool = false

@export var approach_rate_msec: IntVar

@export var stream_manager: AudioStreamManager

var start_time
var time_delay
var entry_point: float # msec

var kludgy_song_position: float = 0.0

var song_position: float = 0.0:
    get:
        return get_song_position() # playback time in msec
var next_section: int = 0
var current_section: TimingPoint
var parent_section: TimingPoint
var last_reported_beat: int = 0
var current_beat: int = 1
var measure: int = 0

var timing_points: Array
var hit_objects: Array
var general_data: Dictionary
var next_hit_obj = 0
var warning_time: float = 2000.0 # warning time for each hit object in seconds
#var debug = true
var debug = false

signal beat(position)
signal measure_occurred(position)
signal hit_object(object, warning_time)
signal started()

func initialize(start_time_msec: float):
    next_section = 0
    current_section = timing_points[0]
    parent_section = current_section
    
    last_reported_beat = 0
    current_beat = 1
    measure = 0
    $StartTimer.stop()

#func load_reader(reader: OsuReader):
func load_reader():
    timing_points = map_data.timing_points
    hit_objects = map_data.hit_objects
    general_data = map_data.general_data
    var timing_point: TimingPoint = timing_points[0]
    #self.stream = load(reader.audio_file_path)
    #self.stream.set_loop(false)
    current_section = timing_points[0]
    parent_section = current_section

func _ready():
    Input.set_use_accumulated_input(false)
    #var reader: OsuReader = OsuReader.new()
    #reader.read_beatmap(beatmap_file)
    load_reader()
    current_section = timing_points[0]
    parent_section = current_section

func skip_intro() -> bool:
    var skipped = song_position * MSEC_PER_SEC < hit_objects[0].time
    if skipped:
        play_with_time_offset(hit_objects[0].time)
    return skipped

func _physics_process(delta):
    if stream_manager.playing:
        update_song_position()
        
        _update_timing_point()
        var section_position: float = song_position*MSEC_PER_SEC - parent_section.time 
        current_beat = int(floor(section_position / parent_section.beatLength))
#		if ((last_reported_beat+1) * parent_section.beatLength + parent_section.time) / MSEC_PER_SEC <= song_position: #seconds 
#			current_beat += 1
        _report_beat()
        
        _report_hit_object()

func _report_beat():
    if last_reported_beat < current_beat:
        if measure >= current_section.meter:
            measure = 1
        else:
            measure += 1
        emit_signal("beat", current_beat)
        emit_signal("measure", measure)
        last_reported_beat = current_beat
#		print("timing point: %s,  beat: %s" % [current_section, current_beat])

func _report_hit_object():
    var hit_time = song_position*MSEC_PER_SEC + warning_time
    while next_hit_obj < len(hit_objects) \
        and hit_objects[next_hit_obj].time <= hit_time:
        var hit_obj: HitObject = hit_objects[next_hit_obj]
#		print("song_position: %s, hit_obj: %s" % [song_position, hit_obj.time])
#		print("wall time: %s" % get_playback_position())
        emit_signal("hit_object", hit_obj, hit_obj.time - song_position)
        next_hit_obj += 1

func _update_timing_point():
    if next_section < len(timing_points) \
    and timing_points[next_section].time <= song_position*MSEC_PER_SEC:
        current_section = timing_points[next_section]
        if current_section.uninherited == 1:
            parent_section = current_section
            last_reported_beat = 0
            current_beat = 1
            measure = 1
            emit_signal("measure", 1)
        next_section += 1

func play_with_time_offset(msec: float = -1):
    initialize(msec) # this should check the timing points
#	var wait_time = abs(msec) if msec < 0 else int(osu_reader.general_data["AudioLeadIn"])
    if msec < 0:
        $StartTimer.wait_time = abs(msec)
        $StartTimer.start()
    else:
        if not debug:
            _play_song(msec)

func _exit_tree():
    queue_free()

func beat_offset(units: int = MSEC) -> float:
    #check if next beat is a new section
    var last_beat_time: float = (last_reported_beat * parent_section.beatLength + parent_section.time) / MSEC_PER_SEC #seconds
    var next_beat_time: float = last_beat_time + parent_section.beatLength / MSEC_PER_SEC
    var time_off_beat: float
    if song_position - last_beat_time < next_beat_time - song_position: 
        time_off_beat = song_position - last_beat_time
    else:
        time_off_beat = song_position - next_beat_time
    
    match units:
        SEC:
            return time_off_beat
        MSEC:
            return time_off_beat * MSEC_PER_SEC
    return time_off_beat #seconds

func update_song_position() -> float:
#	assert(playing, "error: not playing!")
    if not stream_manager.playing:
        return -1.0
    
    if hardware_clock:
        var new_song_position = stream_manager.get_playback_position() + AudioServer.get_time_since_last_mix()
        new_song_position -= AudioServer.get_output_latency() + global_latency_sec
        kludgy_song_position = max(new_song_position, kludgy_song_position)
    else:
        kludgy_song_position = max((Time.get_ticks_usec() - start_time) / USEC_PER_SEC - time_delay, 0)
        kludgy_song_position += entry_point / MSEC_PER_SEC
    return kludgy_song_position

func _on_StartTimer_timeout():
    _play_song()

func _play_song(msec: float = 0.0):
    start_time = Time.get_ticks_usec() #+ msec * USEC_PER_MSEC
    time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency() + global_latency_sec
    entry_point = msec
    stream_manager.play(msec / MSEC_PER_SEC)
    emit_signal("started")

#func _on_Conductor_finished():
    #stream_manager.stop()
    #if loop:
        #play_with_time_offset()

func get_song_position(units: int = SEC) -> float:
    match units:
        SEC:
            return kludgy_song_position
        MSEC:
            return kludgy_song_position * MSEC_PER_SEC
    return -999999999999.0
