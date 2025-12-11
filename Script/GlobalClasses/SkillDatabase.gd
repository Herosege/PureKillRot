extends Node

@onready var ArraySkills = [Skill_Attack,Skill_Defend,Skill_FastAttack]

func GetSkill(ID:int)->Skill:
	return ArraySkills[ID] if ID < ArraySkills.size() else Err

const BASE_SCALING := 0.02

var Err = Skill.new(
	"TissueSlap",
	"Fuck them up",
	load("res://Assets/Textures/Environment/bush2.png"),
	[load("res://Assets/Textures/Environment/bush2.png")],
	func(Caster,Reciever):
		var BDamage := 15.0
		var Damage = BDamage * (1 + (0.02 * Caster.PhysicalStrength))
		Reciever.TakeDamage(Damage)
		return [[Enums.TSkill.Damage],[Damage]]
)

var Skill_Attack = Skill.new(
	"Attack",
	"Deal damage to your opponent",
	load("res://Assets/Textures/Environment/bush2.png"),
	[
		load("res://Assets/Textures/Environment/bush2.png"),
		load("res://Assets/Textures/Sprites_normal/Characters/me1_d.png")
	],
	func(Caster,Reciever):
		var BDamage := 250.0
		var DamageScaling = 1.0
		var Damage = BDamage * (1 + (DamageScaling * BASE_SCALING * Caster.PhysicalStrength)) * (1 - (BASE_SCALING * Reciever.Defence))
		Reciever.TakeDamage(Damage)
		return [[Enums.TSkill.Damage],[Damage]]
)
var Skill_Defend = Skill.new(
	"Defend",
	"Reduce incoming damage",
	load("res://Assets/Textures/Environment/bush2.png"),
	[
		load("res://Assets/Textures/Environment/bush2.png"),
		load("res://Assets/Textures/Sprites_normal/Characters/me1_u.png"),
		load("res://Assets/Textures/Environment/bush2.png"),
		load("res://Assets/Textures/Sprites_normal/Characters/me1_u.png")
		
	],
	func(Caster,Reciever):
		var BDamage := 100.0
		var DamageScaling = 2.0
		var Damage = BDamage * (1 + (DamageScaling * BASE_SCALING * Caster.PhysicalStrength)) * (1 - (BASE_SCALING * Reciever.Defence))
		Reciever.TakeDamage(Damage)
		return [[Enums.TSkill.Damage],[Damage]]
)
var Skill_FastAttack = Skill.new(
	"FastAttack",
	"Induces bleeding",
	load("res://Assets/Textures/Environment/bush2.png"),
	[load("res://Assets/Textures/Sprites_normal/Characters/walk2_d.png")],
	func(Caster,Reciever):
		var BDamage := 500.0
		var DamageScaling = 0.5
		var Damage = BDamage * (1 + (DamageScaling * BASE_SCALING * Caster.PhysicalStrength)) * (1 - (BASE_SCALING * Reciever.Defence))
		Reciever.TakeDamage(Damage)
		return [[Enums.TSkill.Damage],[Damage]]
)
