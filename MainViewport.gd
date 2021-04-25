extends Viewport

func _process(delta):
	var aspect_min = 240.0 / 150
	var aspect_center = 256.0 / 150
	var aspect_max = 256.0 / 140
	
	aspect_min = aspect_center
	aspect_max = aspect_center
	
	var parent = get_parent().get_viewport().get_size()
	var me = parent
	#print(parent)
	#size = parent / 4
	if parent.y > 0:
		var aspect = parent.x / parent.y
		#print(aspect)
		aspect = clamp(aspect, aspect_min, aspect_max)
		if aspect >= aspect_center:
			size.y = 256 / aspect
			size.x = 256
			
			me.x = me.y * aspect
			
		else:
			size.y = 150
			size.x = aspect * 150
			
			me.y = me.x / aspect
			
	var s = get_parent().material
	s.set_shader_param("my_x", parent.x)
	s.set_shader_param("my_y", parent.y)
	s.set_shader_param("tex_x", me.x)
	s.set_shader_param("tex_y", me.y)		
	


func _on_TextureButton_pressed():
	Global.level_id = -1
	Global.load_next_level($PsuedoRoot, false)
	
	get_node("../Menu").hide()
