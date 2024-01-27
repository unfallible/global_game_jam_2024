extends StringVar

class_name MutableString

@export var _value: String

func get_value() -> String:
	return _value

func set_value(value: String):
	if _value != value:
		_value = value
		emit_changed()
