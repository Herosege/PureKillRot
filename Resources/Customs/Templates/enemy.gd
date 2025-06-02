extends Resource
class_name Enemy

var Name : String
var Sprites : Array

var Health : float
var Skills : Array

var AI

func TakeDamage(Amnt):
	Health -= Amnt

func _init(a,b,c,d,e):
	Name = a
	Sprites = b
	Health = c
	Skills = d
	AI = e
