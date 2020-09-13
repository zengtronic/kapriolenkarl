extends StaticBody

var speed = 1

func _process(delta):
	rotate_y(delta * speed)
	pass

