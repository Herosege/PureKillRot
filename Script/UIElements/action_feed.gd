extends Control

const MAX_CHILDREN = 8

@onready var AFCont = get_node("MarginContainer/VBoxContainer")
var AFLScene = load("res://Scenes/UIElements/action_feed_label.tscn")

func _ready():
	SignalBus.AnnounceAction.connect(Announce)

#func _process(delta):
	#if Input.is_action_just_pressed("DEBUG"):
		#AddLabel(randf())

func AddLabel(Info):
	if AFCont.get_child_count() >= MAX_CHILDREN:
		for i in (AFCont.get_child_count()-MAX_CHILDREN):
			AFCont.get_child(0+i).queue_free()
	var AFLInst = AFLScene.instantiate()
	AFLInst.text = str(Info)
	AFCont.add_child(AFLInst)

func Announce(text):
	AddLabel(text)
