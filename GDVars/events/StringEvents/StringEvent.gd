extends StringEventBase

class_name StringEvent

signal event_raised(arg: String)

func register(callback: Callable) -> void:
	event_raised.connect(callback)

func deregister(callback: Callable) -> void:
	event_raised.disconnect(callback)

func raise(arg: String) -> void:
	event_raised.emit(arg)
