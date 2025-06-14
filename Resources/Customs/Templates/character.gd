extends Resource
class_name Character

var Name : String
var Icon : CompressedTexture2D

#Stats

var Dead = false

var MaxPhysicalHealth : float = 100.0
var MaxMentalHealth : float = 100.0

var PhysicalStrength : float = 10.0
var MentalStrength : float = 10.0
var Defence : float = 1.0

#ActiveStats

var PhysicalHealth : float = MaxPhysicalHealth :
	set(val):
		PhysicalHealth = clamp(val,0.0,MaxPhysicalHealth)
var MentalHealth : float = MaxMentalHealth:
	set(val):
		MentalHealth = clamp(val,0.0,MaxMentalHealth)

var StatusEffects : Array[Array] = [[],[]]

var Skills = []
var Special = []
#Methods

#0 for physical 
#1 for mental
func AddEffect(Type:int,EffectId:int,Duration:int)->void:
	var FindEff = StatusEffects[Type].find(EffectId)
	
	if FindEff>=0:
		if StatusEffects[Type][FindEff] < Duration:
			StatusEffects[Type][FindEff] #add duration ref
		return
	StatusEffects[Type].append(EffectId)

func RemoveEffect(Type:int,EffectId:int)->void:
	var FindEff = StatusEffects[Type].find(EffectId)
	if FindEff>=0:
		StatusEffects[Type].remove_at(FindEff)
	return

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
