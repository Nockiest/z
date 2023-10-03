extends Node2D

@export var per_turn_income = 10
var hovered_element = null
var selected_move_unit = null
var selected_attacking_unit = null
var unit_placement_mode = false
var loaded = false
var teams = ["red", "blue"]
var town_scene: PackedScene = preload("res://structures/town.tscn")
var player_scene: PackedScene = preload("res://player.tscn")
var supply_depo_scene: PackedScene = preload("res://structures/supply_depo.tscn")
var river_scene: PackedScene = preload("res://structures/river.tscn")
var forrest_scene:PackedScene = preload("res://structures/forrest/forrest.tscn")
var road_scene:PackedScene = preload("res://structures/road/road.tscn")
#this could cause potential problems in the future
@onready var tenders = get_tree().get_nodes_in_group("player_tenders")
@onready var players = get_tree().get_nodes_in_group("players")
 
func put_unit_into_teams():
	var units = get_tree().get_nodes_in_group("living_units") 
	for i in range(len(units)):
		var unit = units[i]
		var team = teams[i % len(teams)]
#		unit.remain_movement = unit.base_actions
		unit.add_to_team(team)
		unit.is_newly_bought = false
	Globals.placed_unit = null

func _ready():
	LoadingScreen.render_loading_screen()
	set_process_input(true)
	put_unit_into_teams()
 
	for i in range(7):
		var town_instance = town_scene.instantiate() as Area2D
		town_instance.global_position = Vector2(randf_range(100, get_viewport().size.x-100), randf_range(100, get_viewport().size.y-100))
		$Structures.add_child(town_instance)
	for town in get_tree().get_nodes_in_group("towns"):
		town.connect_to_other_towns()
	for town in get_tree().get_nodes_in_group("towns"):
		print("CONNECTING", town.connected_towns)
		for other_town in town.connected_towns:
			instantiate_roads(Utils.get_collision_shape_center(town  ), Utils.get_collision_shape_center(other_town ))
	for i in range(2):
		var supply_depo_instance = supply_depo_scene.instantiate() as Area2D
		supply_depo_instance.global_position = Vector2(randf_range(0, get_viewport().size.x), randf_range(0, get_viewport().size.y))
		$Structures.add_child(supply_depo_instance)
	var all_segments = []
	for i in range(10):
		var top_point =  Vector2(randi_range(100, get_viewport().size.x  -100), 0)
		var right_point =  Vector2(  get_viewport().size.x  , randi_range(100,  get_viewport().size.y -100))
		var left_point =  Vector2( 0 , randi_range(100,  get_viewport().size.y -100 ))
		var bottom_point =  Vector2(randi_range(100,  get_viewport().size.x -100 ),    get_viewport().size.y )		
		# Vector2(100,0)Vector2(500,500)  Vector2(500, screen_size.y)
		var start_point = top_point if randi() % 2 == 0 else left_point
		var control_point =  Vector2(randi_range(100, get_viewport().size.x-100), randi_range(100, get_viewport().size.y-100))
		var end_point = bottom_point if randi() % 2 == 0 else right_point
		
		var new_segments = generate_bezier_curve(start_point, end_point, control_point,  10)
		var non_intersecting_segments = []
		var intersecting_segment 
		for segment in new_segments:
			for existing_segment in all_segments:
				if do_lines_intersect(segment[0], segment[1], existing_segment[0], existing_segment[1])  :
					print("SEGMENTS INTERSECTING", segment[0], segment[1], existing_segment[0], existing_segment[1] )
					intersecting_segment = segment
					non_intersecting_segments.append([segment[1], existing_segment[0]])
			if intersecting_segment:
				break
			non_intersecting_segments.append(segment)
		if intersecting_segment:
			print(len(non_intersecting_segments), len(new_segments))
		for segment in non_intersecting_segments:
			all_segments.append(segment  )
		var river_instance = river_scene.instantiate() as Node2D
		for segment in non_intersecting_segments:
			river_instance.add_river_segment(segment[0], segment[1],  false)
		$Structures.add_child(river_instance)
	for i in range(6):
		var forrest_instance = forrest_scene.instantiate() as Node2D
		$Structures.add_child(forrest_instance)

		
func instantiate_roads(start, end):
	var road_instance = road_scene.instantiate() as Node2D
	var collision_area = road_instance.get_node("Area2D")
	print(start,end)
	collision_area.position = Vector2(start + end ) / 2
	collision_area.rotation = start.direction_to(end).angle()
	var length = start.distance_to(end)
	var rect = RectangleShape2D.new()
	var collision_shape = collision_area.get_node("CollisionShape2D")
	rect.extents = Vector2(length / 2, 5)
	collision_shape.shape = rect
	road_instance.get_node("Line2D").add_point(  end )
	road_instance.get_node("Line2D").add_point(  start )
	$Structures.add_child(road_instance)

