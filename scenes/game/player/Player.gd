extends Spatial

var player_info = null
export var hammer_path: NodePath
var hammer: KinematicBody


func _ready():
	hammer = get_node(hammer_path)


func init(info):
	player_info = info
	name = str(info.id) + info.name
	var id = get_tree().get_network_unique_id()
	if id == info.id:
		get_node("Camera").make_current()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var scaled = event.position / get_viewport().size
		if event.button_mask & BUTTON_LEFT:
			var dir = Vector3(hammer.translation.x, scaled.y, hammer.translation.z)
			hammer.translation = dir
			#hammer.move_and_collide(dir)
