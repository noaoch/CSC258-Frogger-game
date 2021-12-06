# Demo for painting 
#
# Bitmap Display Configuration: 
# - Unit width in pixels: 8 
# - Unit height in pixels: 8 
# - Display width in pixels: 256 
# - Display height in pixels: 256 
# - Base Address for Display: 0x10008000 ($gp) 
#
.data
	displayAddress: .word 0x10008000
	frogXY: .word 0:3  # the XY coordinate of the frog, then the direction the frog moved most recently (1=up, 2=down, 3=left, 4=right)
	
	# VehicleRows 1 and 2 are for cars going left
	vehicleRow1to4:	.word 0x708090:128  # array of 128 spots, all reserved for color slate grey
	
	
	#LogRows 1 and 2 are for logs moving left
	logRow1to4:	.word 0x00ffff:128  # array of 128 spots, all currently reserved for aqua
	
	
	LogCarRates:	.word 0:4  # This variable represents the initial cycle counts for logs row 1, row 2, and cars row 1, and row 2, respectively
	
	InitialRound:	.word 0  # this variable stores the round number, player wins when they finish round 2
	
	InitialHealth:	.word 3  # this stores the number of life the frog initially has
	
	InitialScore:	.word 0  # this stores the initial score of the 
	
	Touched:	.word 0:4  # 1st place is whether the extra score power-up is touched, 2nd place is for extra health, 
				   # 3rd place for whether goal region 1 is touched, 4th place for goal region 2
	

.text




#########################################   Prep Work (Not Cycled)   #######################################

# Variables to be resetted when the game restarts

InitializeRound:	lw $t6, InitialRound  # load initial round number (0) into t6

InitializeHealth:	lw $s0, InitialHealth  # load the frog's initial health into s0

InitializeScore:	lw $s5, InitialScore  # load the initial score of the player into s5

InitializeTouched:	la $s4, Touched  # load the address of touched status into t4
			sw $zero, ($s4)  # set the 1st touched status to 0
			sw $zero, 4($s4)  # set the 2nd touched status to 0
			sw $zero, 8($s4)  # set 1st goal region to be untouched
			sw $zero, 12($s4)  # set 2nd goal region to be untouched 




Spawn:	# cycled once, that is, when the player finishes round 1


# These are resetted upon reaching a new round, but not resetted on death or reaching the first area.

IncrementRound:	addi $t6, $t6, 1  # increment the round number by 1

ResetAreasTouched:	sw $zero, 8($s4)  # set 1st goal to be untouched (so it can be touched again on round 2)
			sw $zero, 12($s4)  # set 2nd goal to be untouched
			

# These are resetted upon death, and reaching the first area

ResetVehicleRows:	add $t4, $zero, $zero  # set t4 to 0
			addi $t5, $zero, 128  # set t5 to 128 (count 128 spots)
			la $t7, vehicleRow1to4  # load the address of vehicle rows into t7
			li $s1, 0x708090  # set s1 to store slate grey
			
ResetVehicleRowLoop:	beq $t4, $t5, ResetVehicleRowEnd  # while t4 < t5
			sw $s1, ($t7)  # store slate grey into the memory address
			addi $t7, $t7, 4  # increment t7 by 4 (move on to next unit)
			addi $t4, $t4, 1  # increment counter by 1
			j ResetVehicleRowLoop
			
ResetVehicleRowEnd:



ResetLogRows:	add $t4, $zero, $zero  # set t4 to 0
			addi $t5, $zero, 128  # set t5 to 128 (count 128 spots)
			la $t7, logRow1to4  # load the address of vehicle rows into t7
			li $s1, 0x00ffff  # set s1 to store aqua
			
ResetLogRowLoop:	beq $t4, $t5, ResetLogRowEnd  # while t4 < t5
			sw $s1, ($t7)  # store slate grey into the memory address
			addi $t7, $t7, 4  # increment t7 by 4 (move on to next unit)
			addi $t4, $t4, 1  # increment counter by 1
			j ResetLogRowLoop
			
ResetLogRowEnd:



LoadFrogCoordinates:	la $t2, frogXY  # $t2 stores the X coordinate of the frog's location, and whether frog is on a log
			addi $t4, $zero, 13  # store 13 into t4 (initial X coordinate of frog)
			addi $t5, $zero, 28  # store 28 into t5 (initial Y coordinate of frog)
			sw $t4, ($t2) # store X ccordinate into t2
			sw $t5, 4($t2)  # store Y ccordinate into the next word from t2
			sw $zero, 8($t2)  # set frog to face forward initially
			


	
InitializeRateDivider:	la $t3, LogCarRates   # Load the address of cycles counts into $t3
			sw $zero, ($t3)  # clear the cycle counts for log row 1
			sw $zero, 4($t3)  # clear the cycle counts for log row 2
			sw $zero, 8($t3)  # clear the cycle counts for car row 1
			sw $zero, 12($t3)  # clear the cycle counts for car row 2
			



				

PopulateVehicleRow:	la $t8, vehicleRow1to4  # $t8 holds address of vehicleRow1
			li $s1, 0x6495ed  # Load $s1 with corn flower blue color (car color)
			li $s2, 0xffd700  # load $s2 with gold
			
		# Draw the color of a single vehicle on row1
			sw $s2, 16($t8)
			sw $s1, 20($t8)
			sw $s1, 24($t8)
			sw $s1, 28($t8)
			sw $s1, 32($t8)
			sw $s1, 36($t8)
			sw $s1, 40($t8)
			sw $s1, 44($t8)
		# Draw the color of the 2nd vehicle on row 1
			sw $s2, 80($t8)
			sw $s1, 84($t8)
			sw $s1, 88($t8)
			sw $s1, 92($t8)
			sw $s1, 96($t8)
			sw $s1, 100($t8)
			sw $s1, 104($t8)
			sw $s1, 108($t8)
			
			
			
			li $s3, 0xAFEEEE  # Load pale turquoise color to $s3
		# Draw the color of a single vehicle on row2
			sw $s1, 144($t8)
			sw $s1, 148($t8)
			sw $s3, 152($t8)
			sw $s1, 156($t8)
			sw $s1, 160($t8)
			sw $s1, 164($t8)
			sw $s1, 168($t8)
			sw $s1, 172($t8)
		# Draw the color of the 2nd vehicle on row 2
			sw $s1, 208($t8)
			sw $s1, 212($t8)
			sw $s3, 216($t8)
			sw $s1, 220($t8)
			sw $s1, 224($t8)
			sw $s1, 228($t8)
			sw $s1, 232($t8)
			sw $s1, 236($t8)
			
			
			
			
			li $s1, 0x9370db  # Load $s1 with medium purple (car color)
			li $s3, 0xf0ffff  # Load $s3 with azure 
			li $s2, 0xffa500 # Load $s2 with orange
		# Draw the color of the 1st vehicle on row 3
			sw $s1, 256($t8)
			sw $s1, 260($t8)
			sw $s1, 264($t8)
			sw $s1, 268($t8)
			sw $s1, 272($t8)
			sw $s1, 276($t8)
			sw $s1, 280($t8)
			sw $s2, 284($t8)	
		# Draw the color of the 2nd vehicle on row 3
			sw $s1, 320($t8)
			sw $s1, 324($t8)
			sw $s1, 328($t8)
			sw $s1, 332($t8)
			sw $s1, 336($t8)
			sw $s1, 340($t8)
			sw $s1, 344($t8)
			sw $s2, 348($t8)
			
			
		# Draw the color of the 1st vehicle on row 4
			sw $s1, 384($t8)
			sw $s1, 388($t8)
			sw $s1, 392($t8)
			sw $s1, 396($t8)
			sw $s1, 400($t8)
			sw $s3, 404($t8)
			sw $s1, 408($t8)
			sw $s1, 412($t8)	
		# Draw the color of the 2nd vehicle on row 4
			sw $s1, 448($t8)
			sw $s1, 452($t8)
			sw $s1, 456($t8)
			sw $s1, 460($t8)
			sw $s1, 464($t8)
			sw $s3, 468($t8)
			sw $s1, 472($t8)
			sw $s1, 476($t8)
			
			
			

