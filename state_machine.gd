@tool
class_name StateMachine extends AnimationTree

signal state_changed(new_state: String, old_state: String)
signal state_entered(state: String)
signal state_exited(state: String)

var _last_state: String = ""

func _ready():
	if not Engine.is_editor_hint():
		_set_transitions_to_auto(tree_root)

func _set_transitions_to_auto(sm: AnimationNodeStateMachine) -> void:
	if sm == null: return
	for i in sm.get_transition_count():
		var trans = sm.get_transition(i)
		if trans:
			trans.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO

func set_condition(name: String, value):
	self["parameters/conditions/" + name] = value

func get_condition(name: String):
	return self.get("parameters/conditions/" + name)

func get_current_state() -> String:
	var current = get("parameters/playback").get_current_node()
	if current != _last_state:
		emit_signal("state_exited", _last_state)
		emit_signal("state_changed", current, _last_state)
		emit_signal("state_entered", current)
		_last_state = current if current else "Start"
	return current if current else "Start"
