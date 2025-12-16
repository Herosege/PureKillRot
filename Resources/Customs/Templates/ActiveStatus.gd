extends Resource
class_name ActiveStatus

var CStatus : int
var Duration : int 
var Stacks : int

func _init(a,b,c):
	CStatus = a
	Duration = b
	Stacks = c

func GetStatusStats():
	return StatusDB.GetStatusEff(CStatus)
