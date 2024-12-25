class_name PopupProgressBar extends ProgressBar
@onready var timer: Timer = $PopupTimer
var hide_on_finish: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = timer.wait_time
	timer.connect("timeout",_on_popup_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = timer.time_left

func start_closing_timer(time: float = timer.wait_time, hide_when_finished: bool = hide_on_finish) -> void:
	hide_on_finish = hide_when_finished
	timer.wait_time = time
	max_value = timer.wait_time
	value = timer.wait_time
	timer.start()


func _on_popup_timer_timeout() -> void:
	timer.stop()
	if hide_on_finish:
		self.visible = false
		print("trying to hide self")
