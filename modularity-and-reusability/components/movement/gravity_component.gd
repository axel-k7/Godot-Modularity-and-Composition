extends Node
class_name GravityComponent

const gravity: float = 9.8 #should not be defined here "constants.gd?"

@export var gravity_multiplier: float = 1.0
@export var velocity_component: VelocityComponent
@export var host: Character

func _physics_process(delta: float) -> void:
	if not host.is_on_floor():
		velocity_component.apply_acceleration("gravity", Vector3(0, -gravity*gravity_multiplier, 0))
	else:
		velocity_component.remove_acceleration("gravity")
		var current_velocity = velocity_component.get_velocity()
		if current_velocity.y < 0:
			velocity_component.apply_impulse(Vector3(0, -current_velocity.y, 0))
