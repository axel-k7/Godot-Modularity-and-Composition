extends Node
class_name MovementComponent

func _jump(_params = []):
	self.velocity.y += 10

func _fall(_params = []):
	self.velocity.y -= 10
