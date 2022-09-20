extends KinematicBody
onready var target_reset = translation
onready var move = Vector3.ZERO
onready var target_rot = rotation_degrees
onready var cam_rotation = Vector3.ZERO
var vel = Vector3.ZERO
export var top_speed = 33.0
func _process(delta):
	if Input.is_action_pressed("reset"):
		global_translate(target_reset- translation)
		rotation = target_rot
	if Input.is_action_pressed("mv_up"): 
		move.z -= 1.0
	if Input.is_action_pressed("mv_down"): 
		move.z += 1.0
	if Input.is_action_pressed("mv_l"): 
		move.x += 1.0
	if Input.is_action_pressed("mv_r"): 
		move.x -= 1.0
	if Input.is_action_pressed("m_vu"): 
		move.y -= 1.0
	if Input.is_action_pressed("m_vd"): 
		move.y += 1.0
	if Input.is_action_pressed("s_l"): 
		cam_rotation.y -= 0.2
	if Input.is_action_pressed("s_r"): 
		cam_rotation.y += 0.2
	if Input.is_action_pressed("s_u"): 
		cam_rotation.z -= 0.2
	if Input.is_action_pressed("s_d"): 
		cam_rotation.z += 0.2
	if Input.is_action_pressed("s_zu"): 
		cam_rotation.x -= 0.2
	if Input.is_action_pressed("s_zd"): 
		cam_rotation.x += 0.2

func _physics_process(delta):
	vel = Vector3.ZERO
	vel += move.z * transform.basis.x * top_speed
	vel += move.x * transform.basis.z * top_speed
	vel += move.y * transform.basis.y * top_speed
	
	global_translate(vel * delta * top_speed)
	rotation.y += cam_rotation.y * delta * top_speed
	rotation.x += cam_rotation.x * delta * top_speed
	rotation.z += cam_rotation.z * delta * top_speed
	
	move = Vector3.ZERO
	cam_rotation = Vector3.ZERO

