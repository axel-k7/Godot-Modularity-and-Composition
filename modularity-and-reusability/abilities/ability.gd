@abstract extends Node3D
class_name Ability

@export var value: float = 10.0

var host: Character
signal finished

@abstract func _hit(_body: HitboxComponent) -> void
@abstract func _enter() -> void
@abstract func _exit() -> void

func _init(_position: Vector3) -> void:
	pass

func _ready() -> void:
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	_enter()
