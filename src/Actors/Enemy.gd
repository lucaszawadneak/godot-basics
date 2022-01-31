extends "res://src/Actors/Actor.gd"

func _physics_process(delta):
	motion.y += GRAVITY * delta
	
	motion = move_and_slide(motion,Vector2.UP)
