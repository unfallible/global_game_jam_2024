extends RefCounted

class_name GeneralBeatmapData

var AudioFilename: String #Location of the audio file relative to the current folder 	
var AudioLeadIn: int #Milliseconds of silence before the audio starts playing 	0
var AudioHash: String #Deprecated 	
var PreviewTime: int #Time in milliseconds when the audio preview should start 	-1
var Countdown: int #Speed of the countdown before the first hit object (0 = no countdown, 1 = normal, 2 = half, 3 = double) 	1
var SampleSet: String #Sample set that will be used if timing points do not override it (Normal, Soft, Drum) 	Normal
var StackLeniency: float #Multiplier for the threshold in time where hit objects placed close together stack (0–1) 	0.7
var Mode: int # Game mode (0 = osu!, 1 = osu!taiko, 2 = osu!catch, 3 = osu!mania) 	0
var LetterboxInBreaks: int  #0 or 1 	Whether or not breaks have a letterboxing effect 	0
var StoryFireInFront: int  #0 or 1 	Deprecated 	1
var UseSkinSprites: int  #0 or 1 	Whether or not the storyboard can use the user's skin images 	0
var AlwaysShowPlayfield: int  #0 or 1 	Deprecated 	0
var OverlayPosition: String  #Draw order of hit circle overlays compared to hit numbers (NoChange = use skin setting, Below = draw overlays under numbers, Above = draw overlays on top of numbers) 	NoChange
var SkinPreference: String  #Preferred skin to use during gameplay 	
var EpilepsyWarning: int  # 0 or 1 	Whether or not a warning about flashing colours should be shown at the beginning of the map 	0
var CountdownOffset: int  #Time in beats that the countdown starts before the first hit object 	0
var SpecialStyle: int  #0 or 1 	Whether or not the "N+1" style key layout is used for osu!mania 	0
var WidescreenStoryboard: int  #0 or 1 	Whether or not the storyboard allows widescreen viewing 	0
var SamplesMatchPlaybackRate: int  #0 or 1 	Whether or not sound samples will change rate when playing with speed-changing mods 	0

func _init(general_beatmap_data_string: String):
	var general_data = general_beatmap_data_string.split(",")
	self.AudioFilename = general_data[0]
	self.AudioLeadIn = general_data[1]
