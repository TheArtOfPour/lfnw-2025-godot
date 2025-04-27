extends Node2D

signal level_completed

var score = 0

func _ready():
	# Connect all coins' signals
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.connect("coin_collected", _on_coin_collected)
	
	update_score_display()

func _on_coin_collected():
	score += 1
	update_score_display()

func update_score_display():
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score)

func _on_goal_collected():
	pass
