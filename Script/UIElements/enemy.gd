extends Control

var ESprites : Array

func _ready():
	for i in ESprites:
		$AnimatedSprite2D.sprite_frames.add_frame("default",i)
	if ESprites:
		custom_minimum_size = $AnimatedSprite2D.sprite_frames.get_frame_texture("default",0).get_size() * $AnimatedSprite2D.scale

func PlayFlashAnim():
	$AnimationPlayer.play("ShortFlash")

func PlayDamagedAnim():
	$AnimationPlayer.play("DamagedFlash")
