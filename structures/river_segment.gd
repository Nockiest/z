class_name RiverSegment
extends Node2D
signal intersects_another_river(this, colliding_area)
var listen_for_river_collision = true

func _on_area_2d_area_entered(area):
	
	## tato funkce potřebuje aby v unit byla area 2d s collision rect
	if area is UnitsMainCollisionArea:
		print("UNIT ENTERED")
		if area.get_parent() == Globals.placed_unit:
			return
		area.get_parent().position = area.get_parent().get_node("movement_comp").abort_movement()
	
	if not listen_for_river_collision:
		return
#	print(area.get_parent().get_parent().get_parent() , get_parent().get_parent() )
#	if not ( area.get_parent() is RiverSegment):
#		return
##	print("FIRST STEP",area.get_parent().get_parent().get_parent(), get_parent().get_parent())
	if  area.get_parent().get_parent().get_parent()  == get_parent().get_parent():
		return
#	print("GOT THROUGH")
#	emit_signal("intersects_another_river", self)
#	queue_free()
	if area.is_in_group("river_segment_collision_shapes"):
		emit_signal("intersects_another_river", self, area)
