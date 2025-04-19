extends Node

const MAX_PARTY_SIZE = 4

@onready var MainParty = [CharDB.Char_Me] 

var Items = []

func AddPartyMember(Char:Character)->bool:
	if MainParty.size()<MAX_PARTY_SIZE:
		MainParty.append(Char)
		return true
	else:
		return false
