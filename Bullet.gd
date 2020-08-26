extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var explode = preload("res://explosion.png")

var start_pos
var speed = 5
var bullet_range = 400
var dmg = 1
var collided = false

func fire(start, direction):
	start_pos = start
	self.position = start_pos
	$Sprite.rotation = direction.angle() - PI/2
	self.position += direction*10
	if direction == Vector2.LEFT or direction == Vector2.RIGHT:
		self.position.y += 8
	speed *= direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var diff = self.position - start_pos
	if abs(diff.x) < bullet_range and abs(diff.y) < bullet_range:
		if !collided:
			self.position += speed
			self.scale *= 0.99
		else:
			$CollisionShape2D.disabled = true
	else:
		queue_free()

func _on_Bullet_area_entered(area):
	if area.is_in_group("mob"):
		$Sprite.texture = explode
		$Sprite.scale = Vector2(1,1)
		collided = true
		$AfterHitTimer.start(1.0)


func _on_Bullet_body_entered(body):
	if !body.get_name() == "Player":
		$Sprite.texture = explode
		$Sprite.scale = Vector2(1,1)
		collided = true
		$AfterHitTimer.start(1.0)

func _on_AfterHitTimer_timeout():
	queue_free()
