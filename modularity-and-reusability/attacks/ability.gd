@abstract extends Node3D
class_name Ability

var host: Character
signal finished

@abstract func _hit() -> void
@abstract func _enter() -> void
@abstract func _exit() -> void

func _ready() -> void:
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	_enter()
