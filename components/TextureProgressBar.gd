extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".connect("hp_changed", _on_hp_changed) 

	value = get_parent().max_hp
	max_value = get_parent().max_hp


func _on_hp_changed(hp, _prev_hp ):
	value = hp
