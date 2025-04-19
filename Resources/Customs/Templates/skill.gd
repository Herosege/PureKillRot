extends Resource
class_name Skill

var Name : String
var Description : String
var Icon : CompressedTexture2D

var Effect

func UseSkill()->bool:
	if Effect:
		Effect.call()
		return true
	else:
		return false

func _init(a,b,c,d):
	Name = a
	Description = b
	Icon = c
	Effect = d
