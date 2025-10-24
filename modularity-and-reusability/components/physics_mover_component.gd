extends Node
class_name PhysicsMoverComponent

@export var velocity_component: VelocityComponent
@export var host: Node3D

func _ready():
	if not velocity_component or not host:
		push_error("physics mover has no velocity component or host set")

func _physics_process(delta):
	var velocity: Vector3 = velocity_component.get_velocity()
	
	if host is CharacterBody3D:
		host.velocity = velocity
		host.move_and_slide()
	elif host is RigidBody3D:
		host.linear_velocity = velocity
	else:
		host.translation += velocity * delta
