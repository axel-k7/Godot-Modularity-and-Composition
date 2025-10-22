extends Node
class_name GameStateManager

enum GameState {
	GAMEPLAY,
	MENU,
	PAUSED
}

signal game_state_changed(new_state: GameState)

#private, don't change through outside code
var _state: GameState = GameState.GAMEPLAY

#public, do GameStateManager.state = new_state
#mostly just playing around with setget vars
var state: GameState:
	get:
		return _state
	set(value):
		if value == _state:
			return
		_state = value
		emit_signal("game_state_changed", value)
