@abstract extends Node3D
class_name Aim

@export var min_range: float = 0
@export var max_range: float = 10

#start pos is usually character position
@abstract func _aim_calculation(start_pos: Vector3) -> Vector3

func _set_distance(start: Vector3, end: Vector3) -> Vector3:
	var to_target = end - start
	var distance = clamp(to_target.length(), min_range, max_range)
	var direction = to_target.normalized()
	return distance * direction

#returns global position of aim target, can lock to direction
func get_aim(start_pos: Vector3, direction: Vector3 = Vector3.ZERO) -> Vector3:
	var result: Vector3 = _set_distance(start_pos, _aim_calculation(start_pos));
	if direction != Vector3.ZERO:
		result = result.dot(direction) * direction
	return start_pos + result
