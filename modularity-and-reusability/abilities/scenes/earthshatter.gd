extends Ability

func _hit(_body: HitboxComponent) -> void:
	if _body.health_component:
		_body.health_component.damage(value)
	
	if _body.host:
		_body.host.velocity.y += 10;
