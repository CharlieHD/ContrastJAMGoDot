extends CanvasLayer

var enabled: bool

@onready var mouseState: Label = $PanelContainer/VBoxContainer.get_node("MouseStateLabel")

func _process(_delta: float) -> void:
	mouseState.text = str("Mouse Lock: ", str(Input.mouse_mode))
