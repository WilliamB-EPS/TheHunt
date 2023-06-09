extends CharacterBody2D

enum State {IDLE, MOVE, INTERACT}

var curstate = State.IDLE
var speed = 4
var lastmovedir: Vector2 = Vector2.ZERO
var lastdir: Vector2 = Vector2.ZERO
var state_time = 0.0
var curr_interact_area = null
var can_move = true
var is_hiding = false
var num_keys

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle_down")	

func switch_to(new_state: State):
	curstate = new_state
	state_time = 0.0
	
	if new_state == State.IDLE:	
		
		if lastmovedir.x > 0:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = false
		elif lastmovedir.x < 0:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = true
		elif lastmovedir.y > 0:
			$AnimatedSprite2D.play("idle_down")
			$AnimatedSprite2D.flip_h = false
		elif lastmovedir.y < 0:
			$AnimatedSprite2D.play("idle_up")
			$AnimatedSprite2D.flip_h = false 
	elif new_state == State.INTERACT:
		$AnimatedSprite2D.frame = 0
		if lastmovedir.x > 0:
			$AnimatedSprite2D.play("interact_right")
			$AnimatedSprite2D.flip_h = false
		elif lastmovedir.x < 0:
			$AnimatedSprite2D.play("interact_right")
			$AnimatedSprite2D.flip_h = true
		elif lastmovedir.y > 0:
			$AnimatedSprite2D.play("interact_down")
			$AnimatedSprite2D.flip_h = false
		elif lastmovedir.y < 0:
			$AnimatedSprite2D.play("interact_up")
			$AnimatedSprite2D.flip_h = false
	elif new_state == State.MOVE:
		update_movement_animation()

		
func update_movement_animation():
	if curstate == State.MOVE:
		if lastmovedir.x > 0:
			$AnimatedSprite2D.play("walk_right")
			$AnimatedSprite2D.flip_h = false
		elif lastmovedir.x < 0:
			$AnimatedSprite2D.play("walk_right")
			$AnimatedSprite2D.flip_h = true
		elif lastmovedir.y > 0:
			$AnimatedSprite2D.play("walk_down")
			$AnimatedSprite2D.flip_h = false
		elif lastmovedir.y < 0:
			$AnimatedSprite2D.play("walk_up")
			$AnimatedSprite2D.flip_h = false

func _physics_process(delta):	
	var dir = Vector2.ZERO
	
	# Setup a movement vector based on keyboard input
	if Input.is_action_pressed("moveup"):
		dir.y = -1
	elif Input.is_action_pressed("movedown"):
		dir.y = 1	
	elif Input.is_action_pressed("moveleft"):
		dir.x = -1	
	elif Input.is_action_pressed("moveright"):
		dir.x = 1		
		
	# Apply that movement and save the last vectors as part of our state so we can select which
	# animation to play layer
	if curstate != State.INTERACT and self.can_move == true: # don't move if interacting
		move_and_collide(dir * speed)	
		
	lastdir = dir
	
	if dir.length() > 0:
		lastmovedir = dir
	
	# Switch to different states, based on our current state, and the input received
	if curstate == State.IDLE:
		if self.curr_interact_area != null and Input.is_action_just_pressed("ui_accept"):
			switch_to(State.INTERACT)
		elif dir.length() > 0:
			switch_to(State.MOVE)
	elif curstate == State.MOVE:
		if dir.length() == 0:
			switch_to(State.IDLE)
		
	# Update which animation is playing if you are in the movement state so it matches with the 
	# player movement
	update_movement_animation()
	
	# Keep track of how long we spent in the current state so far
	state_time += delta

func _on_animated_sprite_2d_animation_finished():
	# Change states if needed once animations finish
	
	# interaction handler
	# checks what we're interacting with and how to proceed
	if curstate == State.INTERACT:
		
		if Globals.curr_level == 1:
			
			if self.curr_interact_area.mytype == self.curr_interact_area.type.END:	
				if self.num_keys >= 2:	
					$".."/CanvasLayer/PlayerUI.hide_interact()
					$".."/AnimationPlayer.play("shader_death")
					await $".."/AnimationPlayer.animation_finished
					$".."/CanvasLayer/PlayerUI.game_win()
					Globals.curr_level = 2
				else:
					await $".."/CanvasLayer/PlayerUI.reqs_message()	
			else:
				$".."/CanvasLayer/PlayerUI.hide_interact()
				if self.curr_interact_area.mytype == self.curr_interact_area.type.KEY:		
					self.num_keys += 1
					$".."/CanvasLayer/PlayerUI.set_num_keys(self.num_keys)
				elif self.curr_interact_area.mytype == self.curr_interact_area.type.BLANK:	
					$".."/CanvasLayer/PlayerUI.show_blank_message()	
				# stop player from opening this box again
				self.curr_interact_area.mytype = self.curr_interact_area.type.OPENED	
				self.curr_interact_area = null

		elif Globals.curr_level == 2:	
			if self.curr_interact_area.mytype == self.curr_interact_area.type.NPC:
				$".."/CanvasLayer/PlayerUI.npc_interact()
				self.curr_interact_area.mytype = self.curr_interact_area.type.OPENED
				self.curr_interact_area = null
			elif self.curr_interact_area.mytype == self.curr_interact_area.type.END:
				$".."/CanvasLayer/PlayerUI.game_win()
				Globals.curr_level = 3
		
		elif Globals.curr_level == 3:	
			if self.curr_interact_area.mytype == self.curr_interact_area.type.CLOSET:
				var alien1_attack = $".."/Alien1.curstate == $".."/Alien1.State.ATTACK
				var alien2_attack = $".."/Alien2.curstate == $".."/Alien2.State.ATTACK
				# we can only hide if we have keys and the aliens aren't attacking
				if self.num_keys >= 1 and !alien1_attack and !alien2_attack:
					$AnimatedSprite2D.visible = false
					$".."/CanvasLayer/PlayerUI.show_hide_UI()
					self.curr_interact_area = self.curr_interact_area.type.OPENED
					self.can_move = false
					self.curr_interact_area = null
					self.is_hiding = true
			elif self.curr_interact_area.mytype == self.curr_interact_area.type.END:
				$".."/CanvasLayer/PlayerUI.game_win()
				Globals.curr_level = 0
	
		if lastdir.length() > 0:
			switch_to(State.MOVE)
		else:
			switch_to(State.IDLE)