PopolateLogRow:	la $t9, logRow1to4
			li $s2, 0x8b4513  # Load s2 with saddle brown
			li $s1, 0xcd853f  # load s1 with peru color	
			
			
		# Draw the color of the 1st log on row 1
			sw $s1, 0($t9)
			sw $s1, 4($t9)
			sw $s1, 8($t9)
			sw $s1, 12($t9)
			sw $s1, 16($t9)
			sw $s1, 20($t9)
			sw $s1, 24($t9)
			sw $s2, 28($t9)	
		# Draw the color of the 2nd log on row 1
			sw $s1, 64($t9)
			sw $s1, 68($t9)
			sw $s1, 72($t9)
			sw $s1, 76($t9)
			sw $s1, 80($t9)
			sw $s1, 84($t9)
			sw $s1, 88($t9)
			sw $s2, 92($t9)
			
			
			
		# Draw the color of the 1st log on row 2
			sw $s2, 128($t9)
			sw $s2, 132($t9)
			sw $s2, 136($t9)
			sw $s2, 140($t9)
			sw $s2, 144($t9)
			sw $s2, 148($t9)
			sw $s2, 152($t9)
			sw $s2, 156($t9)	
		# Draw the color of the 2nd log on row 2
			sw $s2, 192($t9)
			sw $s2, 196($t9)
			sw $s2, 200($t9)
			sw $s2, 204($t9)
			sw $s2, 208($t9)
			sw $s2, 212($t9)
			sw $s2, 216($t9)
			sw $s2, 220($t9)
			
			
			
		# Draw the color of the 1st log on row 3
			sw $s1, 288($t9)
			sw $s1, 292($t9)
			sw $s1, 296($t9)
			sw $s1, 300($t9)
			sw $s1, 304($t9)
			sw $s1, 308($t9)
			sw $s1, 312($t9)
			sw $s2, 316($t9)	
		# Draw the color of the 2nd log on row 3
			sw $s1, 352($t9)
			sw $s1, 356($t9)
			sw $s1, 360($t9)
			sw $s1, 364($t9)
			sw $s1, 368($t9)
			sw $s1, 372($t9)
			sw $s1, 376($t9)
			sw $s2, 380($t9)
			
			
			
			
		# Draw the color of the 1st log on row 4
			sw $s2, 416($t9)
			sw $s2, 420($t9)
			sw $s2, 424($t9)
			sw $s2, 428($t9)
			sw $s2, 432($t9)
			sw $s2, 436($t9)
			sw $s2, 440($t9)
			sw $s2, 444($t9)	
		# Draw the color of the 2nd log on row 4
			sw $s2, 480($t9)
			sw $s2, 484($t9)
			sw $s2, 488($t9)
			sw $s2, 492($t9)
			sw $s2, 496($t9)
			sw $s2, 500($t9)
			sw $s2, 504($t9)
			sw $s2, 508($t9)
			
			
			
			
########################################################   Cycled Part   ###################################################################
			

DrawBoard:	lw $t0, displayAddress # $t0 stores the base address for display
		li $t1, 0x90EE90 # $t1 stores the colour code we want to use (now it is light green)
		add $t4, $zero, $zero  # Set $t4 to 0. It is the unit counter 
		addi $t5, $zero, 192   # Set $t5 to 192 (Count 128 units)

Grass1START:	beq $t4, $t5, Grass1END  # while $t4 < $t5
		sw $t1, ($t0)  # paint the unit with grass color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $t0, $t0, 4  # Move on to the next unit
		j Grass1START  # jump back to START	
Grass1END: 	


#=====================================   Draw goal areas   ===================================

	lw $t4, 8($s4)  # load the touch status of 1st goal area
	beq $t4, 1, DrawFilledGoal1  # if area1 is touched, draw frog on it
	
	
	# else, draw empty goal area
DrawEmptyGoal1:	lw $s1, displayAddress # $s1 stores the base address for display
			addi $s1, $s1, 256  # move display to the next row
			li $t1, 0x7fffd4 # $t1 stores the colour code we want to use (now it is dark sea green)
			add $t4, $zero, $zero  # Set $t4 to 0. It is the unit counter 
			addi $t5, $zero, 4   # Set $t5 to 4 (Count 4 rows)

Goal1START:	beq $t4, $t5, Goal1END  # while $t4 < $t5
		sw $t1, 8($s1)  # paint the unit with dark grass color
		sw $t1, 12($s1)  # paint the unit with dark grass color
		sw $t1, 16($s1)  # paint the unit with dark grass color
		sw $t1, 20($s1)  # paint the unit with dark grass color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $s1, $s1, 128  # Move on to the next row
		j Goal1START  # jump back to START	
Goal1END: 	
		j DrawFilledGoal1End  # skip drawing filled goal 1


DrawFilledGoal1:	lw $s1, displayAddress  # s1 stores base address
			addi $s1, $s1, 256  # move display to next row
			li $t1, 0x7fffd4  #t1 stores dark sea green
			li $t4, 0x006400  # Change the color to dark green (frog color)
			li $t5, 0x000000  # Change s1 to black (eye color)
			li $s2, 0x008000  # change s2 to green (frog leg color)
			
			sw $t5, 8($s1)  # frog eye
			sw $t1, 12($s1)  # sea
			sw $t1, 16($s1)  # sea
			sw $t5, 20($s1)  # frog eye
			addi $s1, $s1, 128  # move to next row
			
			sw $t1, 8($s1)  # sea
			sw $t4, 12($s1)  # frog body
			sw $t4, 16($s1)  # frog body
			sw $t1, 20($s1)  # sea
			addi $s1, $s1, 128  # move to next row
			
			sw $s2, 8($s1)  # frog leg
			sw $t4, 12($s1)  # body
			sw $t4, 16($s1)  # body
			sw $s2, 20($s1)  # frog leg
			addi $s1, $s1, 128  # move to next row
			
			sw $s2, 8($s1)  # frog leg
			sw $t4, 12($s1)  # body
			sw $t4, 16($s1)  # body
			sw $s2, 20($s1)  # frog leg
			
DrawFilledGoal1End:
			
	
# Goal area 2:
	lw $t4, 12($s4)  # load the touch status of 2nd goal area
	beq $t4, 1, DrawFilledGoal2  # if area2 is touched, draw frog on it
	
	# else, draw empty goal area
DrawEmptyGoal2:	lw $s1, displayAddress # $s1 stores the base address for display
			addi $s1, $s1, 256  # move display to the next row
			li $t1, 0x7fffd4 # $t1 stores the colour code we want to use (now it is dark sea green)
			add $t4, $zero, $zero  # Set $t4 to 0. It is the unit counter 
			addi $t5, $zero, 4   # Set $t5 to 4 (Count 4 rows)

Goal2START:	beq $t4, $t5, Goal2END  # while $t4 < $t5
		sw $t1, 48($s1)  # paint the unit with dark grass color
		sw $t1, 52($s1)  # paint the unit with dark grass color
		sw $t1, 56($s1)  # paint the unit with dark grass color
		sw $t1, 60($s1)  # paint the unit with dark grass color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $s1, $s1, 128  # Move on to the next row
		j Goal2START  # jump back to START	
Goal2END: 	
		j DrawFilledGoal2End  # skip drawing filled goal 1


DrawFilledGoal2:	lw $s1, displayAddress  # s1 stores base address
			addi $s1, $s1, 256  # move display to next row
			li $t1, 0x7fffd4  #t1 stores dark sea green
			li $t4, 0x006400  # Change the color to dark green (frog color)
			li $t5, 0x000000  # Change s1 to black (eye color)
			li $s2, 0x008000  # change s2 to green (frog leg color)
			
			sw $t5, 48($s1)  # frog eye
			sw $t1, 52($s1)  # sea
			sw $t1, 56($s1)  # sea
			sw $t5, 60($s1)  # frog eye
			addi $s1, $s1, 128  # move to next row
			
			sw $t1, 48($s1)  # sea
			sw $t4, 52($s1)  # frog body
			sw $t4, 56($s1)  # frog body
			sw $t1, 60($s1)  # sea
			addi $s1, $s1, 128  # move to next row
			
			sw $s2, 48($s1)  # frog leg
			sw $t4, 52($s1)  # body
			sw $t4, 56($s1)  # body
			sw $s2, 60($s1)  # frog leg
			addi $s1, $s1, 128  # move to next row
			
			sw $s2, 48($s1)  # frog leg
			sw $t4, 52($s1)  # body
			sw $t4, 56($s1)  # body
			sw $s2, 60($s1)  # frog leg
			
DrawFilledGoal2End:
			
			
			
			
	
	



#   =================================   Draw Score   =========================================

