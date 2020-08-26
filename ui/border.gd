extends Control


signal text_done

var vp = 0
var length = 0
var done = false
var inside = false
var text 

func get_input():
	if Input.is_action_just_pressed("down") and inside:
		done = false
		get_tree().paused = true
		$DialogBox/Click.play()
		set_text(text)
	if Input.is_action_just_pressed("jump") and inside:
		if !done:
			$Timer.start(0.01)
		else:
			$DialogBox/End.play()
			get_tree().paused = false
			$DialogBox.visible = false
			
func _process(delta):
	if inside:
		get_input()
	
func set_text(text):
	$DialogBox.visible = true
	$DialogBox/HBoxContainer/NinePatchRect/Label.text = text
	$DialogBox/HBoxContainer/NinePatchRect/Label.visible_characters = vp
	length = text.length()
	$Timer.start(0.05)
	
	
func _ready():
	$DialogBox/HBoxContainer/NinePatchRect.rect_min_size.x = self.rect_size.x
#	$Background.play()

func _on_Timer_timeout():
	vp += 1
	$DialogBox/HBoxContainer/NinePatchRect/Label.visible_characters = vp
	if vp > length:
		vp = 0
		$Timer.stop()
		done = true
		emit_signal("text_done")
	



func _on_Player_hp_change(hp):
	$Hp/Label.text = "HP " + str(hp)


func _on_Interactable_text_to_display(text_to_display, is_inside):
	text = text_to_display
	inside = is_inside
		
