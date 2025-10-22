extends Node
class_name MovementComponent

@export var host: CharacterBody3D

@export var acceleration: float
@export var deceleration: float
@export var movement_multiplier: float
@export var base_movement_speed: float

var _local_dir: Vector3 = Vector3.ZERO

func jump():
	host.velocity.y += 10
