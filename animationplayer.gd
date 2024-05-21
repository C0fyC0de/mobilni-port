extends Node

@onready var anim_tree = $AnimationTree
@onready var sub = $"."
@onready var node_3d = $Node3D
@onready var StartOffset = node_3d.transform.origin - sub.transform.origin
@onready var add_value = 1
@onready var torqueforce = 70000
@onready var speedpropeler = 7000
@onready var torqueProtuSila = 150000
@onready var animation_player = $AnimationPlayer
@onready var ButtonGore = false
@onready var ButtonDesno = false
@onready var ButtonDolje = false
@onready var ButtonLijevo = false
@onready var ButtonLijevoZakret = false
@onready var ButtonDesnoZakret = false
@onready var switch = 0
@onready var switch1 = 0
@onready var switch2 = 0
@onready var switch3 = 0
@onready var switch4 = 0
@onready var switch5 = 0


func balans():
	if(sub.rotation.z > 0.01):
		sub.apply_torque(sub.transform.basis * Vector3(0, 0, -sub.rotation.z*10000))
	if(sub.rotation.z < -0.01):
		sub.apply_torque(sub.transform.basis * Vector3(0, 0, -sub.rotation.z*10000))
	if(sub.rotation.x > 0.01):
		sub.apply_torque(sub.transform.basis * Vector3(-sub.rotation.x*torqueProtuSila, 0, 0))
	if(sub.rotation.x < -0.01):
		sub.apply_torque(sub.transform.basis * Vector3(-sub.rotation.x*torqueProtuSila, 0, 0))
	
	
	#print(sub.rotation.x)
	#print(sub.linear_velocity)
	#print(sub.angular_velocity)
	#lokalna_brzina()
	#print(anim_tree.get("parameters/Animation/time"))

func lokalna_brzina():
	#lokalna brzina
	var b = sub.transform.basis
	var v_len = sub.linear_velocity.length()
	var v_nor = sub.linear_velocity.normalized()
	var vel : Vector3
	vel.x = b.x.dot(v_nor) * v_len
	vel.y = b.y.dot(v_nor) * v_len
	vel.z = b.z.dot(v_nor) * v_len
	print(vel)

func update_tree():
	anim_tree["parameters/PropellerCtrl/add_amount"] = add_value

func _ready():
	$"../Control/ButtonGore".pressed.connect(self._on_button_gore_pressed)
	$"../Control/ButtonDesno".pressed.connect(self._on_button_desno_pressed)
	$"../Control/ButtonDolje".pressed.connect(self._on_button_dolje_pressed)
	$"../Control/ButtonLijevo".pressed.connect(self._on_button_lijevo_pressed)
	$"../Control/ButtonLijevoZakret".pressed.connect(self._on_button_lijevo_zakret_pressed)
	$"../Control/ButtonDesnoZakret".pressed.connect(self._on_button_desno_zakret_pressed)
	update_tree()

func _on_button_gore_pressed():
	if switch2 == 0:
		ButtonGore = true 
		ButtonDolje = false 
		switch2 = 1
	else:
		ButtonGore = false 
		switch2 = 0
	
func _on_button_desno_pressed():
	if switch4 == 0:
		ButtonDesno = true 
		ButtonLijevo = false 
		switch4 = 1
	else:
		ButtonDesno = false 
		switch4 = 0
	
func _on_button_dolje_pressed():
	if switch3 == 0:
		ButtonDolje = true 
		ButtonGore = false 
		switch3 = 1
	else:
		ButtonDolje = false 
		switch3 = 0
	
func _on_button_lijevo_pressed():
	if switch5 == 0:
		ButtonLijevo = true 
		ButtonDesno = false 
		switch5 = 1
	else:
		ButtonLijevo = false 
		switch5 = 0;
	
func _on_button_lijevo_zakret_pressed():
	if switch == 0:
		ButtonLijevoZakret = true 
		ButtonDesnoZakret = false 
		switch = 1
	else:
		ButtonLijevoZakret = false 
		switch = 0
	
func _on_button_desno_zakret_pressed():
	if switch1 == 0:
		ButtonDesnoZakret = true
		ButtonLijevoZakret = false  
		switch1 = 1
	else:
		ButtonDesnoZakret = false 
		switch1 = 0
	
func _process(delta):
	node_3d.transform.origin = sub.transform.origin + StartOffset
	update_tree()
#eve

func _physics_process(delta):
	if(sub.angular_velocity.y < 0.2):
		if Input.is_key_pressed(KEY_A) or ButtonLijevo == true:
			sub.apply_torque(sub.transform.basis * Vector3(0, torqueforce, 0))
	if(sub.angular_velocity.y > -0.2):
		if Input.is_key_pressed(KEY_D) or ButtonDesno == true:
			sub.apply_torque(sub.transform.basis * Vector3(0, -torqueforce, 0))
	if(sub.angular_velocity.x < 0.2 and sub.rotation.x <= 0.3):
		if Input.is_key_pressed(KEY_SHIFT) or ButtonDesnoZakret == true:
			sub.apply_torque(sub.transform.basis * Vector3(torqueforce, 0, 0))
	if(sub.angular_velocity.x > -0.2 and sub.rotation.x >= -0.3):
		if Input.is_key_pressed(KEY_CTRL) or ButtonLijevoZakret == true:
			sub.apply_torque(sub.transform.basis * Vector3(-torqueforce, 0, 0))
			
			
			
	if(sub.linear_velocity.z > -100):
		if Input.is_key_pressed(KEY_W) or ButtonGore == true:
			sub.apply_central_force(sub.transform.basis.z * -speedpropeler)
			
	if(sub.linear_velocity.z < 100):
		if Input.is_key_pressed(KEY_S) or ButtonDolje == true:
			sub.apply_central_force(sub.transform.basis * Vector3(0, 0, speedpropeler))
		
		
	balans()
