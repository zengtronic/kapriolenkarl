extends StaticBody

var speed = 2

func _process(delta):
	rotate_y(delta * speed)
	pass

