extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("message_fade_in")
	if Globals.curr_level == 1:
		$Control2/Button20.modulate.a = 1.0
		$Control2/Button21.modulate.a = 0.2
		$Control2/Button22.modulate.a = 0.2
	elif Globals.curr_level == 2:
		$Control2/Button20.modulate.a = 0.2
		$Control2/Button21.modulate.a = 1.0
		$Control2/Button22.modulate.a = 0.2
	else:
		$Control2/Button20.modulate.a = 0.2
		$Control2/Button21.modulate.a = 0.2
		$Control2/Button22.modulate.a = 1.0
		


func _on_button_1_pressed():
	if Globals.curr_level == 1:
		get_tree().change_scene_to_file("res://level_1.tscn")



func _on_button_2_pressed():
	if Globals.curr_level == 2:
		get_tree().change_scene_to_file("res://level_2.tscn")


func _on_button_3_pressed():
	if Globals.curr_level == 3:
		get_tree().change_scene_to_file("res://level_3.tscn")



func _on_button_5_pressed():
	get_tree().quit()
