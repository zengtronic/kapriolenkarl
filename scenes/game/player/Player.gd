extends Spatial

var HUD = preload("res://scenes/game/player/Hud/HUD.tscn")
var player_info = null
export var hammer_path: NodePath
var hammer
var ready = false
var pos_y = 0

func _ready():
	hammer = get_node(hammer_path)


func init(info):
	player_info = info
	name = str(info.id) + info.name
	if info.is_local:
		get_node("Camera").make_current()
		var hud = HUD.instance()
		hud.init(info)
		add_child(hud)
	ready = true
 

remotesync func override(y):
	pos_y = y


func _physics_process(delta):
	if player_info.is_local:
		if pos_y > 0:
			pos_y -= delta
			pos_y = clamp(pos_y, -1, 1)
			rpc_unreliable("override", pos_y)
	hammer.translation = Vector3(hammer.translation.x, pos_y, hammer.translation.z)

func hit():
	if pos_y <= 0:
		pos_y = 1
