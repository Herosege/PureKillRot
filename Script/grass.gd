extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Sprite2D.frame = 1
func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		$Sprite2D.frame = 0
