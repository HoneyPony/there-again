extends Camera2D

export var min_x = 0
export var max_x = 0

export var min_y = 0
export var max_y = 0

export var init_x = 0
export var init_y = 0

func _ready():
	position = Vector2(init_x, init_y)

func update_camera(pos):
	var last_position = position
	
	if pos.x > position.x:
		if pos.x < max_x:
			position.x = pos.x
			
	if pos.x < position.x:
		if pos.x > min_x:
			position.x = pos.x
			
	if pos.y > position.y:
		if pos.y < max_y:
			position.y = pos.y
			
	if pos.y < position.y:
		if pos.y > min_y:
			position.y = pos.y
			
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
	
	last_position += (position - last_position) * 0.2
	position = last_position
			
	position = position.round()
	pass
