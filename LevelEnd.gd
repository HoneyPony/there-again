extends Area2D

onready var player = get_node("../Player")

func _on_LevelEnd_body_entered(body):
	if body == player:
		Global.load_next_level(get_parent())
		queue_free()
