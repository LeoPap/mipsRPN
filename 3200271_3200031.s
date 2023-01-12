# Computer Systems Organization
# Winter Semester 2021-2022
# 3rd Assignment
#
# MIPS Code by 
# LEONIDAS PAPPAS 3200271
# STAVROS GIAKOYMIS 3200031 
# ------------------------------------------------------------------
    .text
	.globl __start

__start:	

		
		li $s1,0		   		# initialize i (i = 0) (pointer)
		li $v0,4                # print_string syscall code = 4 
		la	$a0, postfixInput	# load postfix input prompt
		syscall					# call operating system to perform print operation
parentLoop:						# Print postfixInput prompt  
					    	
		li $v0, 12 				# get users input 
		syscall
		move $t0,$v0			# Store input in $t0
		beq $t0,eqSign,printResult
		bnq $t0,space,childLoop		# if input != ' ' goto childLoop
		li $v0, 12 				# get users input 
		syscall
		move $t0, $v0			# Store input in $t0
		li $s4,$zero			# number = 0
		beq $t0,space,parentLoop# if input != ' ' goto childLoop
		j childLoop             # go to childLoop
		
childLoop:		
		li $v0, 12 				# get users input 
		syscall
		move $t0, $v0			# Store input in $t0
		beq $t0, space,parentLoop# if input is ' ' goto parentLoop
		beq $t0,eqSign,printResult
		blt $t0, zero,exitLoop	# if ch < 0 goto exitLoop
		bge $t0, nine,exitLoop  # if ch > 9 goto exitLoop
		mul $s4, $s4, 10		# number *= 10
		sub $t0, $t0, 48		# ch -= 48
		add $s4, $s4, $t0		# number += ch
		
		j childLoop

exitLoop:
		jal calc				# call function calc
		j parentLoop			# go to parentLoop

printResult:
		bne $s1, 1,invalidPostfix # if i <> 1 throw invalidPostfix error
								  # else
		li $v0,4                  # print_string syscall code = 4 
		la	$a0, postfixEvaluation# load postfix evaluation prompt
		syscall					  # call operating system to perform print operation
		li $v0,11 				  # print result
		lw $t3,(

pop:	move $v0,$t2
			beq $t0,$zero,invalidPostfix	# if i == 0 throw invalid error
			lw $t4, ($sp)					# pop top
			add $sp,$sp,4					
			
			addi $s1, $s1, -1 				# i--
			jr $ra							# return to program
			
			   
push:		beq $s1, MAX, overflowError 	# if i = MAX throw overflow error			
			sub $sp,$sp,4					
			sw   $a0, 0($s0)				# push a0
			addi $s1, $s1, 1				# i++
			jr $ra							# return to program

calc:										# Calc function
		bnq $t0,addSign,subTest 			# if input == '+' 
				jal pop						# pop()
				move $s2,$v0				# $s1= $v0
				jal pop						# pop()
				add $a0,$s2,$v0				# $a0 = $s1 + $v0
				jal push					# push $a0
				jr $ra						# return to loop
				
		subTest:
				bnq $t0,minusSign,mulTest 	# if input == '-' 
				jal pop						# pop()
				move $s2,$v0				# $s1= $v0
				jal pop						# pop()
				sub $a0,$s2,$v0				# $a0 = $s2 - $v0
				jal push					# push $a0
				jr $ra						# return to loop

		mulTest:
				bnq $t0,mulSign,divTest   	# if input == '*' 
				jal pop						# pop()
				move $s2,$v0				# $s2= $v0
				jal pop						# pop()
				mul $a0,$s2,$v0				# $a0 = $s2 * $v0
				jal push					# push $a0
				jr $ra						# return to loop

		divTest:
				bnq $t0,divSign,divTest   	# if input == '/' 
				jal pop						# pop()
				move $s2,$v0				# $s2= $v0
				jal pop						# pop()
				beq $v0,$zero,divideByZeroError # goto divideByZeroError , print error and exit
				div $a0,$s2,$v0				# $a0 = $s2 * $v0
				jal push					# push $a0
				jr $ra						# return to loop
				



invalidPostfix: 					# Print error
		li $v0, 4					# print_string syscall code = 4 
		la $a0, invalid  		 	# load invalid postfix prompt
		syscall						# call operating system to perform print operation 	
		j exit
		
divideByZeroError: 
									# Print error
		li $v0, 4					# print_string syscall code = 4 
		la $a0, divideByZeroErrorMsg# load divideByZeroError prompt
		syscall						# call operating system to perform print operation 	
		j exit
		
overflowError: 
									# Print error
		li $v0, 4					# print_string syscall code = 4 
		la $a0, overflowErrorMsg    # load divideByZeroError prompt
		syscall						# call operating system to perform print operation 	
		j exit

exit:		li $v0,10   			#exit program
			syscall
# ------------------------------------------------------------------	
.data

MAX: .word 20
p: .space 80
zero: .byte '0'
nine: .byte '9'
postfixInput: .asciiz "Postfix (input): "
result: .asciiz "Postfix Evaluation (output): "
evaluation: .asciiz "Postfix Evaluation: "
invalid: .asciiz "Invalid Postfix"
divideByZeroErrorMsg: .asciiz "Divide by zero"
overflowErrorMsg: .asciiz "Overflow error"
addSign: .byte '+'
subSign: .byte '-'
mulSign: .byte '*'
divSign: .byte '/'
eqSign: .byte '='
space: .byte ' '