DrawScore:	lw $s1, displayAddress  # set t0 to base display address
		li $t1, 0x6a5acd  # set t1 to slate blue

		beq $s5, 0, DrawScore0   # if player score = 0, draw 0
		beq $s5, 5, DrawScore5	  
		beq $s5, 10, DrawScore10
		beq $s5, 15, DrawScore15
		beq $s5, -5, DrawScoreNeg5
		beq $s5, -10, DrawScoreNeg10
		beq $s5, -15, DrawScoreNeg15
		
DrawScore0:	sw $t1, 112($s1)  # paint slate blue to draw 0
		sw $t1, 116($s1)  # slate blue
		sw $t1, 120($s1)   # slate blue
		
		sw $t1, 240($s1)   # slate blue on row 2
		sw $t1, 248($s1)  # slate blue on row 2
		
		sw $t1, 368($s1)  # slate blue on row 3
		sw $t1, 376($s1)  # slate blue on row 3
		
		sw $t1, 496($s1)  # slate blue on row 4
		sw $t1, 504($s1)  # slate blue on row 4
		
		sw $t1, 624($s1)  # paint slate blue on row 5
		sw $t1, 628($s1)  # slate blue row 5
		sw $t1, 632($s1)  # slate blue row 5
		
		j EndScore   # skip drawing all other scores
		
		
DrawScore5:	sw $t1, 112($s1)  # paint slate blue to draw 0
		sw $t1, 116($s1)  # slate blue
		sw $t1, 120($s1)   # slate blue
		
		sw $t1, 240($s1)   # slate blue on row 2
		
		sw $t1, 368($s1)  # slate blue on row 3
		sw $t1, 372($s1)  # row 3
		sw $t1, 376($s1)  # slate blue on row 3
		
		sw $t1, 504($s1)  # slate blue on row 4
		
		sw $t1, 624($s1)  # paint slate blue on row 5
		sw $t1, 628($s1)  # slate blue row 5
		sw $t1, 632($s1)  # slate blue row 5
		
		j EndScore   # skip drawing all other scores
		
		
		
DrawScore10:	 # Draw the 0 of 10
		sw $t1, 112($s1)  # paint slate blue to draw 0
		sw $t1, 116($s1)  # slate blue
		sw $t1, 120($s1)   # slate blue
		
		sw $t1, 240($s1)   # slate blue on row 2
		sw $t1, 248($s1)  # slate blue on row 2
		
		sw $t1, 368($s1)  # slate blue on row 3
		sw $t1, 376($s1)  # slate blue on row 3
		
		sw $t1, 496($s1)  # slate blue on row 4
		sw $t1, 504($s1)  # slate blue on row 4
		
		sw $t1, 624($s1)  # paint slate blue on row 5
		sw $t1, 628($s1)  # slate blue row 5
		sw $t1, 632($s1)  # slate blue row 5
		
		# Draw the 1 of 10
		sw $t1, 104($s1)  # slate blue row 1
		sw $t1, 232($s1)  # slate blue row 2
		sw $t1, 360($s1)  # slate blue row 3
		sw $t1, 488($s1)  # slate blue row 4
		sw $t1, 616($s1)  # slate blue row 5
		
		j EndScore   # skip drawing all other scores
		
		
		
DrawScore15:	

	# Draw the 5 of 15
		sw $t1, 112($s1)  # paint slate blue to draw 0
		sw $t1, 116($s1)  # slate blue
		sw $t1, 120($s1)   # slate blue
		
		sw $t1, 240($s1)   # slate blue on row 2
		
		sw $t1, 368($s1)  # slate blue on row 3
		sw $t1, 372($s1)  # row 3
		sw $t1, 376($s1)  # slate blue on row 3
		
		sw $t1, 504($s1)  # slate blue on row 4
		
		sw $t1, 624($s1)  # paint slate blue on row 5
		sw $t1, 628($s1)  # slate blue row 5
		sw $t1, 632($s1)  # slate blue row 5
		
	# Draw the 1 of 15
		sw $t1, 104($s1)  # slate blue row 1
		sw $t1, 232($s1)  # slate blue row 2
		sw $t1, 360($s1)  # slate blue row 3
		sw $t1, 488($s1)  # slate blue row 4
		sw $t1, 616($s1)  # slate blue row 5
		
		j EndScore   # skip drawing all other scores
		
		
		
DrawScoreNeg5:	sw $t1, 112($s1)  # paint slate blue to draw 0
		sw $t1, 116($s1)  # slate blue
		sw $t1, 120($s1)   # slate blue
		
		sw $t1, 240($s1)   # slate blue on row 2
		
		sw $t1, 368($s1)  # slate blue on row 3
		sw $t1, 372($s1)  # row 3
		sw $t1, 376($s1)  # slate blue on row 3
		
		sw $t1, 504($s1)  # slate blue on row 4
		
		sw $t1, 624($s1)  # paint slate blue on row 5
		sw $t1, 628($s1)  # slate blue row 5
		sw $t1, 632($s1)  # slate blue row 5
		
		# Draw the neg symbol
		sw $t1, 356($s1)  # slate blue row 3
		sw $t1, 360($s1)  # slate blue row 3
		
		
		j EndScore   # skip drawing all other scores
		
		
		
DrawScoreNeg10:	 # Draw the 0 of 10
		sw $t1, 112($s1)  # paint slate blue to draw 0
		sw $t1, 116($s1)  # slate blue
		sw $t1, 120($s1)   # slate blue
		
		sw $t1, 240($s1)   # slate blue on row 2
		sw $t1, 248($s1)  # slate blue on row 2
		
		sw $t1, 368($s1)  # slate blue on row 3
		sw $t1, 376($s1)  # slate blue on row 3
		
		sw $t1, 496($s1)  # slate blue on row 4
		sw $t1, 504($s1)  # slate blue on row 4
		
		sw $t1, 624($s1)  # paint slate blue on row 5
		sw $t1, 628($s1)  # slate blue row 5
		sw $t1, 632($s1)  # slate blue row 5
		
		# Draw the 1 of 10
		sw $t1, 104($s1)  # slate blue row 1
		sw $t1, 232($s1)  # slate blue row 2
		sw $t1, 360($s1)  # slate blue row 3
		sw $t1, 488($s1)  # slate blue row 4
		sw $t1, 616($s1)  # slate blue row 5
		
		# Draw the Neg symbol
		sw $t1, 348($s1)  # slate blue row 3
		sw $t1, 352($s1)  # slate blue row 3
		
		j EndScore   # skip drawing all other scores
		
		
DrawScoreNeg15:	

	# Draw the 5 of 15
		sw $t1, 112($s1)  # paint slate blue to draw 0
		sw $t1, 116($s1)  # slate blue
		sw $t1, 120($s1)   # slate blue
		
		sw $t1, 240($s1)   # slate blue on row 2
		
		sw $t1, 368($s1)  # slate blue on row 3
		sw $t1, 372($s1)  # row 3
		sw $t1, 376($s1)  # slate blue on row 3
		
		sw $t1, 504($s1)  # slate blue on row 4
		
		sw $t1, 624($s1)  # paint slate blue on row 5
		sw $t1, 628($s1)  # slate blue row 5
		sw $t1, 632($s1)  # slate blue row 5
		
	# Draw the 1 of 15
		sw $t1, 104($s1)  # slate blue row 1
		sw $t1, 232($s1)  # slate blue row 2
		sw $t1, 360($s1)  # slate blue row 3
		sw $t1, 488($s1)  # slate blue row 4
		sw $t1, 616($s1)  # slate blue row 5
		
		# Draw the Neg symbol
		sw $t1, 340($s1)  # slate blue row 3
		sw $t1, 344($s1)  # slate blue row 3
		
		j EndScore   # skip drawing all other scores
			
		
EndScore:

#===========================   Finish Drawing the score   ==============================



		add $s6, $zero, $zero # Set s6 to 0
		addi $s7, $zero, 3 # set s7 (row counter) to 3

LogLoop:	beq $s6, $s7, LogLoopEnd
		add $t7, $zero, $t9  # set t7 to be the array LogRow1
		add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to 32
		
LogRow1Start:	beq $t4, $t5, LogRow1End
		lw $t1, ($t7) # Load the color stored in LogRow1
		sw $t1, ($t0)  # paint the unit with that color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $t7, $t7, 4  # Increment the log row color index by 4
		addi $t0, $t0, 4  # Move on to the next unit
		j LogRow1Start  # jump back to START				
