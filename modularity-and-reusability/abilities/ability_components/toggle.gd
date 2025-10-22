extends Resource
class_name Toggle

signal toggle

func _init(_callable: Callable):
	self.connect("toggle", _callable)
