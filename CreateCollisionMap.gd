extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var gfx: TileMap = get_node("../TileMap")
	
	var bridge = get_node_or_null("Bridge")
	
	for tile in gfx.get_used_cells():
		var c = gfx.get_cellv(tile)
		if c == 3:
			if bridge != null:
				bridge.set_cellv(tile, 1)
		elif c != 2:
			set_cellv(tile, 0)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
