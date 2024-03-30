extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

const SPEED = 4.0

@export var attack_range: float = 2.0
@export var attack_cooldown: float = 3.0
@export var follow_range: float = 10.0
@export var damage: float = 20.0
@export var max_health: float = 5.0

@onready var health: float = max_health

func _ready():
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)


func _physics_process(delta):
	if not is_instance_valid(Global.player):
		return


func follow():
	velocity = Vector3.ZERO	
	nav_agent.set_target_position(Global.player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	move_and_slide()
	
func _process(delta):
	pass
		
func should_attack():
	return global_position.distance_to(Global.player.global_position) < attack_range

func should_follow():
	return global_position.distance_to(Global.player.global_position) < follow_range \
		and not should_attack()
	
func hit():
	health -= 1
	if is_dead():
		die()
	
func attack(damage):
	Global.player.hit(damage)

func die():
	queue_free()
	
func is_dead():
	return health <= 0