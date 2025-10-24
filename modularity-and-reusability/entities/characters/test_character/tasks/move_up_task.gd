extends Task

@export var character: Character

func run(_delta: float) -> void:
	print("move up task ran")
	character.movement_component.jump()
	_success()
