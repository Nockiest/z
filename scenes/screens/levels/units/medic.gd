extends SupportUnit

 
func _ready():
	support_action = $ActionComponent/HealingAction  
	unit_name = "medic"
	super._ready()
