extends FloatEventBase

class_name FloatEvent

signal event_raised(arg: float)

func register(callback: Callable) -> void:
	event_raised.connect(callback)

func deregister(callback: Callable) -> void:
	event_raised.disconnect(callback)

func raise(arg: float) -> void:
	event_raised.emit(arg)
