@abstract extends Ability
class_name AreaAbility

@export var host_bound = true


@export var area: Area3D

func _on_body_entered(_body: Node) -> void:
	if _body is HitboxComponent:
		_body.hitbox._hit(self)


##aimed stuff
