extends Spatial

var player_info = null
export var hammer_path: NodePath
var hammer
var ready = false

func _ready():
	hammer = get_node(hammer_path)


func init(info):
	player_info = info
	name = str(info.id) + info.name
	if info.is_local:
		get_node("Camera").make_current()
	ready = true	
 

remotesync func override(pos):
	hammer.translation = pos


func _unhandled_input(event):
	if !ready: return
	if event is InputEventMouseMotion and player_info.is_local:
		var posy = -(event.position / get_viewport().size).y
		posy = posy * 7 + 3
		posy = clamp(posy, -0.8, 0.2)
		var dir = Vector3(hammer.translation.x, posy, hammer.translation.z)
		rpc_unreliable("override", dir)
