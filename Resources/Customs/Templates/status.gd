extends Resource
class_name StatusEff

var Name : String

var Icon : CompressedTexture2D
var Effect 

#in turns
var Duration : int
var Stacks : int

func ActivateEffect():
	Effect.call()

func _init(a,b,c):
	Name = a
	Icon = b
	Effect = c
