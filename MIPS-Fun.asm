        .data           # Data segment
Hello:  .asciiz " \n Carrie Cramer \n "  # declare a string containing my name 
AnInt:	.word	17		# a word initialized to 17
space:	.asciiz	" "		# declare a string containing a space 
lf:     .byte	10,0	# string with carriage return and line feed
InLenW:	.word   4       # initialize to number of words in input1 and input2
InLenB:	.word   16      # initialize to number of bytes in input1 and input2
        .align  4
Input1:	.word	0x01020304,0x05060708	# declare an array containing 4 words  
	    .word	0x090A0B0C,0x0D0E0F10
        .align  4
Input2: .word   0x01221117,0x090b1d1f   # declare another array containing 4 words 
        .word   0x0e1c2a08,0x06040210
        .align  4
Copy:  	.space  0x80    # space to copy input word by word
        .align  4
string1: .asciiz "\nThis is the 1st string\n"
		.align	4
string2: .asciiz "\nThis is the 2nd string\n"
		.align	4
merged:	.space	100

############################################################################

        .text                   # code segment
#
# print out my name 
#
main:
        la	$a0,Hello	# address of string to print
        li	$v0,4		# system call code for print_str
        syscall         # print the string

#
# Print the integer value of AnInt
#
	lw	$a0,AnInt	# int to print
	li	$v0,1		# system call code for print_int
	syscall			# print the int
	la	$a0,lf		# address of string to print 
	li	$v0,4		# system call code for print_string
	syscall			# print the space

# 
# Print the integer values of each byte in the array Input1 (with spaces)
#
	li	$t0,0		# loop counter
	lw	$t1,InLenB	# loop limit - the number of bytes in Input1
	la	$t2,Input1	# address of the base of Input1

loop4:				# beginning of loop
	bge	$t0,$t1,done4	# loop check
	lb	$a0,0($t2)	# load integer to print
	li	$v0,1		# system call code for print_int
	syscall			# print the int
	la	$a0,space	# address of string to print (space)
	li	$v0,4		# system call code for print_str
	syscall			# print the string
	add	$t0,$t0,1	# increment loop counter
	add	$t2,$t2,1	# increment address of current element
	j	loop4		# return to loop4
done4:
	la 	$a0,lf  	# load address of lf 
	li	$v0,4		# system call code for print_str 
	syscall 		# print the string 

# 
# Copy the contents of Input2 to Copy
#
	li	$t0,0		# loop counter
	lw	$t1,InLenW 	# loop limit - the number of words in Input2 
	la 	$t2,Input2 	# address of the base of Input2 
	la	$t3,Copy 	# address of the base of Copy 
	
loop5:				# beginning of loop
	bge $t0,$t1,done5 	# loop check 
	lw	$t4,0($t2) 	# load word from Input2 to copy 
	sw 	$t4,0($t3) 	# store word in Copy 
	
	lw	$a0,0($t3) 	# load current element of Copy to $a0 
	li 	$v0,1 		# system call code for print_int 
	syscall 		# print the int 
	
	la 	$a0,space 	# load address of space 
	li	$v0,4		# system call code for print_str 
	syscall 		# print the string 
	
	add $t0,$t0,1	# increment loop counter 
	add $t2,$t2,4 	# increment address of element of Input2 
	add $t3,$t3,4	# increment address of element of Copy  
	j	loop5 		# return to loop5 
done5:

	la 	$a0,lf  	# load address of lf 
	li	$v0,4		# system call code for print_str 
	syscall 		# print the string 
	
	
# 
# Print the integer average of the contents of array Input2
#
	li	$t0,0		# loop counter
	lw	$t1,InLenW 	# loop limit - the number of words in Input2 
	la 	$t2,Input2 	# address of the base of Input2 
	li	$t3,0		# $t3 will be used to sum the elements of Input 2
		
loop6:				# beginning of loop
	bge $t0,$t1,done6 	# loop check 
	lw	$t4,0($t2) 	# load word from Input2 to $t4 
	add $t3,$t3,$t4	# add to sum  
	
	add $t0,$t0,1	# increment loop counter 
	add $t2,$t2,4 	# increment address of element of Input2 
	j	loop6 		# return to loop6
