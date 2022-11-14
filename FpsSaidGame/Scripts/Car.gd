extends VehicleBody

var horse_power = 200
var accel_speed = 20

var steer_angle = deg2rad(30)
var steer_speed = 3

var brake_power = 40
var brake_speed = 40

var car_zone = false
var active = false

func _physics_process(delta):
	if active:
		$Car_Camera.make_current()
		moveCar(delta)
		leaving_car()
	elif !active:
		entering_car()
		pass

func entering_car():
	if Input.is_action_just_pressed("Enter_Car") && car_zone == true:
		var hidden_player = get_parent().get_node("Player")
		hidden_player.active = false
		$Car_Camera.make_current()
		active = true

func leaving_car():
	var vehicle = $"."
	var hidden_player = get_parent().get_node("Player")
	var newLoc = vehicle.global_transform.origin - 2 * vehicle.global_transform.basis.x

	if car_zone == false && Input.is_action_just_pressed("Enter_Car"):
		hidden_player.active = true
		active = false
		hidden_player.global_transform.origin = newLoc

func moveCar(delta):
	#Accelerateur
	var throt_input = +Input.get_action_strength("Car_Run")-Input.get_action_strength("Car_Back")
	engine_force = lerp(engine_force, throt_input * horse_power, accel_speed * delta)

	#Direction
	var steer_input = -Input.get_action_strength("Car_Right")+Input.get_action_strength("Car_Left")
	steering = lerp_angle(steering, steer_input * steer_angle, steer_speed * delta)

	#Freinage
	var brake_input = Input.get_action_strength("Car_Brake")
	brake = lerp(brake, brake_input * brake_power, brake_speed * delta)

func _on_Player_Detection_body_entered(body):
	if body.name == "Player":
		car_zone = true

func _on_Player_Detection_body_exited(body):
	if body.name == "Player":
		car_zone = false
