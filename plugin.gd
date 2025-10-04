@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("StateMachine", "AnimationTree", preload("state_machine.gd"), get_editor_interface().get_base_control().get_theme_icon("AnimationTree", "EditorIcons"))

func _exit_tree():
	remove_custom_type("StateMachine")
