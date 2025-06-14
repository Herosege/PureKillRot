extends Control

const NUM_COLUMNS_ITEMS = 4
const ITEMS_PER_PAGE = 8

@onready var ActionContainer = get_tree().get_first_node_in_group("ActionContainer")
@onready var ListItems = get_tree().get_first_node_in_group("ItemList")
@onready var MIArrow = get_tree().get_first_node_in_group("MoreItemsArrow")
@onready var PIArrow = get_tree().get_first_node_in_group("PrevItemsArrow")
@onready var EnemyList = get_tree().get_first_node_in_group("EnemyList")
@onready var CharProfs = get_tree().get_first_node_in_group("CharProfiles")
@onready var DPMessage = get_tree().get_first_node_in_group("DownPanelMessage")
#0-ActionMenu ; 1-ItemMenu ; 2-ProfileMenu
@onready var Cursor = get_tree().get_nodes_in_group("Cursor")

@onready var OverlayColor = get_node("Overlay/ColorRect")

@onready var ItemScene = load("res://Scenes/UIElements/item.tscn") 

#Action -> Select Item -> EnemySelect
var MenuLayer : int = 0 
var UiDir : Vector2 = Vector2.ZERO

var Turn = 0

#Elegancko
enum {ACTION_SKILL,ACTION_INFO,ACTION_ITEM,ACTION_SPECIAL}
enum {SELECT_ITEM,SELECT_PROFILE,SELECT_CHARACTER}
var MenuTypes = [
	[SELECT_ITEM,SELECT_CHARACTER],
	[SELECT_PROFILE],
	[SELECT_ITEM,SELECT_CHARACTER],
	[SELECT_ITEM]
	]

var FightParty = []
var CharacterTurn : int = 0
var YourTurn = true

var ProfilesArr = []

#SelectAction
var SelIndexAction : int = 0 

#SelectItem
var SelIndexItem : int = 0

#SelectCharacter
var SelIndexEnemy : int = 0 
var SelIndexProf : int = 0

#ItemSeletion
var TempItemList = []

var StartMessage : String

#Passed arguments
var BattleText = ""
var BattleEnemies = []

#ActionBuffer - [ID,type,target] - type   0:character 1:enemy
var ActionBuffer : Array

#DownTextbox
enum TBM {std_text,char_info}
var TextboxMode = TBM.std_text

var TextToSet = ""
var AwaitInptToEnd = 0

var HaltAction = false

func _enter_tree():
	$Overlay.visible = true

func _ready():
	#what the fuck is wrong with control nodes, fuck this I will just wait I don't care
	await get_tree().create_timer(0.05).timeout
	#
	BattleStart([0,0],BattleText)
	UpdateUi(0)
	GenProfiles()

func _process(delta):
	if AwaitInptToEnd and Input.is_action_just_pressed("accept"):
		ExitBattleScene(AwaitInptToEnd)
	if OverlayColor.color.a>0.0:
		OverlayColor.color.a = lerp(OverlayColor.color.a,0.0,1.5*delta)
	TextBoxHandle(delta)
	if !HaltAction:
		UiMovement()
		UiLayerHandle()

var CharProfile = load("res://Scenes/UIElements/char_profile.tscn")

func GenProfiles():
	for i in PartyInfo.MainParty.size():
		var CharPInst = CharProfile.instantiate()
		var CChar = PartyInfo.MainParty[i]
		CharPInst.SetImage(CChar.Icon)
		CharPInst.SetName(CChar.Name)
		CharPInst.SetHealth(CChar.PhysicalHealth,CChar.MentalHealth)
		CharProfs.add_child(CharPInst)

func BattleStart(Enemies : Array,Msg : String)->void:
	var EnemyScene = load("res://Scenes/UIElements/enemy.tscn")
	for i in Enemies.size():
		var EnemySceneInst = EnemyScene.instantiate()
		var EnemyFromID = EnemyDB.GetEnemyNew(Enemies[i])
		BattleEnemies.append(EnemyFromID)
		EnemySceneInst.ESprites = EnemyFromID.Sprites
		
		EnemyList.add_child(EnemySceneInst)
	StartMessage = Msg
	TextToSet = StartMessage

### MAIN UI HANDLE ------------------------------------------------------------------------------------------------------

