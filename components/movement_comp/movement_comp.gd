class_name MovementComponent
extends Node2D
signal remain_movement_changed(new_movement)
const base_movement:int = 1
const base_movement_range:int = 250  
@onready var parent_size:Vector2
@onready var global_start_turn_position :Vector2 =  to_global(position)#get_global_transform().get_origin() # Vector2((position[0]+round(size[0]/2)),(position[1]+round(size[1]/2)))
var remain_movement:int = base_movement:
	set(new_movement):
		remain_movement = new_movement
		emit_signal("remain_movement_changed", new_movement)
 

func _ready():
#	print(global_start_turn_position,to_global(position), "START TURN POS")
#	global_start_turn_position  = to_global(position)
	$MovementRangeArea/MovementRangeArea.shape = CircleShape2D.new()
	$MovementRangeArea/MovementRangeArea.shape.radius = base_movement_range
	$MovementRangeArea/MovementRangeArea.hide()
	global_start_turn_position =  global_position  
func move(size_of_scene, center):
#	print("move")
	var mouse_pos = get_global_mouse_position()
	var distance_to_mouse = global_start_turn_position.distance_to(mouse_pos)
	var new_position = global_position

	if distance_to_mouse > base_movement_range:
		var direction_to_mouse = (mouse_pos - global_start_turn_position).normalized()
		new_position = global_start_turn_position + direction_to_mouse * base_movement_range - size_of_scene / 2
	else:
		new_position = mouse_pos - size_of_scene / 2

 
	global_position = new_position 
	center =  to_global(global_position + size_of_scene/2)
#	print(position, global_start_turn_position)
	return  global_position 
		
func abort_movement():
	#print("abort_movement")
	#print(global_position, global_start_turn_position, "BEFORE")
	Globals.moving_unit = null
	global_position = global_start_turn_position
	#print(   global_start_turn_position, "AFTER")
	return    global_start_turn_position       
	
func set_new_start_turn_point():
	#print("set_new_start_turn_point")
	#print(global_start_turn_position,global_position, parent_size, "VALUES BEFORE SETTING NEW START POS")
	global_start_turn_position = global_position #$CollisionArea/CollisionShape2D.global_position +$CollisionArea/CollisionShape2D.shape.extents/2 
	position = to_local(global_start_turn_position)
	return global_start_turn_position
