extends Node

@onready var EnemyArr = [Wolf]

func _ready():
	for i in EnemyArr:
		i.ID = EnemyArr.find(i)
	pass

func GetEnemy(ID:int)->Enemy:
	return EnemyArr[ID]

func GetEnemyNew(ID:int)->Enemy:
	var Base = EnemyArr[ID]
	var Abba = Enemy.new(
		Base.Name,
		Base.Sprites,
		Base.MaxPhysicalHealth,
		Base.MaxMentalHealth,
		Base.PhysicalStrength,
		Base.MentalStrength,
		Base.Defence,
		Base.Skills,
		Base.AI
		)
	return Abba

#RollSkill
#ActionBuffer   0 - Rolled Skill, 1 - targets

var Wolf = Enemy.new(
	"Wolf",
	[load("res://Assets/Textures/Sprites_battle/Enemy/NormalWolf.png")],
	500.0,100.0,
	10.0,5.0,
	1.0,
	[0,0],
	func (turn,oppons):
		var ActionBuffer = [0,0,0]
		if oppons>0:
			var ROpp = randi() % oppons
			ActionBuffer[2] = ROpp
		if turn%3 == 0:
			ActionBuffer[0] = Wolf.Skills[0]
		else:
			ActionBuffer[0] = Wolf.Skills[randi() % Wolf.Skills.size()]
		
		return ActionBuffer
)
