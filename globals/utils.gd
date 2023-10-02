extends Node

#func lighten_color(color: Color, amount: float) -> Color:
#
#	var h = color.h
#	var s = color.s
#	var v = min(color.v - amount, 1)
#	return Color.from_hsv(h, s, v, color.a)
 
func is_town_far_enough(  new_coors, min_distance, towns):
	for town in towns:
		var distance = new_coors.distance_to(town.center)
		if distance < min_distance:
			return false
	return true

func find_child_with_variable(parent, variable):
	for child in parent.get_children():
		if variable in child:
			return child
	return null

func debug(position: Vector2, value):
	# Create a new Label node.
	var label = Label.new()
	# Set the text of the label to the value.
	label.text = str(value)
	# Set the position of the label.
	label.position = position
	# Add the label as a child of the current node.
	add_child(label)

	# Create a new Timer node.
	var timer = Timer.new()
	# Set the timer to one-shot mode and start it with a delay of 5 seconds.
	timer.set_one_shot(true)
	timer.start(0.1)
	# Connect the timeout signal of the timer to a function that removes the label.
 
	# Add the timer as a child of the current node.
	add_child(timer)
	label.queue_free()

## you have to put this variable wheter you want to put the z_indexes
#var nodes_list = []
#func get_z_indexes(node,nodes_list):
#	if node is CanvasItem:
#		nodes_list.append([node, node.z_index])
#	for child in node.get_children():
#		get_z_indexes(child,nodes_list)
#func sort_by_z_index_desc(a, b):
#	return a[1] < b[1]

func play_animation_at_position(animation_node, animation  , position: Vector2) -> void:
#	var animation = get_node(animation_name)
	
	if animation_node == null:
		print("No animation found with name: ", animation_node)
		return
#	animation_node.z_index = 100000
	animation_node.show()
	# Set the position of the animation
	animation_node.global_position = position

	# Play the animation
#	animation.play()
	animation_node.play(animation)
	print("playing animation",animation_node, animation  , position)
	# Hide the animation after it finishes playing
	await animation_node.animation_finished 
	animation_node.hide()

func get_random_point_in_square(square_size: Vector2) -> Vector2:
	var random_x = randi_range(0, int(square_size.x))
	var random_y = randi_range(0, int(square_size.y))
	return Vector2(random_x, random_y)

## doesnt work how I intended
func lighten_color(color: Color, points: int) -> Color:
	# Convert the color to RGB format
	var r = int(color.r * 255)
	var g = int(color.g * 255)
	var b = int(color.b * 255)

	# Subtract the specified number of points from each color component
	r = max(0, r - points)
	g = max(0, g - points)
	b = max(0, b - points)

	# Convert the lightened color back to Color format
	return Color(r / 255.0, g / 255.0, b / 255.0)
 
#func _on_timer_timeout(sprite):
#    # Remove the Sprite node from the scene tree when the timer times out
#	sprite.queue_free()
#func move():
#	var mouse_pos = get_global_mouse_position()
#	var distance_to_mouse = global_start_turn_position.distance_to(mouse_pos)
#	var new_position = position
#	if distance_to_mouse > base_movement:
#		var direction_to_mouse = (mouse_pos - global_start_turn_position).normalized()
#		new_position = global_start_turn_position + direction_to_mouse * base_movement - size / 2
#	else:
#		new_position = mouse_pos - size / 2
#	var temp_area = Area2D.new()
#	var temp_collision_shape = CollisionShape2D.new()
#	temp_collision_shape.shape = $CollisionArea/CollisionShape2D.shape.duplicate()
#	temp_area.add_child(temp_collision_shape)
#	get_tree().get_root().add_child(temp_area)
#	temp_area.global_position = new_position
#	# Check for collisions with other units.
#	var can_move = true
#	for unit in get_tree().get_nodes_in_group("living_units"):
#		if unit == self:
#			continue  # Skip checking collision with itself.
#		var overlapping_areas = unit.get_node("CollisionArea").get_overlapping_areas()
#		if overlapping_areas.has(temp_area):
#			can_move = false
#			print("CollisionArea overlapping areas: ", overlapping_areas)
#			print("temp_area: ", temp_area)
#			break
#	# Update the position if no collisions were detected.
#	if can_move:
#		position = new_position

#func move():
#	# Get the position of the mouse cursor.
#	var mouse_pos = get_global_mouse_position()
#
#	# Calculate the direction and distance to the mouse position.
#	var direction = (mouse_pos - position).normalized()
#	var distance = position.distance_to(mouse_pos)
#	var distance_to_mouse = global_start_turn_position.distance_to(mouse_pos)
#	# Move the character towards the mouse position.
#	var velocity = direction * speed
#	# Check if the character has reached the mouse position.
#	if distance_to_mouse < base_movement:
#		position = mouse_pos - size / 2		
#		move_and_slide(  )
