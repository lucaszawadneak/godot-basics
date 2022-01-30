extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const AIR_RESISTANCE = 0.02
const FRICTION = 0.25
const GRAVITY = 200
const JUMP_FORCE = 128

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animation = $AnimationPlayer

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animation.play("Run")
		motion.x += x_input * ACCELERATION * delta
		# clamp limita o valor da váriavel para os segundos e terceiros parâmetros
		motion.x = clamp(motion.x, -MAX_SPEED,MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animation.play("Stand")
	
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		if x_input == 0:
		# linear interpolation = tenta abaixar o valor para o parametro 2
			motion.x = lerp(motion.x,0, FRICTION)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		animation.play("Jump")
		if Input.is_action_just_released("ui_up") and motion.y < - JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		if x_input == 0:
		# linear interpolation = tenta abaixar o valor para o parametro 2
			motion.x = lerp(motion.x,0, AIR_RESISTANCE)
		
	
	# move_and_slide retorna a motion restante
	# zera em caso de colisão (ou seja, após colidir, motion = 0
	motion = move_and_slide(motion, Vector2.UP)
