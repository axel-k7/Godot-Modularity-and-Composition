extends Task


@export var character: Character

func on_start() -> void:
	_running()
	
func run(_delta: float) -> void:
	character.velocity.y += 4*_delta