LogRow1End:	addi $s6, $s6, 1 # Increment row counter by 1
		j LogLoop

LogLoopEnd:	addi $t7, $t9, 128  # set t7 to be the array LogRow2
		add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to 32




LogRow2Start:	beq $t4, $t5, LogRow2End
		lw $t1, ($t7) # Load the color stored in LogRow2
		sw $t1, ($t0)  # paint the unit with that color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $t7, $t7, 4  # Increment the log row color index by 4
		addi $t0, $t0, 4  # Move on to the next unit
		j LogRow2Start  # jump back to START		
		
LogRow2End:	add $s6, $zero, $zero # Set s6 to 0
		addi $s7, $zero, 3 # set s7 (row counter) to 3





LogLoop2:	beq $s6, $s7, LogLoop2End
		addi $t7, $t9, 256  # set t7 to be the array LogRow3
		add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to 32
		
LogRow3Start:	beq $t4, $t5, LogRow3End
		lw $t1, ($t7) # Load the color stored in LogRow3
		sw $t1, ($t0)  # paint the unit with that color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $t7, $t7, 4  # Increment the log row color index by 4
		addi $t0, $t0, 4  # Move on to the next unit
		j LogRow3Start  # jump back to START				
LogRow3End:	addi $s6, $s6, 1 # Increment row counter by 1
		j LogLoop2

LogLoop2End:	addi $t7, $t9, 384  # set t7 to be the array LogRow4
		add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to 32
		
		
		
LogRow4Start:	beq $t4, $t5, LogRow4End
		lw $t1, ($t7) # Load the color stored in LogRow4
		sw $t1, ($t0)  # paint the unit with that color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $t7, $t7, 4  # Increment the log row color index by 4
		addi $t0, $t0, 4  # Move on to the next unit
		j LogRow4Start  # jump back to START		
		
LogRow4End:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 128  # Set $t5 to 128	
		li $t1, 0xffe4b5  # Change $t1 to store moccasin color
		
		
SandSTART:	beq $t4, $t5, SandEND  # while $t4 < $t5
		sw $t1, ($t0)  # paint the unit with sandy color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $t0, $t0, 4  # Move on to the next unit
		j SandSTART  # jump back to START			
SandEND: 	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to count 32 units
		add $t7, $zero, $t8  # set $t7 to be the array VehicleRow1
	
	
	
	
Road1Row1START:	beq $t4, $t5, Road1Row1END  # while $t4 < $t5
			lw $t1, ($t7) # Load the color stored in VehicleRow1
			sw $t1, ($t0)  # paint the unit with that color
			addi $t4, $t4, 1  # Increment the counter by 1
			addi $t7, $t7, 4  # Increment the vehicle row color index by 4
			addi $t0, $t0, 4  # Move on to the next unit
			j Road1Row1START  # jump back to START				
Road1Row1END:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to count 32 units
	
					
			
			
Road1Row2START:	beq $t4, $t5, Road1Row2END  # while $t4 < $t5
			lw $t1, ($t7) # Load the color stored in VehicleRow2
			sw $t1, ($t0)  # paint the unit with that color
			addi $t4, $t4, 1  # Increment the counter by 1
			addi $t7, $t7, 4  # Increment the vehicle row color index by 4
			addi $t0, $t0, 4  # Move on to the next unit
			j Road1Row2START  # jump back to START					
Road1Row2END:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to count 32 units
		add $t7, $zero, $t8  # set $t7 to be the array VehicleRow1
		addi $t7, $t7, 128  # increment t7 by a row, to array VehicleRow2
		
	
	
Road1Row3START:	beq $t4, $t5, Road1Row3END  # while $t4 < $t5
			lw $t1, ($t7) # Load the color stored in VehicleRow2
			sw $t1, ($t0)  # paint the unit with that color
			addi $t4, $t4, 1  # Increment the counter by 1
			addi $t7, $t7, 4  # Increment the vehicle row color index by 4
			addi $t0, $t0, 4  # Move on to the next unit
			j Road1Row3START  # jump back to START					
Road1Row3END:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to count 32 units
		add $t7, $zero, $t8  # set $t7 to be the array VehicleRow1



Road1Row4START:	beq $t4, $t5, Road1Row4END  # while $t4 < $t5
			lw $t1, ($t7) # Load the color stored in VehicleRow1
			sw $t1, ($t0)  # paint the unit with that color
			addi $t4, $t4, 1  # Increment the counter by 1
			addi $t7, $t7, 4  # Increment the vehicle row color index by 4
			addi $t0, $t0, 4  # Move on to the next unit
			j Road1Row4START  # jump back to START				
Road1Row4END:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to count 32 units
		add $t7, $zero, $t8  # set $t7 to be the array VehicleRow1
		addi $t7, $t7, 256  # increment t7 by 2 rows, to VehicleRow3
		
		
		
		
Road2Row1START:	beq $t4, $t5, Road2Row1END  # while $t4 < $t5
			lw $t1, ($t7) # Load the color stored in VehicleRow3
			sw $t1, ($t0)  # paint the unit with that color
			addi $t4, $t4, 1  # Increment the counter by 1
			addi $t7, $t7, 4  # Increment the vehicle row color index by 4
			addi $t0, $t0, 4  # Move on to the next unit
			j Road2Row1START  # jump back to START				
Road2Row1END:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to count 32 units
		
		
		

Road2Row2START:	beq $t4, $t5, Road2Row2END  # while $t4 < $t5
			lw $t1, ($t7) # Load the color stored in VehicleRow4
			sw $t1, ($t0)  # paint the unit with that color
			addi $t4, $t4, 1  # Increment the counter by 1
			addi $t7, $t7, 4  # Increment the vehicle row color index by 4
			addi $t0, $t0, 4  # Move on to the next unit
			j Road2Row2START  # jump back to START				
Road2Row2END:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to count 32 units
		addi $t7, $t8, 384  # set $t7 to be the array VehicleRow1, but incremented 3 rows, so it is now at array VehicleRow4




Road2Row3START:	beq $t4, $t5, Road2Row3END  # while $t4 < $t5
			lw $t1, ($t7) # Load the color stored in VehicleRow4
			sw $t1, ($t0)  # paint the unit with that color
			addi $t4, $t4, 1  # Increment the counter by 1
			addi $t7, $t7, 4  # Increment the vehicle row color index by 4
			addi $t0, $t0, 4  # Move on to the next unit
			j Road2Row3START  # jump back to START				
Road2Row3END:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 32  # Set $t5 to count 32 units
		addi $t7, $t8, 256  # set $t7 to be the array VehicleRow3
		
		
		
		
Road2Row4START:	beq $t4, $t5, Road2Row4END  # while $t4 < $t5
			lw $t1, ($t7) # Load the color stored in VehicleRow3
			sw $t1, ($t0)  # paint the unit with that color
			addi $t4, $t4, 1  # Increment the counter by 1
			addi $t7, $t7, 4  # Increment the vehicle row color index by 4
			addi $t0, $t0, 4  # Move on to the next unit
			j Road2Row4START  # jump back to START				
Road2Row4END:	add $t4, $zero, $zero  # Reset $t4 back to 0
		addi $t5, $zero, 192  # Set $t5 to 192
		li $t1, 0x9ACD32  # Change $t1 to store yellow green color	
		
		
		
Grass2START:	beq $t4, $t5, Grass2END  # while $t4 < $t5
		sw $t1, ($t0)  # paint the unit with yellow green color
		addi $t4, $t4, 1  # Increment the counter by 1
		addi $t0, $t0, 4  # Move on to the next unit
		j Grass2START  # jump back to START		
Grass2END: 	
	


#====================================   Draw powerups   ================================

	lw $t4, ($s4)  # load the touch state of extra score
		
	beq $t4, 0, DrawExtraScore  # if extra score is not touched, draw it
	j SkipDrawingExtraScore  # else, skip drawing it


