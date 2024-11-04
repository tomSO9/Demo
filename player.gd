extends CharacterBody2D
## all export var
## paltformer movement
@onready var dash_timer: Timer = $dash_timer
@onready var dash_cooldown: Timer = $dash_cooldown
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var cd_bar: ProgressBar = $skill_ui/cd_bar
@onready var cd_icon: TextureRect = $skill_ui/cd_icon


@export var speed :int = 9000
@export var friction :int = 20
@export var max_jump :int = 2
@export var gravity :int = 100
@export var jump_power:int = -1500
@export var wall_slide_gravity = 80
var current_jump:int = 0
var is_wall_sliding = false
var dashing = false
var can_dash = true
@export var dash_power = 54000
@export var cd_duration = 1

func _ready() -> void:
	cd_bar.max_value = cd_duration
	cd_bar.value = cd_duration


func _physics_process(delta: float) -> void:
	
	if dash_cooldown.is_stopped() ==false:
		cd_bar.value = cd_duration - dash_cooldown.time_left
	
	if Input.is_action_just_pressed("dashing") and can_dash :
		dashing = true
		can_dash = false
		cd_icon.modulate.a = 0.5
		cd_bar.value = 0
		dash_timer.start()
		dash_cooldown.start()
	
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		if dashing:
			velocity.x = direction * dash_power * delta
			animation.play('dash')
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
	cd_icon.modulate.a = 1 
	cd_bar.value = cd_duration
	can_dash = true
