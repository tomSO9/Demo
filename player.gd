extends CharacterBody2D
## all export var
## paltformer movement

@export var speed :int
@export var friction :int
@export var max_jump :int
@export var gravity :int

var current_jump:int

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * speed * delta
		#add animation
		#add filp animation
	else:
		velocity.x = velocity.move_toward(Vector2.ZERO,friction).x
		#add animation
	move_and_slide()
	

func jump():
	pass
	
func wall_jump():
	pass
