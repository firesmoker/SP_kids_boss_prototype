Elements:
	Game Scene:
	# Game logic
		Dumb nodes:
		* Staff
		* Background
	
		Referenced nodes:
		* MusicPlayer (AudioStreamPlayer) that plays the music
		* Notes container node
		* Notes detector node
		* Collectible detector node
		* PlayerCharacter node
		* Boss node
		* PlayerHealthBar node
		* BossHealthBar node
		
		Vars:
		* PlayerHealth var
		* BossHealth var
		* DamageFromBoss var
		* DamageFromPlayer var


		_process():
			# playing the music and moving the notes:
				* if music not playing:
					play
				* AudioStreamPlayer Plays the music
				* Notes container moves to the left by moving its parent node with interpoloation
				using AudioStreamPlayer .get_position() (function)
				* The parent container interpolation should equal the length of the music file.
				(the tempo was already taken into account when constructing the size of the notes
				container)
			
			# finish the level:
				if interpolation >= 1:
					switch to game over scene with:
						retry button - switch to last song scene
						main screen button - switch to starting screen scene
		
		on_note_success_signal():
			BossHealth - DamageFromPlayer
			BossHealthBar.value = BossHealth
			if BossHealth <= 0:
				game_win()
		
		on_hurt_signal():
			PlayerHealth -= DamageFromBoss
			PlayerHealthBar.value = PlayerHealth
			If Health <= 0:
				game_over()
		
		game_over():
			switch to game over screen scene
		
		game_won():
			switch to game won screen scene


	Notes container scene:
	# creating and holding the Notes nodes and collectibles
		* Node type: Rectangle
		* Holds all notes. Construct using JT melody txt file.
		* it should include the rests as well, wether we see them or not.
		* its size should be calculated based on music file length and tempo.
		* Its left part starts at the playing area location
		* Populated from the very left part position
		* the rests and notes should be created and positioned in chronological order from the
			JT melody file, from the left to the right.
		* Contained under a parent node2d called Ending Point. The parent should be positioned
			at the very end (right part) of the Notes container.
		
		_ready():
			* set rectangle size based on music file length and tempo (function)
			* position the left margin at Notes Detector x position and set parent position at the
			right margin (function)
			* populate (function)
		
	
	Notes detector scene based of type Area2D or ShapeCast2D
	# detecting current nodes to be played and changes their state
		* Has current_notes array that appends on each collision, and holds references to the
		note objects themselves
		* collision mask = notes collision layer
		
		_process():
		* if current midi input equals current_notes[0].pitch (correct note played):
		 	change current_notes[0] state to played
		 	pops current_notes[0]
			emit signal note_success
		* if current_notes[0] x position is smaller than notes detector left x margin position:
			change current_notes[0] state to missed
			pops current_notes[0]
		
	
	
	Collectible detector scene, based of Notes Detector (strat by copying notes det scene)
	# collecting collectibles and activating them
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
	
	VFX scene:
		animation player, etc.
	
	PlayerCharacter scene:
		* animation player
		* has both idle and get hit animation
		* has collision for missed notes
		* synced to beat? how?
		* signals HURT on collision with missed notes
		* plays hurt animation on collision with missed notes
	
	Boss scene:
		* animation player
		* synced to beat? how?
		* has both idle and get hit animation
