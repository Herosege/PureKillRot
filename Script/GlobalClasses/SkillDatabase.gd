extends Node

@onready var ArraySkills = [Skill_Attack,Skill_Defend,Skill_FastAttack]

func GetSkill(ID:int)->Skill:
	return ArraySkills[ID] if ID < ArraySkills.size() else Err

var Err = Skill.new(
	"TissueSlap",
	"This is an error! sorry!",
	load("res://Assets/Sprites/npcs/someone.png"),
	func Eff():
		pass
)

var Skill_Attack = Skill.new(
	"Attack",
	"Deal damage to your opponent",
	load("res://Assets/Images/grass.png"),
	func Eff():
		print("77KrowaBuggati!!2")
)
var Skill_Defend = Skill.new(
	"Defend",
	"Reduce incoming damage",
	load("res://Assets/Sprites/npcs/someone.png"),
	func Eff():
		print("OBRONA!!!")
)
var Skill_FastAttack = Skill.new(
	"FastAttack",
	"Induces bleeding",
	load("res://Assets/Sprites/npcs/player1.png"),
	func Eff():
		print("wu//Assets/Sp")
)
