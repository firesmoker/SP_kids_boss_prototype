class_name MelodyEvent extends Node

var time: float = 0.0 
var type: String = "" 
var value: String = "" 
var duration: float = 0.0 
var details: Dictionary = {}

func as_string() -> String:
	var result: String = "Melody Event: "
	result += "[" + str(time) + "s] "
	result += ("{" + type)
	result += (":" + value + "} " if value != "" else "} ")
	result += " (" + str(duration) + ") "
	result += (" Details: " + str(details) if details.size() > 0 else "")
	return result
