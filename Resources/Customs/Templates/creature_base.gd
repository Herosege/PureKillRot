extends Resource
class_name CreatureBase

var Dead = false

var MaxPhysicalHealth : int = 100
var MaxMentalHealth : int = 100

var PhysicalStrength : int = 10
var MentalStrength : int = 10
var Defence : int = 1

var PhysicalHealth : int = MaxPhysicalHealth :
	set(val):
		PhysicalHealth = clamp(val,0,MaxPhysicalHealth)
var MentalHealth : int = MaxMentalHealth:
	set(val):
		MentalHealth = clamp(val,0,MaxMentalHealth)

var StatusEffects : Array = [] 

var Skills = []

func AddEffect(EffectId:int,Duration:int,Stacks:int)->void:
	var FindEff = StatusEffects.find(EffectId)
	
	if FindEff>=0:
		if StatusEffects[FindEff].Duration < Duration:
			StatusEffects[FindEff].Duration = Duration
		StatusEffects[FindEff].Stacks += Stacks
		return
	StatusEffects.append(EffectId)

func RemoveEffect(EffectId:int)->void:
	var FindEff = StatusEffects.find(EffectId)
	if FindEff>=0:
		StatusEffects.remove_at(FindEff)

func TakeDamage(amnt):
	PhysicalHealth -= amnt
