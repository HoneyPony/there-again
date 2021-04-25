extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO

export var the_flag = false

export var gravity = 650
export var total_jump_imp = 260# 216
export var max_h = 110
export var h_accel = 400
export var max_v = 150

onready var camera = get_node("../Camera2D")

var held_item = null

var has_double_jump = true

func _ready():
	$SquishDown
	Global.player = self
	
	if the_flag:
		$Sprite.hide()
		$Sprite2.show()
		
	Global.fade_music()

func get_input():
	var input = 0
	if Input.is_action_pressed("player_left"):
		input = -1
	elif Input.is_action_pressed("player_right"):
		input = 1
		
	return input
	
var facing_sign = 1

var remaining_jump_impulse = 0
var jump_chunk = 0

var is_dead = false

onready var spring_col = get_node("SpringDetect/Col")

var JumpPuff = preload("res://JumpPuff.tscn")
var StepPuff1 = preload("res://StepPuff1.tscn")
var StepPuff2 = preload("res://StepPuff2.tscn")
var StepPuff3 = preload("res://StepPuff3.tscn")
var StepPuff4 = preload("res://StepPuff4.tscn")

func get_step_puff():
	var puffs = [StepPuff1, StepPuff2, StepPuff3, StepPuff4]
	puffs.shuffle()
	var p = puffs[0].instance()
	return p
	
func puffpos(node):
	var x = node.position.x
	if facing_sign < 0:
		x = -x
		
	return global_position + Vector2(x, node.position.y)

func stepfx1():
	var p = get_step_puff()
	p.position = puffpos($StepLoc1)
	p.get_node("Sprite").flip_h = randf() < 0.5
	get_parent().add_child(p)
	
func stepfx2():
	var p = get_step_puff()
	p.position = puffpos($StepLoc2)
	p.get_node("Sprite").flip_h = randf() < 0.5
	get_parent().add_child(p)

func begin_control_jump(amount = 0):
	if amount == 0:
		amount = total_jump_imp
	remaining_jump_impulse = amount
	jump_chunk = amount * 0.12
	velocity.y = 0
	
	var puff = JumpPuff.instance()
	puff.position = position
	puff.get_node("Sprite").flip_h = randf() < 0.5
	get_parent().add_child(puff)
	#$JumpPuff.play("Puff")
	
func make_dead():
	if is_dead:
		return
	
	is_dead = true
	Global.reload_level(get_parent())

var coyote_time = 0

func _physics_process(delta):
	if is_dead:
		return
		
	coyote_time = max(coyote_time - delta, -0.1)
		
	spring_col.disabled = velocity.y < 0
	
	if Input.is_key_pressed(KEY_0):
		make_dead()
	
	var x_in = get_input()
	if x_in == 0:
		var accel = sign(velocity.x) * -h_accel
		var s = sign(velocity.x)
		velocity.x += accel * delta
		if s != sign(velocity.x):
			velocity.x = 0
	else:
		var accel = h_accel
		if sign(x_in) != sign(velocity.x) and velocity.x != 0:
			accel *= 2
		velocity.x += x_in * accel * delta
		velocity.x = clamp(velocity.x, -max_h, max_h)
		
	var snap = Vector2(0, 4)
	if velocity.y < -150:
		snap = Vector2.ZERO
		
	if is_on_floor():
		coyote_time = 0.03
		
	if coyote_time > 0:
		if Input.is_action_just_pressed("player_jump"):
			begin_control_jump()
			#velocity.y = -total_jump_imp
			snap = Vector2.ZERO
		has_double_jump = true	
	elif the_flag:
		if has_double_jump:
			if Input.is_action_just_pressed("player_jump"):
				begin_control_jump()
				has_double_jump = false
				
	if not Input.is_action_pressed("player_jump"):
		remaining_jump_impulse = 0
				
	if remaining_jump_impulse > 0:
		var vel = min(remaining_jump_impulse, jump_chunk)
		remaining_jump_impulse -= vel
		velocity.y -= vel
		#jump_chunk = max(jump_chunk - 10, 20)
		
	
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_v)
	
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	
	if abs(velocity.x) > 3:
		$Sprite.flip_h = velocity.x < 0
		
		$Sprite2.flip_h = velocity.x < 0
		
		facing_sign = sign(velocity.x)
		
	$Throw.position = Vector2(facing_sign * 7, -9)
	$Throw.flip_h = facing_sign < 0
		
	if not is_on_floor():
		if velocity.y < 0:
			$AnimationPlayer.play("Up")
		else:
			$AnimationPlayer.play("Down")
	elif abs(velocity.x) > 3:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Still")
		
	if held_item == null:
		if Input.is_action_pressed("player_grab"):
			var bodies = $Hold.get_overlapping_bodies()
			for b in bodies:
				if b.state == 0 and b.idle_time > 0.2:
					held_item = b
					b.state = 1
					
					#held_item.get_parent().remove_child(held_item)
					#add_child(held_item)
					#held_item.position = Vector2(facing_sign * 4, -8)
					break
	else:
		held_item.position = position.round() + Vector2(facing_sign * 4, -8)
		
		if Input.is_action_just_released("player_grab"):
			$ThrowAnim.play("Throw")
			
			#remove_child(held_item)
			#get_parent().add_child(held_item)
			#held_item.position = position + Vector2(facing_sign * 4, -8)
			
			held_item.state = 2
			held_item.velocity.x = held_item.max_h * facing_sign
			held_item = null
			
	camera.update_camera(position)
#	for b in $Bounce.get_overlapping_bodies():
#		if _on_Bounce_body_entered(b):
#			break
	var db = $SquishDown.get_overlapping_bodies()
	var ub = $SquishDown.get_overlapping_bodies()
	db.erase(self)
	ub.erase(self)
	
	if not db.empty() and not ub.empty():
		make_dead()

func _on_Bounce_body_entered(area):
	var body = area.get_parent()
	if body.state == 2 and body.move_time > 0.1:
		body.state = 0
		body.velocity.x = 0
		velocity.y = -217 #-216
		#has_double_jump = true
#		return true
		
#	return false


func _on_Hazard_body_entered(body):
	make_dead()
