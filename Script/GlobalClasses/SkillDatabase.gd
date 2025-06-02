extends Node

@onready var ArraySkills = [Skill_Attack,Skill_Defend,Skill_FastAttack]

func GetSkill(ID:int)->Skill:
	return ArraySkills[ID] if ID < ArraySkills.size() else Err

var Err = Skill.new(
	"TissueSlap",
	"This is an error! sorry!",
	load("res://Assets/Textures/Environment/bush2.png"),
	Enums.TSkill.Damage,
	[100,0]
)

var Skill_Attack = Skill.new(
	"Attack",
	"Deal damage to your opponent",
	load("res://Assets/Textures/Environment/bush2.png"),
	Enums.TSkill.Damage,
	[500,0]
)
var Skill_Defend = Skill.new(
	"Defend",
	"Reduce incoming damage",
	load("res://Assets/Textures/Environment/bush2.png"),
	Enums.TSkill.Damage,
	[100,0]
)
var Skill_FastAttack = Skill.new(
	"FastAttack",
	"Induces bleeding",
	load("res://Assets/Textures/Environment/bush2.png"),
	Enums.TSkill.Damage,
	[100,0]
)
