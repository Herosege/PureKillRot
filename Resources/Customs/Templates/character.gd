extends CreatureBase
class_name Character

var Name : String
var Icon : CompressedTexture2D

var Special = []
#Methods

func _init(aa,bb,a,b,c,d,e,Sk = []):
	Name = aa
	Icon = bb
	MaxPhysicalHealth = a
	MaxMentalHealth = b
	PhysicalStrength = c
	MentalStrength = d
	Defence = e
	Skills = Sk
	PhysicalHealth = MaxPhysicalHealth
	MentalHealth = MaxMentalHealth
