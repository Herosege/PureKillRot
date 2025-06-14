extends Node

const MAX_PARTY_SIZE = 4

@onready var MainParty = [CharDB.GetCharNew(0),CharDB.GetCharNew(1),CharDB.GetCharNew(2)] 

var Items = []

func AddPartyMember(Char:Character)->bool:
	if MainParty.size()<MAX_PARTY_SIZE:
		MainParty.append(Char)
		return true
	else:
		return false
