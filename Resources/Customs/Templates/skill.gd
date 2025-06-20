extends Resource
class_name Skill

var Name : String
var Description : String
var Icon : CompressedTexture2D

var Effect : int
var Values : Array

var AnimSprites : Array
var AnimDuration : float

#func UseSkill()->bool:
	#if Effect:
		#Effect.call()
		#return true
	#else:
		#return false

func _init(a,b,c,d,e,f,g = 1.0):
	Name = a
	Description = b
	Icon = c
	Effect = d
	Values = e
	AnimSprites = f
	AnimDuration = g
