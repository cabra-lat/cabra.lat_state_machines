# ─── STATE MACHINE CLASS ───────────────────────────────────────────────────────
class_name StateMachine extends AnimationTree

signal state_changed(new_state: String, old_state: String)
signal state_entered(state: String)
signal state_exited(state: String)

var state: String:
    get: return _current_state

var _current_state: String = ""
var _last_state: String = ""
var _initialized: bool = false

func _ready():
    if not Engine.is_editor_hint():
        # Wait a frame before initializing to ensure tree is ready
        call_deferred("_initialize")

func _initialize():
    if active and tree_root:
        _initialized = true
        set_process(true)

        # Godot 4.3 settings
        deterministic = true
        callback_mode_process = ANIMATION_CALLBACK_MODE_PROCESS_IDLE

        print("StateMachine initialized: ", name)

func _process(delta):
    if Engine.is_editor_hint() or not _initialized:
        return
    _update_state()

func _update_state():
    var playback = get("parameters/playback")
    if not playback:
        return

    var new_state = playback.get_current_node()

    if new_state != _current_state and new_state != "":
        _last_state = _current_state
        _current_state = new_state

        if _last_state != "":  # Don't emit for initial state
            state_exited.emit(_last_state)
        state_changed.emit(_current_state, _last_state)
        state_entered.emit(_current_state)

func set_condition(name: String, value):
    if not _initialized:
        return
    self.set("parameters/conditions/" + name, value)

func get_condition(name: String):
    if not _initialized:
        return false
    return self.get("parameters/conditions/" + name)
