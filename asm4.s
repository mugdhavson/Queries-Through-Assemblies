.text

.globl turtle_init

turtle_init:
	# function initialises the Turtle Object values
	# standard_prologue
	addiu	$sp, $sp, -24
	sw	$fp, 0($sp)
	sw	$ra, 4($sp)
	addiu	$fp, $sp, 20
	# $a0 = pointer to Turtle object address
	# $a1 = pointer to the string address
	# set x 0($a0), y 1($a0), dir 2($a0) to zero (character, not an int)
		# the hex number is 0x30 for '0'
	# set the string to the pointer above
	# set odometer to 0 --> 8($a0) -- this is an int, not a char
	
	# NOTE: this is a callee function. It doesn't have to save temporary registers.
	#	It only needs to save $s registers.
	
	add	$t0, $zero, $zero	# $t0 = '0' --> 0 = char, 0 /= int
	
	sb   	$t0, 0($a0)		# using sb since this is a character, taking up only a byte--'x'
	sb	$t0, 1($a0) 		# ---||---  'y'
	sb	$t0, 2($a0)		# ---||---  'dir'
	
	# padding of 1 byte at the 3rd offset
	
	
	
	sw	$a1, 4($a0)		# $a1 is an address (pointer), not a value.
					# you're storing the pointer to the 'name' rather
					# than the value of the 'name' itself
					# this is why it'll take up 4 bytes
					
	add	$t0, $zero, $zero	# $t0 = 0 (int)
	sw	$t0, 8($a0)		# store 0 at the 8th byte
					# it's an integer; it'll take up 4 bytes

	# standard epilogue
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra

#------------------------------------------------------------------------------------------------------#					
.globl turtle_debug

turtle_debug:
	# function initialises the Turtle Object values
	# standard_prologue
	addiu	$sp, $sp, -24
	sw	$fp, 0($sp)
	sw	$ra, 4($sp)
	addiu	$fp, $sp, 20
	# you're printing things out here, so you'll have to save $a0
	
	# need data section: 'Turtle', 'pos', 
	# 'North', 'South', 'East', 'West'
	# 'odometer'
	
.data

TURTLE:
	.asciiz "Turtle \""
	
pos:	
	.asciiz "  pos "
	
North:
	.asciiz "  dir North\n"
	
South:
	.asciiz "  dir South\n"
	
East:
	.asciiz "  dir East\n"
	
West:
	.asciiz "  dir West\n"
	
odometer:

	.asciiz "  odometer "

.text

	add	$t0, $zero, $a0		# $t0 = Turtle obj pointer
	
	addi	$v0, $zero, 4
	la	$a0, TURTLE
	syscall
	
	lw	$t3, 4($t0)			
				
	addi	$v0, $zero, 4		# loading address of the name
	la	$a0, ($t3)		# of the turtle object
	syscall				
	
	addi	$v0, $zero, 11
	addi	$a0, $zero, 0x22	# printing out quotation mark
	syscall
	
	addi	$v0, $zero, 11
	addi	$a0, $zero, 0xa		# printing newline
	syscall
	
	addi	$v0, $zero, 4		# printing "  pos "
	la	$a0, pos
	syscall
	
	# if this doesn't work, change 'lw' to 'lb'
	addi	$v0, $zero, 1		# this is a character
	lb      $a0, 0($t0)	 	# 'x'
	syscall
	
	addi	$v0, $zero, 11		# printing comma
	addi	$a0, $zero, 0x2c		
	syscall
	
	# if this doesn't work, change 'lw' to 'lb'
	addi	$v0, $zero, 1		# this is a character
	lb	$a0, 1($t0)	 	# 'y'
	syscall
	

	addi	$v0, $zero, 11
	addi	$a0, $zero, 0xa		# printing newline
	syscall
	
	# printing the dir depending on the 
	# 2($t0) character
	# store the 2($t0) character in a temporary
	# probably going to use branches
	
	lb 	$t1, 2($t0)		# $t1 = char = [0,3]
	
	add	$t2, $zero, $zero	# this might not work cause 
					# this is 32 bit number and 
					# $t1 is a byte. You might need 
					# to change this to a byte ir 
					# change $t1 to an integer
	
	# 4 branches for seeing if $t1 = [0, 3]
	# starting from 0 = North, it goes clockwise
	# 0 --> North
	# 1 --> East
	# 2 --> South
	# 3 --> West

	beq 	$t1, $t2, N
	addi	$t2, $t2, 1
	
	beq 	$t1, $t2, E
	addi	$t2, $t2, 1
	
	beq 	$t1, $t2, S
	addi	$t2, $t2, 1
	
	beq 	$t1, $t2, W
	