DrawExtraScore:	lw $t0, displayAddress  # Restore $t0 to default display address

	# To get the top-left corner of our powerup:
		li $t4, 26 # load X coordinate into t4
		li $t5, 19 # load Y coordinate into t5
		
		sll $t7, $t5, 5  # store 32 * (Y-coordinate) into $t7
		add $t7, $t7, $t4  # Add X-coordinate to $t7, this is how many units we want to count until we reach the top-left corner
		sll $t7, $t7, 2  # Multiply the number of units we want to shift by 4
		add $t0, $t0, $t7  # Move the display address to the unit we want to start
		li $s1, 0xff00ff  # load s1 with orange
		
		sw $s1, 8($t0)  # draw tip of extra score 
		
		sw $s1, 132($t0)  # draw orange 2nd row
		sw $s1, 136($t0)  # draw orange 2nd row
		sw $s1, 140($t0)  # draw orange 2nd row
		
		sw $s1, 256($t0)  # draw orange 3rd row
		sw $s1, 264($t0)  # draw orange 3rd row
		sw $s1, 272($t0)  # draw orange 3rd row
		
		sw $s1, 392($t0)  # draw 4th row
		sw $s1, 520($t0)  # draw 5th row
		
SkipDrawingExtraScore:	


	lw $t4, 4($s4)  # load the touch state of extra life
	beq $t4, 0, DrawExtraLife  # if extra life is not touched, draw it
	j SkipDrawingExtraLife  # else, skip drawing extra life
	
DrawExtraLife:	lw $t0, displayAddress  # Restore $t0 to default display address
		addi $t0, $t0, 808  # move display address to top left of power up
		li $s1, 0xff0000  # load red to s1
		
		sw $s1, ($t0)  # draw red row 1
		sw $s1, 8($t0)  # draw red row 1
		
		sw $s1, 128($t0)  # draw red row 2
		sw $s1, 132($t0)  # draw red row 2
		sw $s1, 136($t0)  # draw red row 2
		
		sw $s1, 260($t0)  # draw red row 3
		
SkipDrawingExtraLife:






#==================================   Start Drawing frog   ================================
	
	
DrawFrogPrep:	lw $t0, displayAddress  # Restore $t0 to default display address

	# To get the top-left corner of our frog:
		lw $t4, ($t2) # load frog X coordinate into t4
		lw $t5, 4($t2) # load frog Y coordinate into t5
		
		sll $t7, $t5, 5  # store 32 * (Y-coordinate) into $t7
		add $t7, $t7, $t4  # Add X-coordinate to $t7, this is how many units we want to count until we reach the top-left corner
		sll $t7, $t7, 2  # Multiply the number of units we want to shift by 4
		add $t0, $t0, $t7  # Move the display address to the unit we want to start
		
		add $s1, $zero, $zero   # set s1 to 0
		addi $s2, $zero, 4  # set s2 to 4 (count 4 rows)
		add $t7, $zero, $t0  # set t7 to store display address as well
		add $t4, $zero, $zero  # reset t4 to 0
		

DetectCollisionLoop:	beq $s1, $s2, CollisionLoopEnd   # while s1 < s2

				lw $t1, ($t7)  # load the color of 1st frog unit into t1
				beq $t1, 0x6495ed, Annihilation  # if the color on t0 is royal blue, car hits the frog
				beq $t1, 0x9370db, Annihilation  # if the color on t0 is medium purple, car hits frog
				add $t4, $t4, $t1  # add t1 to t4 and store the result in t4
				beq $t1, 0xff00ff, TryAddscore1  # if the color is golden rod, then try to add score
				j Addscore1End  # else, do not add score
				
TryAddscore1:	lw $t5, ($s4)  # load touched status of extra score into t5
		beq $t5, 0, Addscore1  # if its not touched, add score
		j Addscore1End  # else, do not add score


Addscore1:	addi $t5, $zero, 1  # load 1 into t5
		sw $t5, ($s4)  # change extra score to touched
		addi $s5, $s5, 5  # increment current score by 5
		
Addscore1End:			
				beq $t1, 0xff0000, TryAddlife1  # if color is red, try add life
				j Addlife1End  # else, do not add life
				

TryAddlife1:	lw $t5, 4($s4)  # load the touched state of extra life into t5
		beq $t5, 0, Addlife1  # if it is not touched, add life
		j Addlife1End  # else, do not add life			
				
				
Addlife1:	addi $t5, $zero, 1  # load 1 into t5
		sw $t5, 4($s4)  # change extra life to touched
		addi $s0, $s0, 1  # increment current life by 1
		
Addlife1End:	
				
			
				lw $t1, 4($t7)  # load the 2nd frog unit color into t1
				beq $t1, 0x6495ed, Annihilation  # if the color in t1 is royal blue, car hits the frog
				beq $t1, 0x9370db, Annihilation  # if the color in t1 is medium purple, car hits frog
				add $t4, $t4, $t1  # add t1 to t4 and store the result in t4
				
			
				lw $t1, 8($t7)  # load the 3rd frog unit color into t1
				beq $t1, 0x6495ed, Annihilation  # if the color in t1 is royal blue, car hits the frog
				beq $t1, 0x9370db, Annihilation  # if the color in t1 is medium purple, car hits frog
				add $t4, $t4, $t1  # add t1 to t4 and store the result in t4
				
			
				lw $t1, 12($t7)  # load the 4th frog unit color into t1
				beq $t1, 0x6495ed, Annihilation  # if the color in t1 is royal blue, car hits the frog
				beq $t1, 0x9370db, Annihilation  # if the color in t1 is medium purple, car hits frog
				add $t4, $t4, $t1  # add t1 to t4 and store the result in t4
				beq $t1, 0xff00ff, TryAddscore2  # if the color is golden rod, then try to add score
				j Addscore2End  # else, do not add score
				
TryAddscore2:	lw $t5, ($s4)  # load touched status of extra score into t5
		beq $t5, 0, Addscore2  # if its not touched, add score
		j Addscore2End  # else, do not add score


Addscore2:	addi $t5, $zero, 1  # load 1 into t5
		sw $t5, ($s4)  # change extra score to touched
		addi $s5, $s5, 5  # increment current score by 5
		
Addscore2End:			
				beq $t1, 0xff0000, TryAddlife2  # if color is red, try add life
				j Addlife2End  # else, do not add life
				

TryAddlife2:	lw $t5, 4($s4)  # load the touched state of extra life into t5
		beq $t5, 0, Addlife2  # if it is not touched, add life
		j Addlife2End  # else, do not add life			
				
				
Addlife2:	addi $t5, $zero, 1  # load 1 into t5
		sw $t5, 4($s4)  # change extra life to touched
		addi $s0, $s0, 1  # increment current life by 1
		
Addlife2End:	
				
				addi $s1, $s1, 1  # increment s1 by 1
				addi $t7, $t7, 128  # increment t7 by 128 to change to the next row
				j DetectCollisionLoop
				
				
				
				
CollisionLoopEnd:	li $t1, 0x00ffff  # load aqua into t1
			sll $t1, $t1, 4  # load 16 * aqua into t1
			beq $t4, $t1, Annihilation  # if the frog is completely in aqua, it drowns

		li $t1, 0x006400  # Change the color to dark green (frog color)
		li $s1, 0x000000  # Change s1 to black (eye color)
		li $s2, 0x008000  # change s2 to green (frog leg color)
		
		
		
CheckFrogDirection:	lw $t4, 8($t2)  # load the most recent frog direction into t4
			beq $t4, 2, DrawFrogDown  # if frog moved down, draw down frog		
			beq $t4, 3, DrawFrogLeft  # if frog moved left, draw left frog
			beq $t4, 4, DrawFrogRight  # if frog moved right, draw right frog
			j DrawForwardFrog  # else, frog faces forward and so draw forward frog



#################################   All 4 frog directions   ###################################		
	
DrawFrogDown:	addi $t5, $zero, 2 # Initialize $t5 to 2 (Count down 2 units)
		add $t4, $zero, $zero  # set $t4 to 0
BodyLoopDown:	beq $t4, $t5, BodyEndDown  # while t4 < t5:
		sw $s2, ($t0)  # Paint the unit with green color (frog leg)
		sw $t1, 4($t0)  # Paint the next unit with dark green color
		sw $t1, 8($t0)  # also dark green
		sw $s2, 12($t0)  # Paint the other frog leg with green
		addi $t4, $t4, 1  # Increment the counter by 1
		
		addi $t0, $t0, 128  # Go to the unit on the next line with the same x-coordinate
		j BodyLoopDown
		
BodyEndDown:	

FrogBodyDown:	sw $t1, 4($t0)  # paint upper frog body with dark green
		sw $t1, 8($t0)  # paint the next unit with dark green
		addi $t0, $t0, 128  # move to next line on the same x coordinate