func UiMovement()->void:
	UiDir.x = float(Input.is_action_just_pressed("move_right"))-float(Input.is_action_just_pressed("move_left"))
	UiDir.y = float(Input.is_action_just_pressed("move_down"))-float(Input.is_action_just_pressed("move_up"))
	if UiDir:
		if MenuLayer == 0:
			SelIndexAction += UiDir.y
			SelIndexAction = clamp(SelIndexAction,0,3)
			UpdateUi(MenuLayer)
		
		if MenuLayer > 0:
			match MenuTypes[SelIndexAction][MenuLayer-1]:
				SELECT_ITEM:
					ItemsMenuHandle()
				SELECT_PROFILE:
					if ProfilesArr:
						SelIndexProf += UiDir.x
						SelIndexProf = clamp(SelIndexProf,0,ProfilesArr.size()-1)
						UpdateUi(MenuLayer)
				SELECT_CHARACTER:
					if EnemyList.get_child_count() > 0:
						SelIndexEnemy += UiDir.x
						SelIndexEnemy = clamp(SelIndexEnemy,0,EnemyList.get_child_count()-1)
						UpdateUi(MenuLayer)

func UiLayerHandle()->void:
	if Input.is_action_just_pressed("accept") and CheckAction():
		if MenuLayer < MenuTypes[SelIndexAction].size() and Cursor.size() > MenuLayer: 
			AnimateCursor(true,MenuLayer)
		if MenuTypes[SelIndexAction].size() == MenuLayer:
			if !(SelIndexAction == SELECT_PROFILE):
				ActionBuffer.append([TempItemList[SelIndexItem],0,SelIndexEnemy])
				
				CharacterTurn += 1
				while PartyInfo.MainParty[min(CharacterTurn,PartyInfo.MainParty.size()-1)].Dead == true and !PartyInfo.MainParty.size()-1 <= CharacterTurn:
					CharacterTurn += 1
				ResetMenu()
				if PartyInfo.MainParty.size() <= CharacterTurn:
					CommitActions()
					CharacterTurn = 0
					ActionBuffer.resize(0)
		else:
			MenuLayer += 1
		if MenuTypes[SelIndexAction][MenuLayer-1] == SELECT_ITEM:
			CharProfs.visible = false
			GenerateItemList(PartyInfo.MainParty[CharacterTurn])
			ItemsMenuHandle()
		if MenuTypes[SelIndexAction][MenuLayer-1] == SELECT_PROFILE:
			CharProfs.visible = true
	
	if Input.is_action_just_pressed("back"):
		if MenuLayer > 0 and Cursor.size() > MenuLayer-1: 
			AnimateCursor(false,MenuLayer-1)
		
		ResetMenuLayer(MenuLayer)
		
		MenuLayer -= 1
		if MenuLayer == 0 and !CharProfs.visible:
			CharProfs.visible = true
	UpdateUi(MenuLayer)
	MenuLayer = clamp(MenuLayer,0,MenuTypes[SelIndexAction].size())

func UpdateUi(Layer:int)->void:
	if Layer == 0:
		Cursor[0].SetCursorFromIndex(SelIndexAction)
	if Layer > 0:
		match MenuTypes[SelIndexAction][Layer-1]:
			SELECT_ITEM:
				Cursor[1].SetCursorFromIndex(SelIndexItem%8)
			SELECT_PROFILE:
				Cursor[2].SetCursorFromIndex(SelIndexProf)
			SELECT_CHARACTER:
				var AnimSprite
				for i in EnemyList.get_children().size():
					AnimSprite = EnemyList.get_child(i).get_child(0)
					AnimSprite.material.set_shader_parameter("FlashOn",false)
				AnimSprite = EnemyList.get_child(SelIndexEnemy).get_child(0)
				AnimSprite.material.set_shader_parameter("FlashOn",true)

func UpdateProfiles():
	for i in CharProfs.get_children().size():
		CharProfs.get_child(i).SetHealth(PartyInfo.MainParty[i].PhysicalHealth,PartyInfo.MainParty[i].MentalHealth)

func ResetMenu():
	MenuLayer = 0
	
	ResetMenuLayer(-1)
	for i in Cursor.size():
		Cursor[i].AnimateCursor(false)
	
	SelIndexItem = 0
	SelIndexAction = 0

### ITEMS HANDLE ------------------------------------------------------------------------------------------------------

