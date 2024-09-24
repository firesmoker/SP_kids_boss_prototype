class_name MelodyEvent extends Node

var note: String = "" 
var time: float = 0.0 
var duration: float = 0.0 
var finger: int = 0
var event_type: String = "" 

func as_string() -> String:
	var result: String = "Melody Event: "
	result += "Time: " + str(time) + ", "
	result += "Duration: " + str(duration) + ", "
	result += ("Note: " + note + ", " if note != null else "")
	result += ("Finger: " + str(finger) + ", " if finger != null else "")
	result += ("Event Type: " + event_type + ", " if event_type != null else "")
	return result
