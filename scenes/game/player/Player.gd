extends Spatial

var player_info = null

func _ready():
	pass # Replace with function body.


func init(info):
	player_info = info
	name = info.id

