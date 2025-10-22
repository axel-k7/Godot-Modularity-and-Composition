extends Aim
class_name CursorAim

func _aim_calculation(start_pos: Vector3) -> Vector3:
	var camera			= get_viewport().get_camera_3d()
	var mouse_pos 		= get_viewport().get_mouse_position()
	var ray_origin		= camera.project_ray_origin(mouse_pos)
	var ray_direction	= camera.project_ray_normal(mouse_pos)
	var ray_end			= ray_origin + ray_direction * 1000 #length
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true
	#query.collision_mask = constants.world_base_layer
	##so it only collides with world base
	
	var result = get_world_3d().direct_space_state.intersect_ray(query)
		
	if result.position == null:
		return Vector3.ZERO
	return result.position
