extends CharacterBody2D
## all export var
## paltformer movement
@onready var dash_timer: Timer = $dash_timer
@onready var dash_cooldown: Timer = $dash_cooldown
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var speed :int = 9000
@export var friction :int = 20
@export var max_jump :int = 1
@export var gravity :int = 100
@export var jump_power:int = -1000
@export var wall_slide_gravity = 80
var current_jump:int = 0
var is_wall_sliding = false
var dashing = false
var can_dash = true
@export var dash_power = 18000

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("dashing"):
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_cooldown.start()
	
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		if dashing:
			velocity.x = direction * dash_power * delta
		else :
			velocity.x = direction * speed * delta
			animation.play("run")
			animation.flip_h = direction <0
			#add filp animation
	else:
		velocity.x = velocity.move_toward(Vector2.ZERO,friction).x
		animation.play('idle')
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
			

	


func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
