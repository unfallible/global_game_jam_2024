extends IntEventBase

class_name IntEvent

signal event_raised(arg: int)

func register(callback: Callable) -> void:
	event_raised.connect(callback)

func deregister(callback: Callable) -> void:
	event_raised.disconnect(callback)

func raise(arg: int) -> void:
	event_raised.emit(arg)
