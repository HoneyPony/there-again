extends Node2D

export var move_param: float = 0.0
export var end_position: NodePath

var position_0: Vector2
var position_1: Vector2

func _ready():
	position_0 = global_position
	position_1 = get_node(end_position).global_position
	
	Global.connect("lever_is_true", $AnimationPlayer, "play", ["MoveTrue"])
	Global.connect("lever_is_false", $AnimationPlayer, "play", ["MoveFalse"])

func _physics_process(delta):

	global_position = position_0.linear_interpolate(position_1, move_param)

	#$Sprite.global_position = global_position.round()

#	var b = $PlayerMagnet.get_overlapping_bodies()
#	if Global.player in b:
#		Global.player.move_and_collide(Vector2(0, dy))
	
		
