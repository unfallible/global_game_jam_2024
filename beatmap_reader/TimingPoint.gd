extends RefCounted

class_name TimingPoint

var time: int  # Start time of the timing section, in milliseconds from the beginning of the beatmap's audio. The end of the timing section is the next timing point's time (or never, if this is the last timing point).
var beatLength: float  # This property has two meanings: 1) For uninherited timing points, the duration of a beat, in milliseconds. 2) For inherited timing points, a negative inverse slider velocity multiplier, as a percentage. For example, -50 would make all sliders in this timing section twice as fast as SliderMultiplier.
var meter: int  # Amount of beats in a measure. Inherited timing points ignore this property.
var sampleSet:int  # Default sample set for hit objects (0 = beatmap default, 1 = normal, 2 = soft, 3 = drum).
var sampleIndex: int  # Custom sample index for hit objects. 0 indicates osu!'s default hitsounds.
var volume: int  # Volume percentage for hit objects.
var uninherited: int  # (0 or 1): Whether or not the timing point is uninherited.
var effects: int  # Bit flags that give the timing point extra effects. See the effects section.


func _init(timing_point_str: String):
	var timing_point_data: PackedStringArray = timing_point_str.split(",")
	self.time = int(timing_point_data[0])
	self.beatLength = float(timing_point_data[1])
	self.meter = int(timing_point_data[2])
	self.sampleSet = int(timing_point_data[3])
	self.sampleIndex = int(timing_point_data[4])
	self.volume = int(timing_point_data[5])
	self.uninherited = int(timing_point_data[6])
	self.effects = int(timing_point_data[7])

