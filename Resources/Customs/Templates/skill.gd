extends Resource
class_name Skill

var ID : int = -1

var Name : String
var Description : String
var Icon : CompressedTexture2D

var Effect 

var AnimSprites : Array
var AnimDuration : float

func UseSkill(Caster,Reciever):
	return Effect.call(Caster,Reciever)

func _init(a,b,c,d,e,f = 1.0):
	Name = a
	Description = b
	Icon = c
	AnimSprites = d
	Effect = e
	AnimDuration = f
