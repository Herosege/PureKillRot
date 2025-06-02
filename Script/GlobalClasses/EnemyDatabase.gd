extends Node

@onready var EnemyArr = [Wolf]

func GetEnemy(ID:int)->Enemy:
	return EnemyArr[ID]

func GetEnemyNew(ID:int)->Enemy:
	var Base = EnemyArr[ID]
	var Abba = Enemy.new(
		Base.Name,
		Base.Sprites,
		Base.Health,
		Base.Skills,
		Base.AI
		)
	return Abba

var Wolf = Enemy.new(
	"Wolf",
	[load("res://Assets/Textures/Sprites_battle/Enemy/NormalWolf.png")],
	500.0,
	[0,0],
	func RollSkill(targets):
		var ActionBuffer = [0,0]
		
		
		return ActionBuffer
		pass
)
