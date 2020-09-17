extends Control

func init(info):
	$PlayerName.text = info.name


func _ready():
	pass # Replace with function body.



func _on_Button_pressed():
	get_node("../.").hit()
