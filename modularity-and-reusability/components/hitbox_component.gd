extends Area3D
class_name HitboxComponent

@export var health_component: HealthComponent
@export var host: Character

func do_effect(_lambda: Callable, _args := {}):
	_lambda.call(_args)