func UpdateItems()->void:
	ClearItems()
	for i in min(TempItemList.size(),ITEMS_PER_PAGE):
		if i+floor(SelIndexItem/ITEMS_PER_PAGE)*ITEMS_PER_PAGE > TempItemList.size()-1:
			break
		var IInst = ItemScene.instantiate()
		IInst.get_node("Label").text = str(SkillDB.ArraySkills[TempItemList[i+floor(SelIndexItem/ITEMS_PER_PAGE)*ITEMS_PER_PAGE]].Name)
		ListItems.add_child(IInst)
	#Arrow indicators
	if !(ceil(SelIndexItem/ITEMS_PER_PAGE)*ITEMS_PER_PAGE >= TempItemList.size()-8):
		MIArrow.visible = true
	else:
		MIArrow.visible = false
	
	if SelIndexItem >= 8:
		PIArrow.visible = true
	else:
		PIArrow.visible = false

func ClearItems():
	for i in ListItems.get_children():
		i.queue_free()

#0 Skills - 1 PlayerInfo - 2 Items - 3 Escape
func ItemsMenuHandle()->void:
	if ListItems.get_children().size() > 0:
		SelIndexItem += UiDir.x
		SelIndexItem += NUM_COLUMNS_ITEMS * UiDir.y
		SelIndexItem = clamp(SelIndexItem,0,TempItemList.size()-1)
	UpdateItems()
	await get_tree().process_frame
	UpdateUi(MenuLayer)
	await get_tree().process_frame
	if Cursor[1].visible == false:
		Cursor[1].visible = true

func GenerateItemList(Char:Character):
	TempItemList.resize(0)
	match SelIndexAction:
		ACTION_SKILL:
			for i in Char.Skills.size():
				TempItemList.append(Char.Skills[i])
		ACTION_ITEM:
			pass
		ACTION_SPECIAL:
			pass


func CheckAction()->bool:
	match SelIndexAction:
		ACTION_SKILL:
			return true if PartyInfo.MainParty[CharacterTurn].Skills else false
		ACTION_INFO:
			return true if PartyInfo.MainParty[CharacterTurn] else false
		ACTION_ITEM:
			return true if PartyInfo.Items else false
		ACTION_SPECIAL:
			return true if PartyInfo.MainParty[CharacterTurn].Special else false
	return false

### CURSOR ------------------------------------------------------------------------------------------------------

func AnimateCursor(SetAnim:bool,Layer:int):
	if Layer == 0:
		Cursor[0].AnimateCursor(SetAnim)
	if Layer > 0:
		match SelIndexAction:
			ACTION_SKILL:
				Cursor[1].AnimateCursor(SetAnim)
			ACTION_INFO:
				Cursor[2].AnimateCursor(SetAnim)
			ACTION_ITEM:
				Cursor[1].AnimateCursor(SetAnim)
			ACTION_SPECIAL:
				Cursor[1].AnimateCursor(SetAnim)

func ResetCursor(Layer):
	Cursor[Layer].global_position = Vector2.ZERO
	Cursor[Layer].size = Vector2.ZERO
	Cursor[Layer].pivot_offset = Vector2.ZERO

### ACTIONS ------------------------------------------------------------------------------------------------------

func CommitActions():
	GenEnemyActions()
	for i in ActionBuffer.size():
		if ActionBuffer[i][1] == 0:
			match SelIndexAction:
				ACTION_SKILL:
					SkillUse(ActionBuffer[i])
				ACTION_INFO:
					pass
				ACTION_ITEM:
					pass
				ACTION_SPECIAL:
					pass
		else:
			SkillUse(ActionBuffer[i])
	ResetMenu()

func GenEnemyActions():
	FightParty.resize(0)
	for i in PartyInfo.MainParty.size():
		if PartyInfo.MainParty[i].Dead == false:
			FightParty.append(PartyInfo.MainParty.find(PartyInfo.MainParty[i]))
	for i in BattleEnemies.size():
		var TempBuf = BattleEnemies[i].RSkill(Turn,FightParty.size())
		TempBuf[2] = FightParty[TempBuf[2]]
		ActionBuffer.append(TempBuf)

