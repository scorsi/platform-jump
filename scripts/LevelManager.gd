extends Node


const SCENE_PATH = "res://scenes/"



func change_scene(scene_name):
	call_deferred("_deferred_change_scene", scene_name)


func _deferred_change_scene(scene_name):
	var root = get_tree().get_root()
	root.get_child(root.get_child_count() - 1).free()
	
	var new_scene = ResourceLoader.load(SCENE_PATH + scene_name + ".tscn").instance()
	root.add_child(new_scene)
	get_tree().set_current_scene(new_scene)
