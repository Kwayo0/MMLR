extends Control

var dif = false
@onready var il = $NewContOpt/ItemList

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if $Start.visible:
		if Input.is_action_just_pressed("start"):
			$Start.visible = false
			$NewContOpt.visible = true
	
	if $NewContOpt.visible:
		il.grab_focus()
		if il.is_selected(3):
			if dif:
				if Input.is_action_just_pressed("ui_left"):
					dif = false
					il.set_item_icon(3,load("res://assets/textures/Main Menu Resources/Normal Sel.png"))
			else:
				if Input.is_action_just_pressed("ui_right"):
					dif = true
					il.set_item_icon(3,load("res://assets/textures/Main Menu Resources/Hard Sel.png"))
				
	
	


func _on_item_list_item_selected(index: int) -> void:
	var pic0 = load("res://assets/textures/Main Menu Resources/New Game.png")
	var pic1 = load("res://assets/textures/Main Menu Resources/Continue.png")
	var pic2 = load("res://assets/textures/Main Menu Resources/Option.png")
	var pic3
	if dif:
		pic3 = load("res://assets/textures/Main Menu Resources/Hard.png")
	else:
		pic3 = load("res://assets/textures/Main Menu Resources/Normal.png")
	match index:
		0:
			il.set_item_icon(0,load("res://assets/textures/Main Menu Resources/New Game Sel.png"))
			il.set_item_icon(1,pic1)
			il.set_item_icon(2,pic2)
			il.set_item_icon(3,pic3)
		1: 
			il.set_item_icon(0,pic0)
			il.set_item_icon(1,load("res://assets/textures/Main Menu Resources/Continue Sel.png"))
			il.set_item_icon(2,pic2)
			il.set_item_icon(3,pic3)
		2:
			il.set_item_icon(0,pic0)
			il.set_item_icon(1,pic1)
			il.set_item_icon(2,load("res://assets/textures/Main Menu Resources/Option Sel.png"))
			il.set_item_icon(3,pic3)
		3:
			if dif:
				il.set_item_icon(0,pic0)
				il.set_item_icon(1,pic1)
				il.set_item_icon(2,pic2)
				il.set_item_icon(3,load("res://assets/textures/Main Menu Resources/Hard Sel.png"))
					
			else:
				il.set_item_icon(0,pic0)
				il.set_item_icon(1,pic1)
				il.set_item_icon(2,pic2)
				il.set_item_icon(3,load("res://assets/textures/Main Menu Resources/Normal Sel.png"))
				


func _on_item_list_item_activated(index: int) -> void:
	match index:
		0: #New Game
			$"Popup Menu".visible = true
			$"Popup Menu/ItemList".grab_focus()
			$NewContOpt.visible = false
		1: #Continue
			$"Popup Menu".visible = true
			$"Popup Menu/ItemList".grab_focus()
			$NewContOpt.visible = false
		
		
