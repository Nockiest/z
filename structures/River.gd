class_name  River
extends Node2D
##most logic currently handled in the Battleround component
# Define the start and end points of the line
var river_segment_scene:PackedScene = preload("res://structures/river_segment.tscn")
var screen_size:Vector2 
var start_point:Vector2 #= Vector2(randi_range(0, screen_size.x / 2), randi_range(0, screen_size.y / 2))
# Generate a random end point on the right or bottom side of the screen
var end_point:Vector2 # = Vector2(randi_range(screen_size.x / 2, screen_size.x), randi_range(screen_size.y / 2, screen_size.y))
var control_point:Vector2 #  =  Vector2(randi_range(100, screen_size.x-100), randi_range(100, screen_size.y-100))
var num_segments = 10
var itersecting_point_index:int
var points:Array = []
 
#var control_point  = Vector2(50, 0)
 

func add_river_segment(segment_start, segment_end,  listen_for_river_collision:bool ):
	var river_segment_instance = river_segment_scene.instantiate() as Node2D
#			river_segment_instance.owner  =self
	river_segment_instance.connect("intersects_another_river", set_river_intersection   )
	river_segment_instance. listen_for_river_collision  =  listen_for_river_collision 
	var collision_area = river_segment_instance.get_node("Area2D")
	collision_area.position = (segment_start+ segment_end ) / 2
	collision_area.rotation = segment_start.direction_to(segment_end).angle()
	var length = segment_start.distance_to(segment_end)
	var rect = RectangleShape2D.new()
	var collision_shape = collision_area.get_node("CollisionShape2D")
	rect.extents = Vector2(length / 2, 5)
	collision_shape.shape = rect
	river_segment_instance.get_node("Line2D").add_point(  segment_end )
	river_segment_instance.get_node("Line2D").add_point( segment_start )
#			print(previous_point, last_point, river_segment_instance.get_node("Line2D").points  )
#	for node in get_tree().get_nodes_in_group("river_segments"):
##		print( node != collision_area ,node.overlaps_area(collision_area))
#		if node != collision_area and node.overlaps_area(collision_area):
#			print("NEW SEGMENT IS INTERSECTING ", node)  

	call_deferred("add_child_to_segments", river_segment_instance)
 
func add_child_to_segments(child):
	$segments.add_child(child)
func set_river_intersection(segment,colliding_area):
#	print(segment, "SEGMENT INTERSECTED")
#	if itersecting_point_index and itersecting_point_index > segment.get_index( ):
#		return
	itersecting_point_index = segment.get_index( )
	solve_river_intersection(segment,colliding_area)
#	print(itersecting_point_index, self)
 

func solve_river_intersection(segment,colliding_area ):
#	for segment in get_node("segments").get_children():
#		for river_segment in get_tree().get_nodes_in_group("river_segments"):
#			print( river_segment.get_node("Area2D").get_overlapping_areas ( ) )
#			if segment.get_node("Area2D") in river_segment.get_node("Area2D").get_overlapping_areas ( ) :
#				print("OVERLAPS BODY", segment, river_segment)
#
#		print(segment, segment.get_node("Area2D"))
#		var segment_collision_shape = segment.get_node("Area2D")
#		for area in segment_collision_shape.get_overlaping_areas():
#			if not ( area is RiverSegment):
#				continue
#			if area.get_parent().get_parent() == get_parent():
#				continue
#			print("INTERSECTS AREA", area, area.get_parent().get_parent() , self, get_parent() )

#		for river_segment in get_tree().get_nodes_in_group("river_segments"):
#				print(river_segment.get_node("Area2D"), river_segment.get_node("Area2D").get_overlapping_areas ( ))
#				if segment in  river_segment.get_node("Area2D").get_overlapping_areas ( )
#				for area in  river_segment.get_node("Area2D").get_overlapping_areas ( ):
#					if area == $CollisionArea:
#						print(area, " OVERLAPS")
#						in_valid_buy_area = false
#						break
#	print("SOLVING", itersecting_point_index , $segments.get_children())
	if itersecting_point_index == null:
		return
	if not( get_index() < get_parent().get_child_count() - 1):
		return

#	print("SOLVING", itersecting_point_index, $segments.get_children())
#	if placment_completed:
#		return
	for node in $segments.get_children():
#		print(node,  node.get_index() , itersecting_point_index)
	# Check if the node has a higher index than the segment in the argument
		if node.get_index() >= itersecting_point_index:
	# Remove the node from the scene tree
			node.queue_free()
	var new_segment_start = segment.get_node("Line2D").points[0]
	var new_segment_end = colliding_area.get_parent().get_node("Line2D").points[1]
	add_river_segment(new_segment_start, new_segment_end, false)
#	# Add the Line2D node to the scene tree
func _ready():
	pass
#	print(position)
#	screen_size =  Vector2(get_viewport().get_visible_rect().size.x ,get_viewport().get_visible_rect().size.y)
#	var top_point =  Vector2(randi_range(100, screen_size.x  -100), 0)
#	var right_point =  Vector2( screen_size.x  , randi_range(100, screen_size.y -100))
#	var left_point =  Vector2( 0 , randi_range(100, screen_size.y -100 ))
#	var bottom_point =  Vector2(randi_range(100, screen_size.x -100 ),   screen_size.y )		
#	# Vector2(100,0)Vector2(500,500)  Vector2(500, screen_size.y)
#	start_point = top_point if randi() % 2 == 0 else left_point
#	control_point =  Vector2(randi_range(100, screen_size.x-100), randi_range(100, screen_size.y-100))
#	end_point = bottom_point if randi() % 2 == 0 else right_point
#	print(start_point, control_point, end_point, screen_size)
#	generate_bezier_curve(start_point, end_point,control_point,  num_segments)
 
func find_other_river_intersections():
	pass
 
 
