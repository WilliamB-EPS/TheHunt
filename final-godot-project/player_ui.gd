extends Control


# Called when athe node enters the scene tree for the first time.
func _ready():
	call_deferred("actor_setup")
	
func actor_setup():
	await get_tree().physics_frame
	$".."/".."/Player.can_move = false
	$InteractContainer.visible = false
	$InteractBG.visible = false
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "There is an alien"
	await get_tree().create_timer(3).timeout
	$UpdateContainer/Label.text = "Reach the other side"
	await get_tree().create_timer(3).timeout
	$UpdateContainer/Label.text = "For this, find 2 keys"
	await get_tree().create_timer(3).timeout
	$UpdateBG.visible = false
	$UpdateContainer.visible = false
	$".."/".."/Player.can_move = true

func show_interact():
	$InteractContainer.visible = true
	$InteractBG.visible = true
	
func hide_interact():
	$InteractContainer.visible = false
	$InteractBG.visible = false
	
func set_num_keys(numkeys):
	$InventoryBG.visible = true
	$InventoryContainer.visible = true
	$InventoryContainer/Label.text = "Inventory: " + str(numkeys) + " keys"
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "You just found a key!"
	await get_tree().create_timer(1).timeout
	$UpdateBG.visible = false
	$UpdateContainer.visible = false
	
func show_blank_message():
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "Empty box - no keys"
	await get_tree().create_timer(1).timeout
	$UpdateBG.visible = false
	$UpdateContainer.visible = false

func lose_screen():
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "You died. Game over"
	
func game_win():
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "You won! Game over"
	
func reqs_message():
	hide_interact()
	$UpdateBG.visible = true
	$UpdateContainer.visible = true
	$UpdateContainer/Label.text = "Insufficent resources"
	await get_tree().create_timer(1).timeout
	show_interact()
	$UpdateBG.visible = false
	$UpdateContainer.visible = false