FrogEyesDown:	sw $s1, ($t0)  # paint the frog eye
		sw $s1, 12($t0)  # paint the other eye
		j BodyEnd   # Skip drawing all other types of frogs
		
		
		
		
DrawFrogLeft:	
FrogLeftRow1:	sw $s1, ($t0)  # paint frog eye
		sw $s2, 8($t0)  # paint frog leg with green
		sw $s2, 12($t0)  # frog leg as well
		addi $t0, $t0, 128  # move on to the next line

		addi $t5, $zero, 2 # Initialize $t5 to 2 (Count down 2 units)
		add $t4, $zero, $zero  # set $t4 to 0
BodyLoopLeft:	beq $t4, $t5, BodyEndLeft  # while t4 < t5:
		sw $t1, 4($t0)  # Paint the next unit with dark green color
		sw $t1, 8($t0)  # also dark green
		sw $t1, 12($t0)  # also dark green
		addi $t4, $t4, 1  # Increment the counter by 1
		
		addi $t0, $t0, 128  # Go to the unit on the next line with the same x-coordinate
		j BodyLoopLeft
		
BodyEndLeft:	

FrogLeftRow4:	sw $s1, ($t0)  # paint frog eye
		sw $s2, 8($t0)  # paint frog leg with green
		sw $s2, 12($t0)  # frog leg as well
		j BodyEnd  # skip drawing all other types of frogs




DrawFrogRight:	
FrogRightRow1:	sw $s2, ($t0)  # paint frog leg
		sw $s2, 4($t0)  # frog leg as well
		sw $s1, 12($t0)  # frog eye
		addi $t0, $t0, 128  # move on to the next line

		addi $t5, $zero, 2 # Initialize $t5 to 2 (Count down 2 units)
		add $t4, $zero, $zero  # set $t4 to 0
BodyLoopRight:	beq $t4, $t5, BodyEndRight  # while t4 < t5:
		sw $t1, ($t0)  # Paint the 1st unit with dark green color
		sw $t1, 4($t0)  # also dark green
		sw $t1, 8($t0)  # also dark green
		addi $t4, $t4, 1  # Increment the counter by 1
		
		addi $t0, $t0, 128  # Go to the unit on the next line with the same x-coordinate
		j BodyLoopRight
		
BodyEndRight:	

FrogRightRow4:	sw $s2, ($t0)  # paint frog leg
		sw $s2, 4($t0)  # frog leg as well
		sw $s1, 12($t0)  # frog eye
		j BodyEnd  # skip drawing all other frog types
		
		


DrawForwardFrog: # Default frog look
			
FrogEyes:	sw $s1, ($t0)  # paint the frog eye
		sw $s1, 12($t0)  # paint the other eye
		addi $t0, $t0, 128  # move to the next line on the same x coordinate
		
FrogBody:	sw $t1, 4($t0)  # paint upper frog body with dark green
		sw $t1, 8($t0)  # paint the next unit with dark green
		addi $t0, $t0, 128  # move to next line on the same x coordinate
		
		addi $t5, $zero, 2 # Initialize $t5 to 2 (Count down 2 units)
		add $t4, $zero, $zero  # set $t4 to 0
		

				
BodyLoop:	beq $t4, $t5, BodyEnd  # while t4 < t5:
		sw $s2, ($t0)  # Paint the unit with green color (frog leg)
		sw $t1, 4($t0)  # Paint the next unit with dark green color
		sw $t1, 8($t0)  # also dark green
		sw $s2, 12($t0)  # Paint the other frog leg woth green
		addi $t4, $t4, 1  # Increment the counter by 1
		
		addi $t0, $t0, 128  # Go to the unit on the next line with the same x-coordinate
		j BodyLoop
		
BodyEnd:	



#====================================   Draw Health Bar   =====================================
DrawHealthBar:	
		lw $t0, displayAddress  # Set $t0 to default display address
		
		# To get the top-left corner of our health bar:
		li $t4, 2 # load frog X coordinate into t4
		li $t5, 30 # load frog Y coordinate into t5
		
		sll $t7, $t5, 5  # store 32 * (Y-coordinate) into $t7
		add $t7, $t7, $t4  # Add X-coordinate to $t7, this is how many units we want to count until we reach the top-left corner
		sll $t7, $t7, 2  # Multiply the number of units we want to shift by 4
		add $t0, $t0, $t7  # Move the display address to the unit we want to start
		
		li $s1, 0xffffff  # store white into s1
		li $s2, 0xff4500  # store orange red into s2
		
		beq $s0, 3, DrawFullHealth   # if health is 3, draw full health bar
		beq $s0, 2, DrawTwoThirdHealth   # if health is 2, draw 2/3 health
		beq $s0, 1, DrawOneThirdHealth   # if health is 1, draw 1/3 health
		beq $s0, 4, DrawExtraFullHealth  # if health is 4, draw extra full health bar
	
DrawExtraFullHealth:	sw $s2, ($t0)  # draw red
			sw $s2, 4($t0) # red
			sw $s2, 8($t0) # red
			sw $s2, 12($t0) # red
			sw $s2, 16($t0) # red
			sw $s2, 20($t0) # red
			li $s1, 0xff69b4  # draw hot pink
			sw $s1, 24($t0)  # deep pink
			sw $s1, 28($t0)  # deep pink
			j EndDrawHealth  # skip drawing other health bars


DrawFullHealth:	sw $s2, ($t0)  # draw red
			sw $s2, 4($t0) # red
			sw $s2, 8($t0) # red
			sw $s2, 12($t0) # red
			sw $s2, 16($t0) # red
			sw $s2, 20($t0) # red
			j EndDrawHealth  # skip drawing other health bars
			
			
DrawTwoThirdHealth:	sw $s2, ($t0)  # draw red
			sw $s2, 4($t0) # red
			sw $s2, 8($t0) # red
			sw $s2, 12($t0) # red
			sw $s1, 16($t0) # red
			sw $s1, 20($t0) # red
			j EndDrawHealth  # skip drawing other health bars
			
			
DrawOneThirdHealth:	sw $s2, ($t0)  # draw red
			sw $s2, 4($t0) # red
			sw $s1, 8($t0) # red
			sw $s1, 12($t0) # red
			sw $s1, 16($t0) # red
			sw $s1, 20($t0) # red		
	
EndDrawHealth:



		
		

#########################  We finished drawing our screen, now we refresh it  ###############################


Sleep:	li $v0, 32
	li $a0, 16  # Sleep for 16ms after the above lines all execute
	syscall





##################################   Update the logs and cars   ####################################




#=========================  Log Row 1   ==========================

	beq $t6, 1, LoadLogCounterRow1Round1
	beq $t6, 2, LoadLogCounterRow1Round2
	
LoadLogCounterRow1Round1:	addi $t5, $zero, 30  # This is the counter used by log row 1: update the logs on row 1 every 30 cycles, or 480 ms
				j UpdateLogRow1  # skip loading the counter for round 2

LoadLogCounterRow1Round2:	addi $t5, $zero, 5  # This is the counter used by log row 1: update the logs on row 1 every 5 cycles, or 80 ms



	
UpdateLogRow1:	lw $t1, ($t3)  # Load the cycle count for log row 1 in $t3 into $t1
		beq $t1, $t5, ResetLogRow1Counter  # If t1 == t5, reset the counter back to 0 and update the logs
		addi $t1, $t1, 1  # Else: increment the cycle count by 1
		sw $t1, ($t3)  #Store the incremented count back to $t3
		j SkipLogRow1Reset  # Skip resetting log row 1 counter
		
ResetLogRow1Counter:	add $t1, $zero, $zero  # reset $t1 back to 0
			sw $t1, ($t3)  # Store resetted $t1 back into $t3
			
			# Next, we update the first row of logs (move them all to the left by 1 unit
			add $t7, $zero, $t9  # set t7 to be the array log row 1
			
			lw $t1, ($t7)  # Load the first pixel unit stored in log row 1 and store it into $t1
			lw $s1, 128($t7)  # load the first pixel unit in log row 2 and put it in s1
			
			add $t4, $zero, $zero  # Set $t4 to 0 (this is our counter)
			addi $t5, $zero, 31  # Set $t5 to 31, as we want to count 31 units and move them all left by 1 
			
			
