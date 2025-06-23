extends Control

var MaxChildren = 32

#@onready var DNumsCont = get_node("DNumsContainer")
@onready var DNumsCont = self
var DDLScene = load("res://Scenes/UIElements/damage_dealt_label.tscn")

func _ready():
	SignalBus.AnnounceDamage.connect(Announce)

#func _process(delta):
	#if Input.is_action_just_pressed("DEBUG"):
		#AddLabel(randf())

func AddLabel(text,Pos):
	if DNumsCont.get_child_count() >= MaxChildren:
		for i in (DNumsCont.get_child_count()-MaxChildren):
			DNumsCont.get_child(0+i).queue_free()
	var DDLInst = DDLScene.instantiate()
	DDLInst.text = str(text)
	for i in DNumsCont.get_children():
		if i.global_position == Pos:
			Pos.y += DDLInst.size.y+2
	DDLInst.global_position = Pos + Vector2(-DDLInst.size.x/2,0)
	DNumsCont.add_child(DDLInst)

func Announce(text,Pos):
	AddLabel(text,Pos)
