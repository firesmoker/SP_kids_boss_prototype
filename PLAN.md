Elements:
	Game Scene:
		* AudioStreamPlayer that plays the music
		* Notes detctor node (scene description below)
		* Collectible detector node, based on notes detector (scene description below)
	
	Notes scenes container scene:
		* Node type: Rectangle
		* Holds all notes. Construct using JT melody txt file.
		* it should include the rests as well, wether we see them or not.
		* its size should be calculated based on music file length and tempo.
		* Its left part starts at the playing area location
		* Populated from the very left part position
		* the rests and notes should be created and positioned in chronological order from the
			JT melody file, from the left to the right.
		* Contained under a parent node2d called Ending Point. The parent should be positioned
			at the very end (right part) of the Notes scenes container.
		
	
	Notes detector scene based of type Area2D or ShapeCast2D
		* Has current_notes array that appends on each collision, and holds references to the 			  note objects themselves
		* collision mask = notes collision layer
		
		_process():
		* if current midi input equals current_notes[0].pitch (correct note played):
		 	change current_notes[0] state to played
		 	pops current_notes[0]
		* if current_notes[0] x position is smaller than notes detector left x margin position:
			change current_notes[0] state to missed
			pops current_notes[0]
		
	
	
	Collectible detector scene, based of Notes Detector (strat by copying notes det scene)
		* Has current_collectibles array that appends on each collision, and holds references to
		the collectible objects themselves
		* collision mask = collectible collision layer
		
		_process():
		* if current midi input equals current_collectibles[0].pitch (correct note played):
		 	activate current_collectibles[0] collected function
		 	pops current_notes[0]
		* if current_collectibles[0] x position is smaller than notes detector left x margin
		position:
			pops current_notes[0]
		
		
	
	Note Scene:
		type property: quarter / half / whole / eigth
		pitch property: C4, F4, etc.
		fingering property: 1 / 2 / 3 / 4 / 5
		golden note property : true / false
		change states and color / play "poof" animation / visibility
			
	Rest Scene:
		* only visual information
	
	Collectible scene:
		* pitch property
		* type property (slowdown / faster / health)
		* visual
		* different collision layer then notes
		
		collected():
			emit type_collected signal
			instantiate matching VFX scene
			queue_free()


game.gd: _ready() function:
	initialize notes scene container (function)


game.gd: _process() function:
	# playing the music and moving the notes:
		* if music not playing:
			play
		* AudioStreamPlayer Plays the music
		* Notes container moves to the left by moving its parent node with interpoloation using
		AudioStreamPlayer .get_position()
		* The parent container interpolation should equal the length of the music file. (the tempo 		was already taken into account when constructing the size of the notes container)
	
	# finish the level:
		if interpolation >= 1:
			switch to ending scene with:
				retry button - switch to last song scene
				main screen button - switch to starting screen scene
