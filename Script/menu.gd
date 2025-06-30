extends Control

var MenuActive = false

@onready var Profs = get_node("MarginContainer/MarginContainer/ProfilesContainer")

func _ready():
	#visible = false
	GenMenuProfiles()
	UpdateMenuStats()

func _process(delta):
	if Input.is_action_just_pressed("back") and !Globals.InDialogue:
		UpdateMenuStats()
		MenuActive = !MenuActive
		visible = MenuActive
		get_tree().paused = MenuActive

func GenMenuProfiles():
	for i in PartyInfo.MainParty.size()-1:
		var ProfDup = Profs.get_node("CharacterSlot").duplicate()
		Profs.add_child(ProfDup)

func UpdateMenuStats():
	var ProfChildren = Profs.get_children()
	for i in ProfChildren.size():
		var CharInfo = ProfChildren[i].get_node("MC/CharacterInfo")
		CharInfo.get_node("CharIcon").texture = PartyInfo.MainParty[i].Icon
		CharInfo.get_node("Name").text = str(PartyInfo.MainParty[i].Name)
		CharInfo.get_node("HealthCont/HealthVals/Phys").text = "Physical: " + str(PartyInfo.MainParty[i].PhysicalHealth) + "/" + str(PartyInfo.MainParty[i].MaxPhysicalHealth)
		CharInfo.get_node("HealthCont/HealthVals/Ment").text = "Mental: " + str(PartyInfo.MainParty[i].MentalHealth) + "/" + str(PartyInfo.MainParty[i].MaxMentalHealth)
