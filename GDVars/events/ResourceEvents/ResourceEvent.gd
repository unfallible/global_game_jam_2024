extends ResourceEventBase

class_name ResourceEvent

signal event_raised(arg: Resource)

func register(callback: Callable) -> void:
	event_raised.connect(callback)

func deregister(callback: Callable) -> void:
	event_raised.disconnect(callback)

func raise(arg: Resource) -> void:
	event_raised.emit(arg)
