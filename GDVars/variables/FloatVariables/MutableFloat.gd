extends FloatVar

class_name MutableFloat

@export var _value: float

func get_value() -> float:
	return _value

func set_value(value: float):
	if _value != value:
		_value = value
		emit_changed()
