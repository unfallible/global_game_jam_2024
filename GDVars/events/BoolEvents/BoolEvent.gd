extends BoolEventBase

class_name  BoolEvent

signal event_raised(arg: bool)

func register(callback: Callable) -> void:
	event_raised.connect(callback)

func deregister(callback: Callable) -> void:
	event_raised.disconnect(callback)

func raise(arg: bool) -> void:
	event_raised.emit(arg)