#-1 to Reset all layers
func ResetMenuLayer(Layer):
	if Layer > 0:
		match MenuTypes[SelIndexAction][Layer-1]:
			SELECT_ITEM:
				ClearItems()
				ResetCursor(1)
				Cursor[1].visible = false
				MIArrow.visible = false
				PIArrow.visible = false
				SelIndexItem = 0
			SELECT_PROFILE:
				ResetCursor(2)
			SELECT_CHARACTER:
				var AnimSprite
				for i in EnemyList.get_children().size():
					AnimSprite = EnemyList.get_child(i).get_child(0)
					AnimSprite.material.set_shader_parameter("FlashOn",false)
	if Layer == -1:
		#
		ClearItems()
		CharProfs.visible = true
		ResetCursor(1)
		Cursor[1].visible = false
		MIArrow.visible = false
		PIArrow.visible = false
		SelIndexItem = 0
		#
		ResetCursor(2)
		#
		var AnimSprite
		for i in EnemyList.get_children().size():
			AnimSprite = EnemyList.get_child(i).get_child(0)
			AnimSprite.material.set_shader_parameter("FlashOn",false)

func SkillUse(SkillT):
	var Effect = SkillDB.GetSkill(SkillT[0]).Effect
	var Vals = SkillDB.GetSkill(SkillT[0]).Values
	var TargetArray = BattleEnemies if SkillT[1] == 1 else PartyInfo.MainParty
	var TargetType = SkillT[2] 
	var EnemyType = TargetArray[TargetType]
	
	match Effect:
		Enums.TSkill.Damage:
			if EnemyType is Character:
				if FightParty.size() <= 0:
					BattleEnd(0)
					return
				if EnemyType.Dead == true:
					TargetType = FightParty[randi()%FightParty.size()]
					EnemyType = TargetArray[TargetType]
				EnemyType.TakeDamage(Vals[0])
				var EnemName = str(EnemyType.Name)
				SignalBus.emit_signal("AnnounceAction",EnemName + " took " + str(Vals[0]) + " Damage!")
				if EnemyType.PhysicalHealth <= 0:
					SignalBus.emit_signal("AnnounceAction",EnemName + " died")
					CharacterDie(TargetType)
					UpdateProfiles()
				if CheckPartyMembersDead():
					BattleEnd(0)
					return
			else:
				EnemyType.TakeDamage(Vals[0])
				var EnemName = str(EnemyType.Name) if TargetArray.size() <= 1 else str(EnemyType.Name) + "_" + str(TargetType+1)
				SignalBus.emit_signal("AnnounceAction",EnemName + " took " + str(Vals[0]) + " Damage!")
				if EnemyType.Health <= 0:
					SignalBus.emit_signal("AnnounceAction",EnemName + " died")
					EnemyDie(TargetType)
				if BattleEnemies.size() == 0:
					BattleEnd(1)

func CheckPartyMembersDead()->bool:
	var DeadAmnt = 0
	for i in PartyInfo.MainParty.size():
		if PartyInfo.MainParty[i].Dead == true:
			DeadAmnt+=1
			if DeadAmnt >= PartyInfo.MainParty.size():
				return true
	return false

### END STUFF ------------------------------------------------------------------------------------------------------

func EnemyDie(Index):
	BattleEnemies.remove_at(Index)
	EnemyList.get_child(Index).queue_free()

func CharacterDie(Index):
	FightParty.remove_at(FightParty.find(Index))
	PartyInfo.MainParty[Index].Dead = true
	CharProfs.get_child(Index).SetDead(true)

#0-lose   1-win
func BattleEnd(type):
	if type == 0:
		HaltAction = true
		TextToSet = "You lost"
		AwaitInptToEnd = 1
	else:
		HaltAction = true
		TextToSet = "You won!"
		AwaitInptToEnd = 2

func ExitBattleScene(type):
	SignalBus.emit_signal("EndBattle",type)
	queue_free()

### TEXTBOX ------------------------------------------------------------------------------------------------------

var NewTextSwitch = true
var PrevTTS = ""

func TextBoxHandle(delta):
	if !TextToSet.is_empty() and TextboxMode == TBM.std_text:
		if !PrevTTS.is_empty() and TextToSet != PrevTTS:
			NewTextSwitch = true
		PrevTTS = TextToSet
		if NewTextSwitch:
			DPMessage.text = ""
			NewTextSwitch = false
			Globals.TextTime = 0.0
			Globals.TextIndex = 0
			Globals.CharTime = Globals.TEXTSCROLLTIME
			Globals.LettersAtTime = 0.0
		var Char = Globals.ScrollText(TextToSet,delta)
		#print(Char,"abba")
		DPMessage.text += Char
		if Globals.CurText.is_empty():
			TextToSet = ""
			NewTextSwitch = true
