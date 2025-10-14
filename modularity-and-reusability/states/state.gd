@abstract extends Node
class_name State

signal transition(next_state_path: String, data: Dictionary)

#could make abstract
func enter(previous_state_path: String, data := {}) -> void:
	pass #enter new state
func exit() -> void:
	pass #clean up old state
func update(_delta: float) -> void:
	pass #update
func physics_update(_delta: float) -> void:
	pass #physics update
func handle_input(_event: InputEvent) -> void:
	pass #handle input
