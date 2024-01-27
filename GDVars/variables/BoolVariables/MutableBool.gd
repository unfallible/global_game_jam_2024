extends BoolVar

class_name MutableBool

@export var _value: bool

func get_value() -> bool:
	return _value

func set_value(value: bool):
	if _value != value:
		_value = value
		emit_changed()
