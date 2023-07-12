extends MarginContainer

@export var weapon_selected: Texture2D
@export var weapon_not_selected: Texture2D

func add_crossbow() -> void:
	$HBoxContainer/MarginContainer/VBoxContainer/crossbow_NinePatchRect.visible = true

func select_sword() -> void:
	$HBoxContainer/MarginContainer/VBoxContainer/crossbow_NinePatchRect.texture = weapon_not_selected
	$HBoxContainer/MarginContainer/VBoxContainer/sword_NinePatchRect.texture = weapon_selected
	
func select_crossbow() -> void:
	$HBoxContainer/MarginContainer/VBoxContainer/sword_NinePatchRect.texture = weapon_not_selected
	$HBoxContainer/MarginContainer/VBoxContainer/crossbow_NinePatchRect.texture = weapon_selected
