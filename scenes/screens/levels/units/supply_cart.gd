class_name SupplyCart
extends SupportUnit


func _ready():
	action_component = $ActionComponent/ResupplyAction  
	unit_name = "supply_cart"
	super._ready()
 
