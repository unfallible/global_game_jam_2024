extends ResourceVar

class_name MutableResource

@export var _value: Resource

func get_value() -> Resource:
	return _value

func set_value(value: Resource):
	if _value != value:
		_value = value
		emit_changed()
