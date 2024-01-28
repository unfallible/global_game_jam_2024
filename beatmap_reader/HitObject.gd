extends RefCounted

class_name HitObject

var x: int  #
var y: int  # Position in osu! pixels of the object.
var time: int  # Time when the object is to be hit, in milliseconds from the beginning of the beatmap's audio.
var type: int  # Bit flags indicating the type of the object. See the type section.
var hitSound: int  # Bit flags indicating the hitsound applied to the object. See the hitsounds section.
var objectParams: Array  # (Comma-separated list): Extra parameters specific to the object's type.
var hitSample: Array  # (Colon-separated list): Information about which samples are played when the object is hit. It is closely related to hitSound; see the hitsounds section. If it is not written, it defaults to 0:0:0:0:.

func _init(hit_object_string: String):
    var hit_obj_data = hit_object_string.split(",", true, 6)
    self.x = int(hit_obj_data[0])
    self.y = int(hit_obj_data[1])
    self.time = int(hit_obj_data[2])
    self.type = int(hit_obj_data[3])
    self.hitSound = int(hit_obj_data[4])