N:
	addi	$v0, $zero, 4
	la	$a0, North
	syscall
	
	j NL

S:
	addi	$v0, $zero, 4
	la	$a0, South
	syscall
	
	j NL

E:
	addi	$v0, $zero, 4
	la	$a0, East
	syscall
	
	j NL

W:
	addi	$v0, $zero, 4
	la	$a0, West
	syscall
	
NL:
#----continuing with normal printing----#
 
	addi	$v0, $zero, 4
	la	$a0, odometer
	syscall
	
	
	addi	$v0, $zero, 1		# printing the distance that
	lw	$a0, 8($t0)		# the turtle has moved
	syscall
	
	addi	$v0, $zero, 11
	addi	$a0, $zero, 0xa		# printing newline
	syscall
	
	addi	$v0, $zero, 11
	addi	$a0, $zero, 0xa		# printing newline
	syscall
	
	# standard epilogue
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra
	
#------------------------------------------------------------------------------------------------------#

.globl turtle_turnLeft

turtle_turnLeft:
	# function turns the turtle left
	# standard_prologue
	addiu	$sp, $sp, -24
	sw	$fp, 0($sp)
	sw	$ra, 4($sp)
	addiu	$fp, $sp, 20
	
	# load the dir into a temporary
	lb 	$t0, 2($a0)
	
	# check if it equals 0
	bne	$t0, $zero, OTHER_LEFT
	
	# change dir to 3
	addi	$t0, $t0, 3
	
	j CHANGE_DIR_L
	
	OTHER_LEFT:
		# reduce dir by 1
		addi	$t0, $t0, -1 
	
	CHANGE_DIR_L:	
	sb	$t0, 2($a0)	
	
	# standard epilogue
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra
	
#------------------------------------------------------------------------------------------------------#

.globl turtle_turnRight

turtle_turnRight:
	# function turns the turtle right
	# standard_prologue
	addiu	$sp, $sp, -24
	sw	$fp, 0($sp)
	sw	$ra, 4($sp)
	addiu	$fp, $sp, 20
	
	# load the dir into a temporary
	lb 	$t0, 2($a0)
	
	# check if it equals 3
	addi	$t1, $zero, 3
	bne	$t0, $t1, OTHER_RIGHT
	
	# change dir to 0
	addi	$t0, $zero, 0
	
	j CHANGE_DIR_R
	
	OTHER_RIGHT:
		# reduce dir by 1
		addi	$t0, $t0, 1 
	
	CHANGE_DIR_R:	
	sb	$t0, 2($a0)
	
	# standard epilogue
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra
	
#------------------------------------------------------------------------------------------------------#

.globl turtle_move

