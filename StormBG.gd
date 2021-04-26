extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed: float = 1

export var flag = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func amod(a, b):
	var f = fmod(a, b)
	if a < 0:
		return f + b - 1
	return f

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vis = true
	
	if Global.player != null:
		var f = Global.player.the_flag
		vis = flag == f
		
	$Sprite.visible = vis
	$Sprite2.visible = vis
	$Sprite3.visible = vis
	$Sprite4.visible = vis
	$Sprite5.visible = vis
	
	$Sprite.region_rect.position.x = amod($Sprite.region_rect.position.x + 3 * speed * delta, 512)
	$Sprite2.region_rect.position.x = amod($Sprite2.region_rect.position.x + -5 * speed * delta, 512)
	$Sprite3.region_rect.position.x = amod($Sprite3.region_rect.position.x + 8 * speed * delta, 512)
	$Sprite4.region_rect.position.x = amod($Sprite4.region_rect.position.x + -11 * speed * delta, 512)
