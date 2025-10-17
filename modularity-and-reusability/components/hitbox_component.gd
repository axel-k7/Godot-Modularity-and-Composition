extends Area3D
class_name HitboxComponent

@export var health_component: HealthComponent
@export var host: Character

func do_effect(_callable: Callable, _args := {}):
	_callable.call(_args)
