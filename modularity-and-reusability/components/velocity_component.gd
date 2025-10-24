extends Node
class_name VelocityComponent

signal velocity_changed(new_velocity: Vector3)

@export var cap_speed: bool = false
@export var max_speed: float = 10.0

var velocity: Vector3 = Vector3.ZERO
var forces: Dictionary[String, Dictionary] = {}

func add_force(source: String, force: Vector3, ignore_cap: bool = false) -> void:
	forces[source] = {
		"vector": force,
		"ignore_cap": ignore_cap
	}

func remove_force(source: String) -> void:
	if forces.has(source):
		forces.erase(source)

func _physics_process(delta: float) -> void:
	var total_accel = Vector3.ZERO
	var bypass_cap = false	

	for data in forces.values():
		total_accel += data["vector"]
		if data.get("ignore_cap", false):
			bypass_cap = true	

	velocity += total_accel * delta	

	if cap_speed and not bypass_cap and velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed	

	if velocity.length() > 0 or total_accel != Vector3.ZERO:
		emit_signal("velocity_changed", velocity)


func get_velocity() -> Vector3:
	return velocity
