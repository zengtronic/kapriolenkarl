extends Node

func _ready():
	# do the hosting for a headless version
	$lobby._on_host_pressed()