func generate_bezier_curve(start:Vector2, end:Vector2, control_point:Vector2,  num_segments:int):
	var t:float = 0
	var points = []
	var segments = []
	while t <= 1:
		# Define the control points for the Bézier curve 
		var q0 = start.lerp(control_point, t)
		var q1 = control_point.lerp(end , t)
		var point = q0.lerp(q1, t)
		# Generate two random points between the start and end points
		points.append(point)
#		print(line.points.size)
		if len( points) >= 2:
			segments.append([ round(points[-1]), round(points[-2]) ])
#			add_river_segment(points[len( points )-1],  points[len( points)-2],true)
		t += 1.0/num_segments
	return segments

#	Engine.time_scale = 0.5
 
 
# def generate_chunks(self, rivers):
#        intersects = False
#        intersecting_rivers = []
#        possible_convergence_points = []
#        for i in range(self.num_segments + 1):
#            t = i / self.num_segments
#            point = calculate_bezier_curve(t, self.startpoint, self.endpoint,self.control_points[0], self.endpoint) # měl bych využít oba control pointy
#            rounded_point = (round(point[0]), round(point[1]))
#
#            self.points.append(rounded_point)
#
#
#            for existing_river in  rivers:
#                for j in range(len(existing_river.points) - 1):
#                    intersection = do_lines_intersect(self.points[len(self.points) - 2], rounded_point, existing_river.points[j], existing_river.points[j+1])
#                    # print(intersection, existing[j], existing[j+1] )
#                    if intersection:
#                        intersects = True  # Set the intersection flag to True
#                        # print(intersection)
#                        convergence_point = existing_river.points[j+1]  # Store the intersection point
#                        possible_convergence_points.append(convergence_point)
#                        intersecting_rivers.append(existing_river)
#                        print("convergence", convergence_point)
#                        # self.convergence_point = convergence_point
#                        # break  # Break the inner loop once an intersection is found
#
#
#                # if intersects:  # If an intersection is found, break the outer loop
#                #     break
#
#
#            if intersects:  # If an intersection is found, break the loop and do not add the river
#                break
#        convergence_copy = possible_convergence_points.copy() 
#        index = 0
#        while intersects == True:
#            self.points[-1] =  convergence_copy[index]
#            intersects = False
#            for existing_river in  rivers:
#                for j in range(len(existing_river.points) - 1):
#                    intersects = do_lines_intersect(self.points[len(self.points) - 2], self.points[len(self.points) - 3], existing_river.points[j], existing_river.points[j+1])
#                    # print("new intersection", intersects)
#
#                    if intersects:
#
#                        break
#                if intersects:
#                    break
#
func orientation(p, q, r):
		var val = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1])
		if val == 0:
			return 0
		return 1 if val > 0 else 2

func do_lines_intersect(p1, p2, p3, p4):

 
	var o1 = orientation(p1, p2, p3)
	var o2 = orientation(p1, p2, p4)
	var o3 = orientation(p3, p4, p1)
	var o4 = orientation(p3, p4, p2)

	if o1 != o2 and o3 != o4:
		if min(p1[0], p2[0]) <= max(p3[0], p4[0]) and min(p3[0], p4[0]) <= max(p1[0], p2[0]) and \
			min(p1[1], p2[1]) <= max(p3[1], p4[1]) and min(p3[1], p4[1]) <= max(p1[1], p2[1]):
			# Calculate the point of intersection
			var intersect_x = (o1 * p3[0] - o2 * p4[0]) / (o1 - o2)
			var intersect_y = (o1 * p3[1] - o2 * p4[1]) / (o1 - o2)
			return Vector2(intersect_x, intersect_y)

	return false

func _on_blue_buy_area_buy_unit(cost):
	print("buying unit", cost, Globals.cur_player)
  
 
func _on_red_buy_area_buy_unit(cost):
	print("buying unit", cost, Globals.cur_player)
 
 
func _input(event):
	if event is InputEventMouseMotion:
		$VBoxContainer/DebugLabel.text = "Global Coors: " + str(event.position)
	$VBoxContainer/HoveredUnit.text = str(Globals.hovered_unit)

func _on_canvas_next_turn_pressed():
	Globals.cur_player_index += 1  
	Globals.action_taking_unit = null
	Globals.moving_unit = null
	## not currently used
	var Supply_depos =  get_tree().get_nodes_in_group("supply_depos") 
	var units = get_tree().get_nodes_in_group("living_units")
	var support_actions = get_tree().get_nodes_in_group("support_actions")
	var towns = get_tree().get_nodes_in_group("towns") 
	for unit in units:
		unit.update_for_next_turn()
	for support_action in support_actions:
#		print (support_action, " supportaction ", support_action.get_parent())
		support_action.provide_buffs()
	for town in towns:
		town.make_next_turn_calculations()
	for depo in Supply_depos:
		var resupply_action = depo.get_node("AreaResupplyAction")
		resupply_action.provide_buffs()
	give_money_income_to_players()

func give_money_income_to_players(): 
	var red_towns = 0
	var blue_towns = 0
	var towns = get_tree().get_nodes_in_group("towns")
	for structure in towns:
		if structure.team_alligiance == "red":
			red_towns += 1
		elif structure.team_alligiance == "blue":
			blue_towns += 1
#	print(red_towns, blue_towns, " BLUE AND RED TOWNS")
	Globals.blue_player_money += per_turn_income + blue_towns*10
	Globals.red_player_money += per_turn_income + red_towns*10


func update_tender(new_value, color):
	print("UPDATING TENDER TO ", new_value, color) 
	
	
 
#	for unit in get_tree().get_nodes_in_group("living_units"):
##		unit.connect("interferes_with_area", _on_unit_interferes_with_object) 
#		unit.remain_actions = unit.base_actions
#func _on_unit_interferes_with_object(unit):
 
#	print(unit.name + " interfered ")

# DOESNT WORK ANYMORE		
 
#var towns = place_towns()
#func place_towns( ):
#	var towns = []
#	var min_distance = 300
#	var max_attempts = 10
#	var num_towns = 5
#
#	for town_index in range( num_towns):
#		for try in range(max_attempts):
#			var x = randi(0, self.width - 60)
#			var y = randi(0, self.height - 60)
#			var town_coors = Vector2(x, y)
#
#			if Utils.is_town_far_enough(town_coors, min_distance,  towns):
#				var town_size = Vector2(randi() % 21 + 40, randi() % 21 + 40)
#				var town_topleft = Vector2(x, y)
##				house_rectangles = []
##				num_houses = random.randint(3, 6)
##				new_town = Town(x, y, town_size, TOWN_RED, num_houses)
##
##				new_town.place_houses(self.rivers)
##				towns.append(new_town)
#			else:
#				print( "Failed to place town")
#
#func get_town_distances(all_towns, town_center, town_rect, town_index):
#	var distances = []
#	for i in range(all_towns.size()):
#		if i == town_index:
#			continue
#		var other_town = all_towns[i]
#		var distance = town_center.distance_to(other_town.center)
#		distances.append([distance, i])
#	return distances
#
#


#func check_river_collision(new_house, rivers, screen):
#    for river in rivers:
#
#        for i in range(len(river.points) - 1):
#            segment_start = river.points[i]
#            segment_end = river.points[i + 1]
#
#
#            # Create a rectangle representing the river segment
#            segment_rect = pygame.Rect(segment_start, (segment_end[0] - segment_start[0], segment_end[1] - segment_start[1]))
#
#            if pygame.draw.line(screen, (0, 0, 0, 0), segment_start, segment_end).colliderect(new_house):
#
#                return True  # House collides with river segment
#    return False  # No collision with any river segment
#
#class Town(Structure):
#    def __init__(self, x, y, size, color, num_houses):
#        super().__init__(x, y, size, color)
#        self.num_houses = num_houses
#        self.houses = []
#        self.rect = pygame.Rect(self.x, self.y, self.size[0], self.size[1])
#        self.center = (self.x + self.size[0] // 2, self.y +  self.size[1] // 2)
#        self.occupied_by = None  # value of color
#
#    def place_houses(self, rivers):
#        for _ in range(self.num_houses):
#            placed_house = False
#            for _ in range(50):  # Attempt at most 50 times to place a house
#                house_x = random.randint(self.x, self.x + self.size[0] - square_size)
#                house_y = random.randint(self.y, self.y + self.size[1] - square_size)
#                new_house = House(house_x, house_y, 'img/house.png', square_size) # square size is the default size of a square
#
#                # Check for interference with other town rectangles
#                interferes_with_town = any(house.rect.colliderect(new_house.rect) for house in self.houses)
#
#                if not interferes_with_town:
#                    interferes_with_river = check_river_collision(new_house.rect, rivers, screen)
#                    if not interferes_with_river:
#                        self.houses.append(new_house)
#                        placed_house = True
#                        break
#
#            if not placed_house:
#                break  # If failed to place a house 50 times or if it interferes with rivers, break the loop
#
#    def draw_self(self, screen):
#        pygame.draw.rect(screen, TOWN_RED , self.rect)  # Red rectangle for town center with reduced opacity
#
#        if self.occupied_by is   None:
#
#            pygame.draw.rect(screen, BLACK, self.rect, 1)
#        else:
#             pygame.draw.rect(screen, self.occupied_by , self.rect, 2)
#
#    def draw_houses(self, screen):
#        for house in self.houses:
#            house.draw(screen)
#

 

 


 
 
