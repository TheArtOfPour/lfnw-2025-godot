extends Area2D

signal coin_collected

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Body entered: ", body.name)
	if body.is_in_group("player"):
		print("Player detected!")
		emit_signal("coin_collected")
		queue_free()
