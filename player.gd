extends KinematicBody2D

signal hp_change

var bullet = preload("res://Bullet.tscn")

export (int) var speed = 100
export (int) var jump_speed = -100
export (int) var gravity = 200

export (float, 0, 1.0) var friction = 1.0
export (float, 0, 1.0) var acceleration = 0.25

export var x_difference = 0
var jump_pressed = false

var velocity = Vector2.ZERO
var jump_count = 0
var facing = Vector2.RIGHT

var hp = 100

func knock_back(pos):
	if $HitTimer.is_stopped():
		velocity = (pos-self.position).normalized() * -200
		$HitTimer.start(2)
		$Flasher.start(.05)
		
		
func hp_dmg(value):
	if $HitTimer.is_stopped():
		hp -= value
		$Hit.play()
		if hp < 0:
			$Death.play()
			get_tree().reload_current_scene()
		emit_signal("hp_change", self.hp)

func get_input():
	var dir = 0
	
	if Input.is_action_pressed("walk_right"):
		dir += 1
		
		for i in $Sprites.get_children():
			i.flip_h = false
		
		$Camera2D.offset_h = 1
		$AnimationPlayer.play("walk")
		$Sprites/Gun.position = $gunRight.position
		facing = Vector2.RIGHT
	if Input.is_action_pressed("walk_left"):
		dir -= 1
		
		
		for i in $Sprites.get_children():
			i.flip_h = true
			
		$Camera2D.offset_h = -1
		$AnimationPlayer.play("walk")
		
		$Sprites/Gun.position = $gunLeft.position
		facing = Vector2.LEFT
		
	if Input.is_action_pressed("shoot"):
		if $Timer.is_stopped():
			var newBullet = bullet.instance()
			newBullet.fire(self.position, facing)
			self.get_parent().add_child(newBullet)
			$Shoot.play()
			$Timer.start(0.15)
	
	if dir != 0:
		velocity.x = lerp(velocity.x, dir*speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			var tile_pos = collision.collider.world_to_map(self.position)
			tile_pos -= collision.normal
			
			var tile_id = collision.collider.get_cellv(tile_pos)
			
			print(tile_id)
#			if tile_id == 23:
#				self.hp_dmg(1000)
	
	if Input.is_action_pressed("up"):
		facing = Vector2.UP
	if Input.is_action_pressed("down"):
		facing = Vector2.DOWN
	
	if velocity.y < 0 && Input.is_action_pressed("jump"):
		if jump_pressed && abs(self.position.y - x_difference) < 50:
			velocity.y = jump_speed
	
	if Input.is_action_just_pressed("jump"):
		x_difference = self.position.y
		if is_on_floor():
			$Jump.play()
			jump_pressed = true
			velocity.y = jump_speed
	
	if Input.is_action_just_released("jump"):
		jump_pressed = false



func _on_HitTimer_timeout():
	for i in $Sprites.get_children():
		i.visible = true
	
	$Flasher.stop()


func _on_Flasher_timeout():
	for i in $Sprites.get_children():
		if i.visible:
			i.visible = false
		else:
			i.visible = true



func _on_DeathTimer_timeout():
	get_tree().reload_current_scene()
