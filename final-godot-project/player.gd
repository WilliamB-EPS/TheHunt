extends CharacterBody2D

enum State {IDLE, MOVE, INTERACT}

var curstate = State.IDLE
var speed = 4
var lastmovedir: Vector2 = Vector2.ZERO
var lastdir: Vector2 = Vector2.ZERO
var state_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("stand_down")
	

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
	move_and_collide(dir * speed)	
	lastdir = dir
	
	if dir.length() > 0:
		lastmovedir = dir
	
	# Switch to different states, based on our current state, and the input received
	if curstate == State.IDLE:
		if Input.is_action_just_pressed("ui_accept"):
			switch_to(State.INTERACT)
		elif dir.length() > 0:
			switch_to(State.MOVE)
	elif curstate == State.MOVE:
		if Input.is_action_just_pressed("ui_accept"):
			switch_to(State.INTERACT)
		elif dir.length() == 0:
			switch_to(State.IDLE)
	elif curstate == State.INTERACT:
		if Input.is_action_just_pressed("ui_accept"):
			switch_to(State.INTERACT)
		
	# Update which animation is playing if you are in the movement state so it matches with the 
	# player movement
	update_movement_animation()
	
	# Keep track of how long we spent in the current state so far
	state_time += delta

func _on_animated_sprite_2d_animation_finished():
	# Change states if needed once animations finish
	if curstate == State.INTERACT:
		if lastdir.length() > 0:
			switch_to(State.MOVE)
		else:
			switch_to(State.IDLE)