done6:

	div	$t3,$t1 	# divide the sum of Input2's elements by the length
	mflo $t3 		# retrieve the average from $lo 
	
	move $a0,$t3 	# move the average to $a0 
	li 	$v0,1 		# system call code for print_int 
	syscall 		# print the int 
	
	la 	$a0,lf  	# load address of lf 
	li	$v0,4		# system call code for print_str 
	syscall 		# print the string 
	

# 
# Merge string1 and string2, output the result to merged, and print.
# Assume that both strings have the same length.
#
	la 	$t2,string1 # address of string1 
	la 	$t3,string2 # address of string2 
	la 	$t4,merged 	# address of merged 

loop7:				# begin loop - merges strings to merged 
	
	lb 	$t5,0($t2) 	# load 1 char from string1 
	sb	$t5,0($t4) 	# store char in merged  
	add $t4,$t4,1   # increment address of current char in merged 
	
	beqz $t5,done7 # loop check
	
	lb 	$t5,0($t3) 	# load 1 char from string2 
	sb 	$t5,0($t4)  # store char in merged 
	add $t4,$t4,1 	# increment address of current char in merged 
	
	add $t2,$t2,1	# increment address of current char in string1 
	add $t3,$t3,1 	# increment address of current char in string2 
	j	loop7		# return to loop7
done7:

	la	$a0,merged 	# load the address of merged 
	li 	$v0,4		# system call code for print_str 
	syscall 

# 
# Repeat the last step, but do not assume that the strings may have different length.  
# When the shorter string ends, print spaces instead.
#
		
	lb  $t0,space 	# load a space to $t0 
	la 	$t1,string1 # address of string1 
	la 	$t2,string2 # address of string2 
	la 	$t3,merged 	# address of merged 

Loop8:
	lb	  $t4,0($t1)	# load 1 char from string1 
	bnez  $t4,Else1		# branch to Else1 if string1 is not done
	sb	  $t0,0($t3)  	# stores a space in merged 
	add   $t3,$t3,1 	# increments address of merged char 
	lb    $t4,0($t2)    # load 1 char from string2 
	bnez  $t4,Else2		# branch to Else2 if string2 is not done
	j	  Done			# both strings are done 
Else2:
	sb 	  $t4,0($t3) 	# saves a char from string2 to merged 
	add   $t3,$t3,1 	# increments address of merged char 
	add   $t2,$t2,1 	# increments address of string2 char 
	j	  Loop8			# return to beginning
Else1:
	sb 	  $t4,0($t3) 	# saves a char from string1 to merged 
	add   $t3,$t3,1     # increments address of merged char 
	add   $t1,$t1,1 	# increments address of string1 char
	lb 	  $t4,0($t2) 	# load 1 char from string2
	bnez  $t4,Else2		# branch to Else2 if string2 is not done
	sb 	  $t0,0($t3)    # stores a space in merged 
	add   $t3,$t3,1 	# increments address of merged char 
	j	  Loop8 		# return to beginning 
Done:
	
	la	$a0,merged 	# load the address of merged 
	li 	$v0,4		# system call code for print_str 
	syscall 		# print the string 

#
# Print a 5x5 matrix of *'s 
#	
	li $t0,0		# inner loop counter
	li $t1,0 		# outer loop counter 
	li $t2,5 		# loop limit 
		
Loop9:
	bge	$t0,$t2,Loop9b	# if inner loop counter >= 5, jump to Loop9b.  
	li  $a0,'*' 		# load a '*' to $a0 	
	li 	$v0,11 			# system call code for print_char 
	syscall 			# print the char  
	la  $a0,space		# load the address of space to $a0 
	li  $v0,4			# system call code for print_str 
	syscall				# print the space 
	add	$t0,$t0,1 		# increment inner loop counter  
	j 	Loop9 			# return to the beginning of Loop9 
Loop9b:					# Outer Loop 
	la	$a0,lf			# load the address of lf to $a0 
	li 	$v0,4			# system call code for print_str  
	syscall 			# print the newline/carriage return 
	la  $a0,space		# load the address of space to $a0 
	li  $v0,4			# system call code for print_str 
	syscall				# print the space 
	add $t1,$t1,1		# increment outer loop counter
	li 	$t0,0	 		# set the inner loop counter to 0
	bge $t1,$t2,Done9 	# if outer loop is done, brach to Done9 
	j Loop9 			# jump to Loop9
Done9:
	