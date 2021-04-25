extends Area2D

var last_enter_time = 0

func _ready():
	Global.connect("lever_is_true", $AnimationPlayer, "play", ["BecomeTrue"])
	Global.connect("lever_is_false", $AnimationPlayer, "play", ["BecomeFalse"])

#func _process(delta):
#	last_enter_time = max(last_enter_time - delta, 0)

	

func _on_Lever_body_entered(body):
	#if last_enter_time > 0:
	#	return
	#	
	#last_enter_time = 0.4
	Global.invert_lever_state()

