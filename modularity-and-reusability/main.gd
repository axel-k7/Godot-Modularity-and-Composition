extends Node3D

func _ready():
	GlobalGameStateManager.state = GameStateManager.GameState.GAMEPLAY