UpdateLogRow1Loop:	beq $t4, $t5, EndLogRow1Loop  # while t4 < t5
			
			lw $s2, 4($t7)  # load the 2nd value in log row 1 into s2
			lw $s3, 132($t7)  # load the 2nd value in log row 2 into s3
			sw $s2, ($t7)	# store 2nd value in log row 1 into 1st value
			sw $s3, 128($t7)	# store 2nd value in row 2 into 1st value
			
			addi $t4, $t4, 1  # increment counter by 1
			addi $t7, $t7, 4  # increment log row 1 address by 4 (move 1 unit right)
			j UpdateLogRow1Loop  # jump back
			
EndLogRow1Loop:	sw $t1, ($t7)  # store the original 1st unit in row1 as the last unit
			sw $s1, 128($t7)  # store the original 1st unit in row2 as the last unit
			
			
			
#===============================   Update frog's location on row 1 (Only called when the log moves)   ================================		
			
			lw $t7, 4($t2)  # load the y coordinate of frog into t7
			beq $t7, 6, UpdateFrogRow1  # if the frog is on a log in row1, update its location
			j SkipUpdateFrogRow1   # Else, skip updating the frog's location
			
UpdateFrogRow1:	lw $t4, ($t2)  # load x coordinate of frog into t4
			subi $t4, $t4, 1  # decrement t4 by 1
			sw $t4, ($t2)  # store updated x coordinate back
			
			
SkipUpdateFrogRow1:

			
SkipLogRow1Reset:	# Do nothing


#============================   Log Row 2   ================================
	
	beq $t6, 1, LoadLogCounterRow2Round1
	beq $t6, 2, LoadLogCounterRow2Round2
	
LoadLogCounterRow2Round1:	addi $t5, $zero, 50  # This is the counter used by log row 2: update the logs on row 2 every 50 cycles, or 800 ms
				j UpdateLogRow2  # skip loading the row 2 log counter for round 2
				
LoadLogCounterRow2Round2:	addi $t5, $zero, 10  # This is the counter used by log row 2: update the logs on row 2 every 10 cycles, or 160 ms



	
UpdateLogRow2:	lw $t1, 4($t3)  # Load the cycle count for log row 2 in $t3 into $t1
		beq $t1, $t5, ResetLogRow2Counter  # If t1 == t5, reset the counter back to 0 and update the logs
		addi $t1, $t1, 1  # Else: increment the cycle count by 1
		sw $t1, 4($t3)  #Store the incremented count back to $t3
		j SkipLogRow2Reset  # Skip resetting log row 1 counter
		
ResetLogRow2Counter:	add $t1, $zero, $zero  # reset $t1 back to 0
			sw $t1, 4($t3)  # Store resetted $t1 back into $t3
			
		# Next, we update the second row of logs (move them all to the right by 1 unit)
			addi $t7, $t9, 380  # set t7 to be the end of log row3
			
			lw $t1, ($t7)  # Load the last pixel unit stored in log row 3 and store it into $t1
			lw $s1, 128($t7)  # load the last pixel unit in log row 4 and put it in s1
			
			add $t4, $zero, $zero  # Set $t4 to 0 (this is our counter)
			addi $t5, $zero, 31  # Set $t5 to 31, as we want to count 31 units and move them all left by 1 
			
			
UpdateLogRow2Loop:	beq $t4, $t5, EndLogRow2Loop  # while t4 < t5


			lw $s2, -4($t7)  # load the 2nd-last value in log row 3 into s2
			lw $s3, 124($t7)  # load the 2nd-last value in log row 4 into s3
			sw $s2, ($t7)	# store 2nd-last value in log row 3 into last value
			sw $s3, 128($t7)	# store 2nd-last value in row 4 into last value
			
			addi $t4, $t4, 1  # increment counter by 1
			addi $t7, $t7, -4  # decrement log row 3 address by 4 (move 1 unit left)
			
			j UpdateLogRow2Loop  # jump back
			
EndLogRow2Loop:	sw $t1, ($t7)  # store the original last unit in row3 as the first unit
			sw $s1, 128($t7)  # store the original last unit in row4 as the first unit
			 		
			
			
			
			
#===============================   Update frog's location on row 2   ============================			
			
			lw $t7, 4($t2)  # load the y coordinate of frog into t7
			beq $t7, 10, UpdateFrogRow2  # if the frog is on a log in row2, update its location
			j SkipLogRow2Reset   # Else, skip updating the frog's location
			
UpdateFrogRow2:	lw $t4, ($t2)  # load x coordinate of frog into t4
			addi $t4, $t4, 1  # increment t4 by 1
			sw $t4, ($t2)  # store updated x coordinate back
			
#================================================================================================		
			 		
			
SkipLogRow2Reset:	# Do nothing


	
	
	
	
#============================   Car Row 1   ================================

	beq $t6, 1, LoadCarCounterRow1Round1
	beq $t6, 2, LoadCarCounterRow1Round2
	
LoadCarCounterRow1Round1:	addi $t5, $zero, 20  # This is the counter used by car row 1: update the cars on row 1 every 20 cycles, or 320 ms
				j UpdateCarRow1  # skip loading the counter for round 2

LoadCarCounterRow1Round2:	addi $t5, $zero, 15  # This is the counter used by car row 1: update the cars on row 1 every 15 cycles, or 240 ms



	
UpdateCarRow1:	lw $t1, 8($t3)  # Load the cycle count for car row 1 in $t3 into $t1
		beq $t1, $t5, ResetCarRow1Counter  # If t1 == t5, reset the counter back to 0 and update the cars
		addi $t1, $t1, 1  # Else: increment the cycle count by 1
		sw $t1, 8($t3)  #Store the incremented count back to $t3
		j SkipCarRow1Reset  # Skip resetting car row 1 counter
		
ResetCarRow1Counter:	add $t1, $zero, $zero  # reset $t1 back to 0
			sw $t1, 8($t3)  # Store resetted $t1 back into $t3
			
			# Next, we update the first row of cars (move them all to the left by 1 unit
			add $t7, $zero, $t8  # set t7 to be the array car row 1
			
			lw $t1, ($t7)  # Load the first pixel unit stored in car row 1 and store it into $t1
			lw $s1, 128($t7)  # load the first pixel unit in car row 2 and put it in s1
			
			add $t4, $zero, $zero  # Set $t4 to 0 (this is our counter)
			addi $t5, $zero, 31  # Set $t5 to 31, as we want to count 31 units and move them all left by 1 
			
			
UpdateCarRow1Loop:	beq $t4, $t5, EndCarRow1Loop  # while t4 < t5
			
			lw $s2, 4($t7)  # load the 2nd value in car row 1 into s2
			lw $s3, 132($t7)  # load the 2nd value in car row 2 into s3
			sw $s2, ($t7)	# store 2nd value in car row 1 into 1st value
			sw $s3, 128($t7)	# store 2nd value in row 2 into 1st value
			
			addi $t4, $t4, 1  # increment counter by 1
			addi $t7, $t7, 4  # increment car row 1 address by 4 (move 1 unit right)
			j UpdateCarRow1Loop  # jump back
			
EndCarRow1Loop:	sw $t1, ($t7)  # store the original 1st unit in row1 as the last unit
			sw $s1, 128($t7)  # store the original 1st unit in row2 as the last unit
			 		
			
SkipCarRow1Reset:	# Do nothing




# ==========================   Car Row 2   ==================================
	
	beq $t6, 1, LoadCarCounterRow2Round1
	beq $t6, 2, LoadCarCounterRow2Round2

LoadCarCounterRow2Round1:	addi $t5, $zero, 45  # This is the counter used by car row 2: update the cars on row 2 every 45 cycles, or 720 ms
				j UpdateCarRow2  # Skip loading the counter for round 2

LoadCarCounterRow2Round2:	addi $t5, $zero, 25  # This is the counter used by car row 2: update the cars on row 2 every 25 cycles, or 400 ms


	
UpdateCarRow2:	lw $t1, 12($t3)  # Load the cycle count for car row 2 in $t3 into $t1
		beq $t1, $t5, ResetCarRow2Counter  # If t1 == t5, reset the counter back to 0 and update the cars
		addi $t1, $t1, 1  # Else: increment the cycle count by 1
		sw $t1, 12($t3)  #Store the incremented count back to $t3
		j SkipCarRow2Reset  # Skip resetting car row 2 counter
		
