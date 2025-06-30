extends Resource
class_name Character

var Name : String
var Icon : CompressedTexture2D

#Stats

var Dead = false

var MaxPhysicalHealth : int = 100
var MaxMentalHealth : int = 100

var PhysicalStrength : int = 10
var MentalStrength : int = 10
var Defence : int = 1

#ActiveStats

var PhysicalHealth : int = MaxPhysicalHealth :
	set(val):
		PhysicalHealth = clamp(val,0,MaxPhysicalHealth)
var MentalHealth : int = MaxMentalHealth:
	set(val):
		MentalHealth = clamp(val,0,MaxMentalHealth)

var StatusEffects : Array = [] 

var Skills = []
var Special = []
#Methods

#0 for physical 
func AddEffect(EffectId:int,Duration:int,Stacks:int)->void:
	var FindEff = StatusEffects.find(EffectId)
	
	if FindEff>=0:
		if StatusEffects[FindEff] < Duration:
			StatusEffects[FindEff] #add duration ref
		return
	StatusEffects.append(EffectId)

func RemoveEffect(EffectId:int)->void:
	var FindEff = StatusEffects.find(EffectId)
	if FindEff>=0:
		StatusEffects.remove_at(FindEff)

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

func TakeDamage(amnt):
	PhysicalHealth -= amnt
