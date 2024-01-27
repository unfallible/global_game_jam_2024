extends RefCounted

class_name OsuReader

const OSU_PX_WIDTH = 640
const OSU_PX_LENGTH = 480

var raw_beatmap_data: String
var beatmap_lines: PackedStringArray
var base_dir: String

var general_data: Dictionary = {}:
	get:
		if not general_data_ready:
			general_data = {}
			var general_section: int = self.beatmap_lines.find("[General]")
			var i = general_section + 1
			#while i < len(beatmap_lines) and not beatmap_lines[i].empty():
			while i < len(beatmap_lines) and beatmap_lines[i] != "":
				var general_str = beatmap_lines[i].split(":")
				general_data[general_str[0]] = general_str[1].strip_edges()
				i += 1
		return general_data
var general_data_ready: bool = false

var metadata: Dictionary = {}:
	get:
		if not metadata_ready:
			metadata = {}
			var metadata_section = self.beatmap_lines.find("[Metadata]")
			var i = metadata_section + 1
			#while i < len(beatmap_lines) and not beatmap_lines[i].empty():
			while i < len(beatmap_lines) and beatmap_lines[i] != "":
				var metadata_str = beatmap_lines[i].split(":")
	#			print("%s" % metadata_str)
				metadata[metadata_str[0]] = metadata_str[1].strip_edges()
				i += 1
		return metadata
		#return get_metadata()
var metadata_ready: bool =  false

var hit_objects: Array[HitObject] = []:
	get:
		if not hit_objects_ready:
			hit_objects = []
			var hit_obj_section = self.beatmap_lines.find("[HitObjects]")
			var i = hit_obj_section + 1
			#while i < len(beatmap_lines) and not beatmap_lines[i].empty():
			while i < len(beatmap_lines) and beatmap_lines[i] != "":
				var hit_obj_str = beatmap_lines[i]
	#			print(hit_obj_str)
				hit_objects.append(HitObject.new(hit_obj_str))
				i += 1
		return hit_objects
var hit_objects_ready: bool =  false

var timing_points: Array[TimingPoint] = []: 
	get:
		if not timing_points_ready:
			timing_points = []
			var timing_point_section = self.beatmap_lines.find("[TimingPoints]")
			var i = timing_point_section + 1
			#while i < len(beatmap_lines) and not beatmap_lines[i].empty():
			while i < len(beatmap_lines) and beatmap_lines[i] != "":
				var timing_point_str = beatmap_lines[i]
	#			print(timing_point_str)
				timing_points.append(TimingPoint.new(timing_point_str))
				i += 1
		return timing_points
var timing_points_ready: bool =  false

var audio_file_path: String = "":
	get:
		return get_audio_file_path()

func read_beatmap(file_name: String) -> bool:
	general_data_ready = false
	metadata_ready = false
	hit_objects_ready = false
	timing_points_ready = false
	
	var file: FileAccess = FileAccess.open(file_name, FileAccess.READ)
	if file == null:
		return false
	self.raw_beatmap_data = file.get_as_text()
	file.close()
	self.base_dir = file_name.get_base_dir()
	self.beatmap_lines = self.raw_beatmap_data.split("\n")
	for index: int in len(beatmap_lines):
		beatmap_lines[index] = beatmap_lines[index].strip_edges()
	return true

func get_audio_file_path() -> String:
	return base_dir+"/"+self.general_data["AudioFilename"]

#func get_timing_points() -> Array[TimingPoint]:
	#if not timing_points_ready:
		#timing_points = []
		#var timing_point_section = self.beatmap_lines.find("[TimingPoints]")
		#var i = timing_point_section + 1
		#while i < len(beatmap_lines) and not beatmap_lines[i].empty():
			#var timing_point_str = beatmap_lines[i]
##			print(timing_point_str)
			#timing_points.append(TimingPoint.new(timing_point_str))
			#i += 1
	#return timing_points
#
#func get_hit_objects() -> Array:
	#if not hit_objects_ready:
		#hit_objects = []
		#var hit_obj_section = self.beatmap_lines.find("[HitObjects]")
		#var i = hit_obj_section + 1
		#while i < len(beatmap_lines) and not beatmap_lines[i].empty():
			#var hit_obj_str = beatmap_lines[i]
##			print(hit_obj_str)
			#hit_objects.append(HitObject.new(hit_obj_str))
			#i += 1
	#return hit_objects
#
#func get_general_data() -> Dictionary:
	#if not general_data_ready:
		#general_data = {}
		#var general_section = self.beatmap_lines.find("[General]")
		#var i = general_section + 1
		#while i < len(beatmap_lines) and not beatmap_lines[i].empty():
			#var general_str = beatmap_lines[i].split(":")
##			print("%s" % general_str)
			#general_data[general_str[0]] = general_str[1].strip_edges()
			#i += 1
	#return general_data
#
#func get_metadata() -> Dictionary:
	#if not metadata_ready:
		#metadata = {}
		#var metadata_section = self.beatmap_lines.find("[Metadata]")
		#var i = metadata_section + 1
		#while i < len(beatmap_lines) and not beatmap_lines[i].empty():
			#var metadata_str = beatmap_lines[i].split(":")
##			print("%s" % metadata_str)
			#metadata[metadata_str[0]] = metadata_str[1].strip_edges()
			#i += 1
	#return metadata
