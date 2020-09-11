extends Spatial

var player_info = null

func _ready():
	pass # Replace with function body.


func init(info):
	player_info = info
	name = str(info.id) + info.name
	var id = get_tree().get_network_unique_id()
	if id == info.id:
		get_node("Camera").make_current()
