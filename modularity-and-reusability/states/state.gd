@abstract extends Node
class_name State

signal transition(next_state_path: String, data: Dictionary)

var host: Character = null

func enter(previous_state_path: String, data := {}) -> void:
	pass #enter new state
func exit() -> void:
	pass #exit this state
func update(_delta: float) -> void:
	pass #update
func physics_update(_delta: float) -> void:
	pass #physics update
func handle_input(_action: String, _event: Variant) -> void:
	pass #handle input
