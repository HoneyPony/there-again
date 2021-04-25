extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = 0

const STATE_IDLE = 0
const STATE_HELD = 1
const STATE_MOVE = 2

export var gravity = 650
export var max_h = 100
export var max_v = 150

var idle_time = 0
var move_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = max_h
	pass # Replace with function body.

var velocity = Vector2.ZERO

func _physics_process(delta):
	
	
	if state == STATE_IDLE:
		idle_time = min(idle_time + delta, 1.0)
	else:
		idle_time = 0
		
	if state == STATE_MOVE:
		move_time = min(move_time + delta, 1.0)
	else:
		move_time = 0
	
	if state == STATE_IDLE:
		set_collision_layer_bit(10, true)
		set_collision_mask_bit(10, true)
	else:
		set_collision_layer_bit(10, false)
		set_collision_mask_bit(10, false)
#
#	if state == STATE_MOVE:
#		set_collision_layer_bit(3, true)
#		set_collision_mask_bit(3, true)
#	else:
#		set_collision_layer_bit(3, false)
#		set_collision_mask_bit(3, false)
	
	if state == STATE_HELD:
		velocity = Vector2.ZERO
		return
	elif state == STATE_IDLE:
		velocity.x = 0
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_v)
		velocity = move_and_slide(velocity)
		$Sprite.global_position = global_position.round()
		return
	
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_v)
	
	var sgn = sign(velocity.x)
	velocity = move_and_slide_with_snap(velocity, Vector2(0, 4))
	
	for i in range(0, get_slide_count()):
		var c = get_slide_collision(i)
		if c.normal.dot(Vector2.LEFT) > 0.5 and sgn > 0:
			velocity.x = -max_h
			$Wall.play()
		if c.normal.dot(Vector2.RIGHT) > 0.5 and sgn < 0:
			velocity.x = max_h
			$Wall.play()
	
	var angle_vel = velocity.x / 4
	$Sprite.rotation += angle_vel * delta
	
	$Sprite.global_position = global_position.round()
	
