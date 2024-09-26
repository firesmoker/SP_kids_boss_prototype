class_name MelodyEvent extends Node

var time: float = 0.0 
var note: String = "" 
var type: String = "" 
var subtype: String = "" 
var duration: float = 0.0 
var details: Dictionary = {}

func as_string() -> String:
	var result: String = "Melody Event: "
	result += "[" + str(time) + "s] "
	result += ("{" + type)
	result += (" " + subtype + "} " if subtype != "" else "} ")
	result += (" " + note + " " if note != "" else "")
	result += " (:" + str(duration) + "s) "
	result += (" Details: " + str(details) if details.size() > 0 else "")
	return result
