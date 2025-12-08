extends CreatureBase
class_name Enemy

var Name : String
var Sprites : Array

var AI

func _init(aa,bb,a,b,c,d,e,Sk,gg):
	Name = aa
	Sprites = bb
	MaxPhysicalHealth = a
	MaxMentalHealth = b
	PhysicalStrength = c
	MentalStrength = d
	Defence = e
	Skills = Sk
	AI = gg
	PhysicalHealth = MaxPhysicalHealth
	MentalHealth = MaxMentalHealth


func RSkill(turn,oppons):
	return AI.call(turn,oppons)
