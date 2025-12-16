extends Resource
class_name CreatureBase

var ID : int = -1

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

var StatusEffects = [] 

var Skills = []

func AddEffect(EffectId:int,Duration:int,Stacks:int)->void:
	var FindEff = -1
	for i in StatusEffects.size():
		if StatusEffects[i].ID == EffectId:
			FindEff = i
	
	if FindEff>=0:
		if StatusEffects[FindEff].Duration < Duration:
			StatusEffects[FindEff].Duration = Duration
		StatusEffects[FindEff].Stacks += Stacks
		return
	
	var NActivStatus = StatusDB.GetStatusEffNew(EffectId)
	StatusEffects.append(NActivStatus)

func RemoveEffect(EffectId:int)->void:
	var FindEff = -1
	for i in StatusEffects.size():
		if StatusEffects[i].ID == EffectId:
			FindEff = i
	if FindEff>=0:
		StatusEffects.remove_at(FindEff)

func TakeDamage(amnt):
	PhysicalHealth -= amnt
