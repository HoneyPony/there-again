tool
extends TileSet

func a_mod(a, b):
	#a = a + rand_range(0, b)
	var f = fmod(a, b)
	if a < 0:
		return f + b - 1
	return f
	
func amod(a, b):
	var r = a + int(rand_range(0, b - 0.01))
	return a_mod(r, b)

func helper(tilemap, loc, id):
	var u = tilemap.get_cellv(loc + Vector2(0, -1)) == id
	var d = tilemap.get_cellv(loc + Vector2(0, 1)) == id
	var l = tilemap.get_cellv(loc + Vector2(-1, 0)) == id
	var r = tilemap.get_cellv(loc + Vector2(1, 0)) == id
	var ul = tilemap.get_cellv(loc + Vector2(-1, -1)) == id
	var dl = tilemap.get_cellv(loc + Vector2(-1, 1)) == id
	var ur = tilemap.get_cellv(loc + Vector2(1, -1)) == id
	var dr = tilemap.get_cellv(loc + Vector2(1, 1)) == id
	
	
	if d and l and r and u:
		var u2 = tilemap.get_cellv(loc + Vector2(0, -2)) == id
		var d2 = tilemap.get_cellv(loc + Vector2(0, 2)) == id
		var l2 = tilemap.get_cellv(loc + Vector2(-2, 0)) == id
		var r2 = tilemap.get_cellv(loc + Vector2(2, 0)) == id
		
		if not ul:
			return Vector2(3, 2)
		if not ur:
			return Vector2(4, 2)
		if not dl:
			return Vector2(3, 3)
		if not dr:
			return Vector2(4, 3)
		
		if u2 and d2 and l2 and r2:
			return Vector2(2, 2)
			
		if d2 and l2 and r2:
			return Vector2(2 + amod(loc.x, 4), 1)
		
		if u2 and l2 and r2:
			return Vector2(2 + amod(loc.x, 4), 6)
			
		if r2 and u2 and d2:
			return Vector2(1, 2 + amod(loc.y, 4))	
		
		if l2 and u2 and d2:
			return Vector2(6, 2 + amod(loc.y, 4))	
		
		if d2 and r2:
			return Vector2(1, 1)
		if d2 and l2:
			return Vector2(6, 1)
		if u2 and r2:
			return Vector2(1, 6)
		if u2 and l2:
			return Vector2(6, 6)
		
		return Vector2(2, 2)
	
	if d and l and r and not u:
		return Vector2(1 + amod(loc.x, 6), 0)
		
	if u and l and r and not d:
		return Vector2(1 + amod(loc.x, 6), 7)
		
	if r and u and d and not l:
		return Vector2(0, 1 + amod(loc.y, 6))
		
	if l and u and d and not r:
		return Vector2(7, 1 + amod(loc.y, 6))
		
	if d and r:
		return Vector2(0, 0)
		
	if d and l:
		return Vector2(7, 0)
		
	if u and r:
		return Vector2(0, 7)
		
	if u and l:
		return Vector2(7, 7)
		
	return Vector2(2, 2)
	
func bridge(tilemap, tile_location):
	return Vector2(int(rand_range(0, 4-0.01)), 0)

func _forward_subtile_selection(autotile_id, bitmask, tilemap_, tile_location):	
	var tilemap: TileMap = tilemap_
	
	if autotile_id == 1:
		return helper(tilemap, tile_location, 1)
		
	if autotile_id == 3:
		return bridge(tilemap, tile_location)
		
	return Vector2.ZERO
	
#	var phys: TileMap = tilemap.get_node("../Physics")
#	var spikes: TileMap = tilemap.get_node("../Spikes")
#	if autotile_id == ERASER_ID:
#		tilemap.call_deferred("set_cellv", tile_location, -1)
#		phys.set_cellv(tile_location, -1)
#		spikes.set_cellv(tile_location, -1)
#	else:
#		if autotile_id == 2 or autotile_id == 4:
#			spikes.set_cellv(tile_location, 0)
#			phys.set_cellv(tile_location, -1)
#		elif autotile_id == 3:
#			phys.set_cellv(tile_location, 1)
#			spikes.set_cellv(tile_location, -1)
#		else:
#			phys.set_cellv(tile_location, 0)
#			spikes.set_cellv(tile_location, -1)

	
