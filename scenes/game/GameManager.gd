extends Node

var Player = preload("res://scenes/game/player/Player.tscn")
var Level = preload("res://scenes/game/Level/Level.tscn")

# In 'Player.gd'
class_name Player

var players = []
var level = null

sync func start_game(player_info):
	var test = get_tree().get_root()
	if level:
		remove_child(level)
	
	for p in players:
		remove_child(p)
		p.queue_free()

	level = Level.instance()
	add_child(level)
	for i in player_info:
		var p: Player = Player.instance()
		p.init(i)
		players.append(p)
		add_child(p)
		
