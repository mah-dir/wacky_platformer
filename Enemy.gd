extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var health = 5
export (Vector2) var direction = Vector2.UP
export (int) var num_babies = 6
export (bool) var make_baby = true
var op_dir = 1
var dmg = 5

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += 1 * direction * op_dir


func _on_Area2D_area_entered(area):
	if area.is_in_group("bullet"):
		health -= area.dmg
		$Hit.play()
		if health <= 0:
			$Split.play()
			call_deferred("spawn_babies", self.position, 0.5, num_babies, 12)
			queue_free()

func spawn_babies(position, scale, num, rad):
	if make_baby:
		var enemy_scene = load("res://Enemy.tscn")
		for i in range(num):
			var baby = enemy_scene.instance()
			baby.position = position
			baby.scale *= scale
			baby.health = 5
			baby.make_baby = false
			rng.randomize()
			baby.direction = Vector2(rng.randi_range(-rad, rad), rng.randi_range(-rad, rad)).normalized()
			get_parent().add_child(baby)
	
	
func _on_Enemy_body_entered(body):
	if body.get_name() == "Player":
		body.hp_dmg(dmg)
		body.knock_back(self.position)
	else:
		op_dir *= -1