turtle_move:
	# function turns the turtle right
	# standard_prologue
	addiu	$sp, $sp, -24
	sw	$fp, 0($sp)
	sw	$ra, 4($sp)
	addiu	$fp, $sp, 20
	
	# save the turtle pointer into a temporary
	add	$t0, $zero, $a0
	
	# save the intended distance in $s0
	addiu   $sp, $sp, -4
	sw      $s0, 0($sp)
	
	add	$s0, $zero, $a1
	
	# the easy one first: update the odometer by the intended distance
	# you'll need the abs value of the intended distance
	sra 	$t3, $s0, 31   
	xor 	$t1, $s0, $t3   
	sub 	$t1, $t1, $t3
	
	# $t1 = abs(intended distance)
	
	# storing the new distance in the odometer
	lw	$t2, 8($t0)
	add	$t2, $t2, $t1
	sw 	$t2, 8($t0)
	
	# if dir N or S, i.e. 0 or 2
	# then, move y.
	# otherwise move x.
	
	# load dir
	lb	$t4, 2($t0)	# $t4 = dir
	addi	$t5, $zero, 2
	
	div	$t4, $t5
	mfhi	$t5 
	
	beq 	$t5, $zero, CHANGE_Y
	
	# now update the x and y values
	# ------ x ------- #
		# 1. load x value
	lb	$t1, 0($t0)
	add	$t1, $t1, $s0		# x = x(prev) + intended dist
	
	slti	$t2, $t1, 11
	beq	$t2, $zero, SET_TO_TEN_X
	
	slti	$t2, $t1, -10
	bne	$t2, $zero, SET_TO_NEG_TEN_X 
	
	# set x to x(prev) + intended dist / $t1
	sb	$t1, 0($t0)
	
	# jump past the SET_TO_NEG_TEN
	j EXIT_1
	
	SET_TO_TEN_X:
		# set x to +ve 10
		addi	$t3, $zero, 10
		sb	$t3, 0($t0)
		
		j EXIT_1
	
	SET_TO_NEG_TEN_X:
		# set x to -ve 10
		addi	$t3, $zero, -10
		sb  	$t3, 0($t0)
		
		j EXIT_1
	
	
	CHANGE_Y:
	lb	$t1, 1($t0)
	add	$t1, $t1, $s0		# y = y(prev) + intended dist
	
	slti	$t2, $t1, 11
	beq	$t2, $zero, SET_TO_TEN_Y
	
	slti	$t2, $t1, -10
	bne	$t2, $zero, SET_TO_NEG_TEN_Y 
	
	# set x to x(prev) + intended dist / $t1
	sb	$t1, 1($t0)
	
	# jump past the SET_TO_NEG_TEN
	j EXIT_1
	
	SET_TO_TEN_Y:
		# set x to +ve 10
		addi	$t3, $zero, 10
		sb	$t3, 1($t0)
		
		j EXIT_1
	
	SET_TO_NEG_TEN_Y:
		# set x to -ve 10
		addi	$t3, $zero, -10
		sb  	$t3, 1($t0)
	EXIT_1:	
	# standard epilogue
	lw      $s0, 0($sp)
	addiu   $sp, $sp, 4
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra
	
	
#------------------------------------------------------------------------------------------------------#

.globl turtle_searchName

turtle_searchName:
	# standard prologue
	addiu	$sp, $sp, -24
	sw	$fp, 0($sp)
	sw	$ra, 4($sp)
	addiu	$fp, $sp, 20
	
	# gonna save the 3 args into $s registers
	# so I'll save the og values on the stack
	addiu   $sp, $sp, -12
	sw      $s0, 0($sp)
	sw      $s1, 4($sp)
	sw      $s2, 8($sp)
	
	add	$s0, $zero, $a0		# $s0 = Turtle objects array
	add	$s1, $zero, $a1		# $s1 = arr length
	add	$s2, $zero, $a2		# $s2 = needle
	
	# 1. access the name of the first Turtle object
	# 2. send that and the needle to the strcmp
	# if 0, return the array index where the match was found
	# otherwise, continue
	# if none found, at the end return -1
	
	addi	$t0, $zero, 4		# $t0 = offset--> starting with 
					# the first Turtle's object's name
	
	add	$s3, $zero, $zero
	
	LOOP:
		# condition here that checks if the index is greater than arr length
		slt	$t2, $s3, $s1
		beq	$t2, $zero, RETURN_NEG_ONE
		
		add	$t1, $t0, $s0	# address of the first turtle object
		#lw	$t1, ($t0)	# $t1 = the name of the Turtle object
		
		# send to strcmp
		  # have to save the temporaries
		
		#sw      $t2, 8($sp)
		  
		  # have to add $t1 to $a1
		  # have to add $s2 to $a0		
		
		la	$a0, 0($s2)
		la	$a1, 0($t1)
		
		addiu   $sp, $sp, -12
		sw      $t0, 0($sp)
		sw      $t1, 4($sp)
		sw	$t2, 8($sp)
		  
		  # jal instruction
		jal 	strcmp
		  
		add	$s4, $zero, $v0
		  
		  # restore temporaries
		lw 	$t2, 8($sp)
		lw      $t1, 4($sp)
		#lw      $t1, 4($sp)
		lw      $t0, 0($sp)
		addiu   $sp, $sp, 12
		
		  # check the return value
		beq	$s4, $zero, RETURN_INDEX_MATCH
		  # if it is 0, then it's a match | return $s3
		  # if not, then go through the loop
		
		addi	$t0, $t0, 12	# updating offset
		addi	$s3, $s3, 1	# updating the index
		
		j LOOP
		
	RETURN_INDEX_MATCH:
		add	$v0, $zero, $s3
		j EXIT_2
		
	RETURN_NEG_ONE:
		addi	$v0, $zero, -1
	# restore the $s registers to original vals
	EXIT_2:
	lw      $s2, 8($sp)
	lw      $s1, 4($sp)
	lw      $s0, 0($sp)
	addiu   $sp, $sp, 12
	
	# standard epilogue
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
