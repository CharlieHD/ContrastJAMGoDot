extends CharacterBody3D

@export_group("Camera")
@export_enum("mouse", "keys") var camera_mode = 1
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var cam_speed := 0.05

@export_group("physics")
@export var speed := 1.0
@export var speed_interval := 0.5
@export var max_speed := 5.0
@export var jump_height := 15
@export var gravity := 2.5

@export_group("visual")
@export var tilt_force := 1

var current_jump_force := 0.0
var is_mouse_moving := false
var can_jump := false
var is_jumping := false
var default_position := Vector3(0.0 ,0.116, 0.73)

func _physics_process (_delta: float) -> void:
	# camera + movement code
	var move_axis = Input.get_vector("left", "right", "forward", "backward")
	if camera_mode == 1:
		var Cam_axis = Input.get_vector("right_camera", "left_camera", "down_camera", "up_camera")
		rotate_object_local(Vector3(0, 1, 0) ,Cam_axis.x * cam_speed)
		$CameraPivot.rotate_x(Cam_axis.y * cam_speed)
		$NOXROBOT.rotation_degrees.x = speed * move_axis.y
	if move_axis:
		$NOXROBOT.rotation_degrees.z = tilt_force * -move_axis.x
		if abs(speed) < max_speed:
			speed += speed_interval
		velocity = transform.basis.z * speed * move_axis.y
		transform = transform.orthonormalized()
		#velocity.x = move_axis.x * speed
	else:
		$NOXROBOT.rotation_degrees.z = lerp($NOXROBOT.rotation_degrees.z, 0.0, 0.5)
		speed = lerp(speed, 0.0, 0.05)
		velocity = velocity.move_toward(Vector3.ZERO, 0.5)
	# controls jump behavior
	if is_on_floor():
		can_jump = true
		
	else:
		velocity.y -= gravity
		can_jump = false
	
	if can_jump and Input.is_action_just_pressed("jump"):
		current_jump_force = jump_height
		is_jumping = true
		$jumpTimer.start()
	
	if is_jumping:
		velocity.y = current_jump_force
		current_jump_force -= 1.0
	
	move_and_slide()

func _on_jump_timer_timeout() -> void:
	is_jumping = false
