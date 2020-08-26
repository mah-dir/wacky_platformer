extends Area2D

signal text_to_display

export (String, MULTILINE) var text_display = "default text"
var inside = false

func _ready():
	$Particles2D.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Interactable_body_entered(body):
	if body.get_name() == "Player":
		inside = true
		emit_signal("text_to_display", self.text_display, inside)


func _on_Interactable_body_exited(body):
	if body.get_name() == "Player":
		inside = false
		emit_signal("text_to_display", self.text_display, inside)
