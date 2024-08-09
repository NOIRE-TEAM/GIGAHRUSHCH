extends Area2D

#const Balloon = preload("")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	#var baloon: Node = Balloon.instantiate()
	#get_tree().current_scene.add_child(balloon)
	#baloon.start(dialogue_resource, dialogue_start)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
