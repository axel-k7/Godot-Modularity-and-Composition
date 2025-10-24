extends Node
class_name VelocityComponent

signal velocity_changed(new_velocity: Vector3)

@export var cap_speed: bool = false
@export var max_speed: float = 10.0

var velocity: Vector3 = Vector3.ZERO
var accelerations: Dictionary[String, Dictionary] = {}

func apply_acceleration(source: String, acceleration: Vector3, ignore_cap: bool = false) -> void:
	accelerations[source] = {
		"vector": acceleration,
		"ignore_cap": ignore_cap
	}

func apply_impulse(impulse: Vector3):
	velocity += impulse;
	emit_signal("velocity_changed", velocity)

func remove_acceleration(source: String) -> void:
	if accelerations.has(source):
		accelerations.erase(source)


func _physics_process(delta: float) -> void:
	if accelerations.size() == 0:
		if velocity == Vector3.ZERO:
			return
	
	var total_accel = Vector3.ZERO
	var bypass_cap = false	

	for data in accelerations.values():
		total_accel += data["vector"]
		if data.get("ignore_cap", false):
			bypass_cap = true	

	var prev_velocity = velocity
	velocity += total_accel * delta	
	var velocity_length = velocity.length()

	if cap_speed and not bypass_cap and velocity_length > max_speed:
		velocity = velocity.normalized() * max_speed	

	if velocity != prev_velocity:
		emit_signal("velocity_changed", velocity)


func get_velocity() -> Vector3:
	return velocity
