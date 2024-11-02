extends CharacterBody2D
## all export var
## paltformer movement
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var speed :int = 9000
@export var friction :int = 20
@export var max_jump :int = 1
@export var gravity :int = 100
@export var jump_power:int = -1000
@export var wall_slide_gravity = 80
var current_jump:int = 0
var is_wall_sliding = false


func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * speed *delta
		animation.play("run")
		animation.flip_h = direction <0
		#add filp animation
	else:
		velocity.x = velocity.move_toward(Vector2.ZERO,friction).x
		#add animation
	
	move_and_slide()
	jump()
	wall_jump()
	

func jump():
	if Input.is_action_just_pressed("jump"):
		if current_jump < max_jump :
			velocity.y = jump_power
			## add animation 
			current_jump = current_jump + 1
			print(current_jump)
	else:
		velocity.y += gravity
		if is_on_floor():
			current_jump = 0
			
	
func wall_jump():
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			current_jump = 0
			is_wall_sliding = true
		else :
			is_wall_sliding = false
			
		if is_wall_sliding :
			##add gravity need to slowly going down
			velocity.y += (wall_slide_gravity * get_physics_process_delta_time())
			##capping gravity power
			velocity.y = min(velocity.y , wall_slide_gravity)
			
func dash():
	pass
	
