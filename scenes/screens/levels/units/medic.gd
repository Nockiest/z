class_name Medic
extends SupportUnit

func _ready():
	action_component = $ActionComponent/HealingAction  
	unit_name = "medic"
	super._ready()
