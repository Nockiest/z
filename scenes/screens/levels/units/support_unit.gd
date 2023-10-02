extends BattleUnit
class_name SupportUnit
@onready var support_action # =$ActionComponent/SupportAction  # i will change this variable in the children
 
#var supporting_state = false
 
func move():
	super.move()
	support_action.supported_entity = null
	
func _on_support_action_invalid_support():
	print("invaliid_action") 
	
func _ready():
	unit_name = "support_unit"
#	action_component = support_action  
#	action_component.support_component_owner = self
#	support_action.support_component_owner = self
	support_action.owner = self
	action_component = support_action
	super._ready()
## override for the supper funcion
func process_action():
	#action_component.toggle_action_screen()
	do_supporting_action()
func do_supporting_action():
	if Globals.action_taking_unit == self:
		support_action.choose_supported()
#		toggle_action_screen()
#func toggle_action_screen():
#	super.toggle_action_screen()
#	if Globals.action_taking_unit == self:
#		Globals.action_taking_unit = null
#	elif Globals.hovered_unit != self:
#		return
#	else:
#		Globals.action_taking_unit = self
#
