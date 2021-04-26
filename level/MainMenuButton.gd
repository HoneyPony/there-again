extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var goed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(0, 255):
		if Input.is_key_pressed(i):
			go()

func go():
	if goed:
		return
	goed = true
	Global.load_main(get_parent())
