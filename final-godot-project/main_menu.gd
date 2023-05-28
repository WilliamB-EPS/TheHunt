extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("message_fade_in")


func _on_button_1_pressed():
	get_tree().change_scene_to_file("res://level_1.tscn")



func _on_button_2_pressed():
	pass # Replace with function body.


func _on_button_3_pressed():
	pass # Replace with function body.


func _on_button_4_pressed():
	pass # Replace with function body.


func _on_button_5_pressed():
	get_tree().quit()
