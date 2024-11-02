extends CharacterBody2D
## all export var
## paltformer movement

@export var speed :int = 9000
@export var friction :int = 20
@export var max_jump :int = 2
@export var gravity :int = 100

var current_jump:int

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * speed *delta
		#add animation
		#add filp animation
	else:
		velocity.x = velocity.move_toward(Vector2.ZERO,friction).x
		#add animation
	
	move_and_slide()
	jump()
	

func jump():
	velocity.y += gravity
	
func wall_jump():
	pass