ResetCarRow2Counter:	add $t1, $zero, $zero  # reset $t1 back to 0
			sw $t1, 12($t3)  # Store resetted $t1 back into $t3
			
			# Next, we update the second row of cars (move them all to the right by 1 unit)
			addi $t7, $t8, 380  # set t7 to be the address of the end of car row 3 (128 * 2 + 124 = 380)
			
			lw $t1, ($t7)  # Load the last pixel unit stored in car row 3 and store it into $t1
			lw $s1, 128($t7)  # load the last pixel unit in car row 4 and put it in s1
			
			add $t4, $zero, $zero  # Set $t4 to 0 (this is our counter)
			addi $t5, $zero, 31  # Set $t5 to 31, as we want to count 31 units and move them all left by 1 
			
			
UpdateCarRow2Loop:	beq $t4, $t5, EndCarRow2Loop  # while t4 < t5


			lw $s2, -4($t7)  # load the 2nd-last value in car row 3 into s2
			lw $s3, 124($t7)  # load the 2nd-last value in car row 4 into s3
			sw $s2, ($t7)	# store 2nd-last value in car row 3 into last value
			sw $s3, 128($t7)	# store 2nd-last value in row 4 into last value
			
			addi $t4, $t4, 1  # increment counter by 1
			addi $t7, $t7, -4  # decrement car row 3 address by 4 (move 1 unit left)
			
			j UpdateCarRow2Loop  # jump back
			
EndCarRow2Loop:	sw $t1, ($t7)  # store the original last unit in row3 as the first unit
			sw $s1, 128($t7)  # store the original last unit in row4 as the first unit
			 		
			
SkipCarRow2Reset:	# Do nothing






########################################   Key Board Input   #############################################

	lw $t4, 0xffff0000  # store whether there was an keystroke event into t4
	beq $t4, 1, keyboardInput  # if there was a keystroke event, go to keyboardInput
	j EndInput  # if there was no input, jump to EndInput
	
keyboardInput:	lw $t4, 0xffff0004   # fetch what key was pressed
		beq $t4, 119, respondW  # if w was pressed, go to respondW
		beq $t4, 97, respondA  # if a was pressed, go to respondA
		beq $t4, 115, respondS  # if s was pressed go to respondS
		beq $t4, 100, respondD   # if d was pressed go to respondD
		
respondW:	lw $t5, 4($t2)  # load the frog's current Y coordinate into t5
		subi $t5, $t5, 1  # decrease Y coordinate by 1 
		sw $t5, 4($t2) # store the decremented Y coordinate back
		addi $t4, $zero, 1 # set t4 to 1
		sw $t4, 8($t2)  # set current frog direction to forward
		j EndInput
		

respondA:	lw $t5, ($t2) # load the frog's current X coordinate into t5
		subi $t5, $t5, 1  # decrease X coordinate by 1
		sw $t5, ($t2)  # store decremented X coordinate back
		addi $t4, $zero, 3 # set t4 to 3
		sw $t4, 8($t2)  # set current frog direc to left
		j EndInput
		
		
respondS:	lw $t5, 4($t2)  # load the frog's current Y coordinate into t5
		addi $t5, $t5, 1  # increase th frog's Y coordinate by 1
		sw $t5, 4($t2) # store the incremented Y coordinate back
		addi $t4, $zero, 2  # set t4 to 2
		sw $t4, 8($t2)  # set current frog direc to down
		j EndInput
		
		
respondD:	lw $t5, ($t2) # load the frog's current X coordinate into t5
		addi $t5, $t5, 1  # increase the frog's X coordinate by 1
		sw $t5, ($t2)  # store incremented X coordinate back
		addi $t4, $zero, 4  # set t4 to 4
		sw $t4, 8($t2)  # set current frog direc to right
		j EndInput
	
EndInput:   # Do nothing


CheckYWin:	lw $t4, 4($t2)  # load the y coordinate of the frog into t4
		beq $t4, 2, CheckXArea1Win  # if reached win Y coordinate, check X coordinate
		j DrawBoard  # else skip checking all other things and just redraw board
		
		
CheckXArea1Win:	lw $t4, ($t2)  # load X coordinate into t4
			beq $t4, 2, CheckArea1Filled  # if x=2, check whether area1 is filled
			j CheckXArea2Win  # else, check if frog is in area 2
		
				
		
CheckArea1Filled:	lw $t4, 8($s4)  # load whether area 1 is touched into t4
			beq $t4, 0, FillArea1 # if area 1 is unfilled, fill it
			j DrawBoard  # else we simply redraw board
			
FillArea1:	addi $t4, $zero, 1  # set t4 to 1
		sw $t4, 8($s4)  # set area 1 to be filled
		
		lw $t5, 12($s4)  # check whether area 2 is also filled
		beq $t5, 1, CheckRound  # if both areas are filled, check round to move on to next round or win
		j ResetVehicleRows  # if area 2 is not filled, Spawn another frog without incrementing round counter
		
		
		
		
		
CheckXArea2Win:	lw $t4, ($t2)  # load X coordinate into t4
			beq $t4, 12, CheckArea2Filled  # if x=12, check whether area2 is filled
			j DrawBoard  # else, redraw board
		
		
CheckArea2Filled:	lw $t4, 12($s4)  # load whether area 2 is touched into t4
			beq $t4, 0, FillArea2 # if area 2 is unfilled, fill it
			j DrawBoard  # else we simply redraw board
			
FillArea2:	addi $t4, $zero, 1  # set t4 to 1
		sw $t4, 12($s4)  # set area 2 to be filled
		
		lw $t5, 8($s4)  # check whether area 1 is also filled
		beq $t5, 1, CheckRound  # if both areas are filled, check round to move on to next round or win
		j ResetVehicleRows  # if area 2 is not filled, spawn another frog without incrementing the round counter
		
		
CheckRound:	addi $s5, $s5, 10  # add score by 10
		beq $t6, 1, Spawn  # if the player is at round 1, respawn to round 2
		beq $t6, 2, Exit  # if the player is at round 2, win the game

		
		
####################################   Reactions  (not called unless specified otherwise)   ########################################

Annihilation:	# Draw frog death animation

		lw $t0, displayAddress  # Restore $t0 to default display address

	# To get the top-left corner of our frog:
		lw $t4, ($t2) # load frog X coordinate into t4
		lw $t5, 4($t2) # load frog Y coordinate into t5
		
		sll $t7, $t5, 5  # store 32 * (Y-coordinate) into $t7
		add $t7, $t7, $t4  # Add X-coordinate to $t7, this is how many units we want to count until we reach the top-left corner
		sll $t7, $t7, 2  # Multiply the number of units we want to shift by 4
		add $t0, $t0, $t7  # Move the display address to the unit we want to start
		
		li $t4, 0xff0000  # load t4 with red color
		li $t1, 0x006400  # load t1 with dark green
		li $s1, 0x000000  # Change s1 to black (eye color)
		li $s2, 0x008000  # change s2 to green (frog leg color)
		
		sw $s1, ($t0)  # draw frog eye
		sw $t1, 4($t0)  # load dark green
		sw $t4, 8($t0)  # load blood 
		sw $t4, 132($t0)  # load blood to next row
		sw $t4, 136($t0)  # keep loading blood
		sw $t1, 256($t0)  # load dark green
		sw $t4, 260($t0)  # keep loading blood
		sw $t4, 264($t0)  # blood
		sw $s2, 268($t0)  # green
		sw $t4, 384($t0)  # blood on last row
		sw $t4, 388($t0)  # blood on last row
		sw $t1, 392($t0)  # dark green
		
		li $v0, 32  # call service 32 (sleep)
		li $a0, 250 # sleep for 300 ms
		syscall
		
		sw $s1, -128($t0)  # draw black
		sw $t4, -120($t0)  # blood
		sw $t4, ($t0)  # blood
		sw $t4, 4($t0)  # blood
		sw $t4, 256($t0)  # blood
		sw $t4, 268($t0)  # blood
		sw $t4, 392($t0)  # blood
		sw $t4, 512($t0)  # blood
		sw $t1, 524($t0)  # blood

		
		li $v0, 32  # call service 32 (sleep)
		li $a0, 300 # sleep for 300 ms
		syscall
		
		beq $s0, 1, InitializeRound  # if remaining health is 1, restart the game
		subi $s0, $s0, 1  # otherwise decrement current health by 1
		subi $s5, $s5, 5  # and, decrement the current score by 5
		j ResetVehicleRows  # next, jump back to start without incrementing round counter, and without initializing round
		
			
	
	
	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall 
	
	
	
	
	
