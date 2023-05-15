extends Area2D

# we can be either a blank object or a key
enum type {BLANK, KEY, OPENED, END}

@export 
var mytype = type.KEY # set the type of this interact object in the editor


func _on_body_entered(body):
	if body.get_name() == "Player":
		if self.mytype != type.OPENED:
			var playerui = $".."/CanvasLayer/PlayerUI.show_interact()
			$".."/Player.curr_interact_area = self


func _on_body_exited(body):
	if body.get_name() == "Player":
		$".."/CanvasLayer/PlayerUI.hide_interact()
		$".."/Player.curr_interact_area = null
		
	
