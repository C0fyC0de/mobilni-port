extends Node

@onready var brzina = 0.001
@onready var zoomspeed = 5
@onready var node = $"."
@onready var camera_3d = $Camera3D


func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var q = Quaternion(Vector3(-1, 0, 0), PI/25)*Quaternion(Vector3(0, 1, 0), PI/16)
	node.set_rotation(q.get_euler())
	node.top_level = true
	
	
	#orbitiranje
func _input(event):
	if event is InputEventMouseMotion:
		# Get mouse movement
		var mouse_delta = event.relative

		# Create rotation quaternions for the x and y axis
		var x_rot = Quaternion(Vector3(1, 0, 0), -mouse_delta.y * brzina)
		var y_rot = Quaternion(Vector3(0, 1, 0), -mouse_delta.x * brzina)

		# Apply the rotations to the current rotation
		var new_rot = self.transform.basis.get_rotation_quaternion() * x_rot * y_rot

		# Set the new rotation
		self.transform.basis = Basis(new_rot)
		node.rotation.z = 0
		if(node.rotation.x < -1.4):
			node.rotation.x = -1.4
		if(node.rotation.x > 1.4):
			node.rotation.x = 1.4
	#zoomiranje
	if event is InputEventMouseButton:
		if(camera_3d.fov > 75):
			camera_3d.fov = 75
		elif(camera_3d.fov < 20):
			camera_3d.fov = 20
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera_3d.fov -= zoomspeed
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera_3d.fov += zoomspeed
