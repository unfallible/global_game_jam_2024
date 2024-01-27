extends IntVar

class_name MutableInt

@export var _value: int

func get_value() -> int:
	return _value

func set_value(value: int):
	if _value != value:
		_value = value
		emit_changed()
	
