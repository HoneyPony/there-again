extends CanvasLayer

var next_callback = null

func _ready():
	Global.scene_transition = self

func _process(delta):
	var size = get_viewport().size
	
	$SceneToScene.region_rect.size = size
	$Lost.region_rect.size = size

func fade_out(callback, lost=false):
	$SceneToScene.visible = not lost
	$Lost.visible = lost
	
	$AnimationPlayer.queue("FadeOut")
	next_callback = callback
	
	
	
func fade_in():
	$AnimationPlayer.queue("FadeIn")

func reached_fade():
	if next_callback != null:
		next_callback.call_func()
