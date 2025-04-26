extends Area2D

signal coin_collected

func _ready():
	body_entered.connect(_on_body_entered)
	add_to_group("coins")

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("coin_collected")
		queue_free()
