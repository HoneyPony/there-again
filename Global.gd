extends Node

var scene_transition = null

var level_id = 0

var hint_death_count = 0

var levels = [
	preload("res://level/FirstLevel.tscn"),
	preload("res://level/FirstLevel2.tscn"),
	preload("res://level/SimplePlatforming.tscn"),
	preload("res://level/SimplePlatforming2.tscn"),
	preload("res://level/ThrowingTut.tscn"),
	preload("res://level/ThrowingTut2.tscn"),
	preload("res://level/LevelRockLeverTut.tscn"),
	preload("res://level/LevelRockLeverTut2.tscn"),
	preload("res://level/LevelPlatformsLeversOne.tscn"),
	preload("res://level/LevelPlatformsLeversTwo.tscn"),
	preload("res://level/SurfingTut.tscn"),
	preload("res://level/SurfingTut2.tscn"),
	preload("res://level/LevelRockSurf.tscn"),
	preload("res://level/LevelRockSurf2.tscn"),
	preload("res://level/RockJumpTut.tscn"),
	preload("res://level/RockJumpTut2.tscn"),
	preload("res://level/SurfingRockJump.tscn"),
	preload("res://level/SurfingRockJump2.tscn"),
	preload("res://level/DelayedRockJump.tscn"),
	preload("res://level/DelayedRockJump2.tscn"),
]

var load_root_node = null

var lever_state = false

signal lever_is_true
signal lever_is_false

var player = null
var kill_the_root = true

#func _ready():
	#call_deferred("reload_level", get_node("/root/Viewer/Viewport/Node2D"))

func load_next_level(root_node, kill_root = true):
	hint_death_count = 0
	lever_state = false
	level_id += 1
	
	load_root_node = root_node
	kill_the_root = kill_root
	
	scene_transition.fade_out(funcref(self, "load_trigger"))
	
	
	#get_tree().change_scene_to(levels[level_id])

func reload_level(root_node):
	kill_the_root = true
	lever_state = false
	load_root_node = root_node
	scene_transition.fade_out(funcref(self, "load_trigger"), true)

func load_trigger():
	if load_root_node == null:
		return
	
	var grandparent = load_root_node.get_parent()
	var new_scene = levels[level_id].instance()
	grandparent.add_child(new_scene)
	if kill_the_root:
		load_root_node.queue_free()
	
	scene_transition.fade_in()
	
	load_root_node = null
	lever_state = false
	hint_death_count += 1
	
var last_invert_time = 0

func _process(delta):
	last_invert_time = max(last_invert_time - delta, 0)
	
func invert_lever_state():
	if last_invert_time > 0:
		return
		
	last_invert_time = 0.5
	
	lever_state = !lever_state
	if lever_state:
		emit_signal("lever_is_true")
	else:
		emit_signal("lever_is_false")
