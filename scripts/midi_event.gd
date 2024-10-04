class_name MidiEvent extends Node

var action: String = ""
var pitch: int = 0
var velocity: int = 0 

func as_string() -> String:
	var result: String = "Midi Event: "
	result += "[" + action + "] "
	result += str(pitch)+ " "
	result += ("{" + str(velocity) + "}")
	return result
