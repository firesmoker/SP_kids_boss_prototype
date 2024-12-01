class_name SongBank extends Node

static var example: Dictionary = {
	## Must:
	"title": null,
	"audio_file_path": null,
	"tempo": null,
	
	## Optional:
	"right_melody_path": null, # use at least one melody path
	"left_melody_path": null,
	"ui_type": null,
	"on_display_duration": null,
}

static var believer: Dictionary = {
	"title": "Believer",
	"audio_file_path": "res://audio/Believer_ImagineDragons_110bpm_Vocals_Kids.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_Believer_Reward_Right.txt",
	"tempo": 110,
	"ui_type": "treble",
	"on_display_duration": 2.5,
}

static var pokemon: Dictionary = { # Temp
	"title": "Pokemon (RH)",
	"audio_file_path": "res://audio/Believer_ImagineDragons_110bpm_Vocals_Kids.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_Believer_Reward_Right.txt",
	"tempo": 110,
	"ui_type": "treble",
	"on_display_duration": 2.5,
}

static var the_bare_necessities: Dictionary = { # Temp
	"title": "The Bare Necessities",
	"audio_file_path": "res://audio/BareNecessities_CMajor_115BPM_Vocals_Short.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_TheBareNecessities_TheJungleBook_Reward_Right.txt",
	"tempo": 115,
	"ui_type": "treble",
	"on_display_duration": 2.5,
}

static var enemy_rh: Dictionary = { # Temp
	"title": "Enemy (RH)",
	"audio_file_path": "res://audio/Enemy_AMajor_72_Vocals.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_Enemy_ImagineDragons_Reward_Right.txt",
	"tempo": 72,
	"ui_type": "treble",
	"on_display_duration": 2.5,
}

static var do_you_want_to_build_a_snowman: Dictionary = { # Temp
	"title": "Do You Want To Be a Snowman (LH)",
	"audio_file_path": "res://audio/DoYouWantToBuildASnowman_CMajor_70bpm_Vocals.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_4_DoYouWantToBuildASnowman_Right.txt",
	"left_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_4_DoYouWantToBuildASnowman_Left.txt",
	"tempo": 70,
	"ui_type": "both",
	"on_display_duration": 2.5,
}

static var dance_monkey: Dictionary = { # Temp
	"title": "Dance Monkey (LH)",
	"audio_file_path": "res://audio/DanceMonkey_85.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_4_DanceMonkey_Moving1_Right.txt",
	"left_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_4_DanceMonkey_Moving1_Left.txt",
	"tempo": 85,
	"ui_type": "both",
	"on_display_duration": 2.5,
}

static var safe_and_sound: Dictionary = { # Temp
	"title": "Safe and Sound (LH)",
	"audio_file_path": "res://audio/SafeAndSound_CMajor_96bpm_Vocals.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_4_SafeAndSound_Right.txt",
	"left_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_4_SafeAndSound_Left.txt",
	"tempo": 96,
	"ui_type": "both",
	"on_display_duration": 2.5,
}

static var to_gun_anthem: Dictionary = { # BROKEN!
	"title": "To Gun Anthem (BH)",
	"audio_file_path": "res://audio/Believer_ImagineDragons_110bpm_Vocals_Kids.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_4_SafeAndSound_Right.txt",
	"left_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_4_SafeAndSound_Left.txt",
	"tempo": 110,
	"ui_type": "both",
	"on_display_duration": 2.5,
}

static var enemy_bh: Dictionary = { # HAS EIGTH!
	"title": "Enemy (BH)",
	"audio_file_path": "res://audio/Enemy_AMajor_72_Vocals.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_Enemy_ImagineDragons_Right.txt",
	"left_melody_path": "res://levels/Library_PianoBasics2_Enemy_ImagineDragons_Left.txt",
	"tempo": 72,
	"ui_type": "both",
	"on_display_duration": 3,
}

static var ole_ole_ole_ole: Dictionary = { # Temp
	"title": "OLE OLE OLE OLE (BH)",
	"audio_file_path": "res://audio/OleOleOleOle_WorldCup2022_C_130_Kids_TempoRush.ogg",
	"right_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_OLEOLEOLEOLE_Moving1_Right.txt",
	"left_melody_path": "res://levels/Library_PianoBasics2_KidsMVPContentTest_OLEOLEOLEOLE_Moving1_Left.txt",
	"tempo": 130,
	"ui_type": "both",
	"on_display_duration": 2.5,
}
