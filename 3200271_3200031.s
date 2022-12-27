# Computer Systems Organization
# Winter Semester 2021-2022
# 3rd Assignment
#
# MIPS Code by 
# LEONIDAS PAPPAS 3200271
# STAVROS GIAKOYMIS 3200031 
# ------------------------------------------------------------------
    .text
	.globl main	

main:	

		li $s2,20			# initialize max = 20
		li $s3,$zero,0		# initialize pointer (result = 0) 
		j loop
loop:								# Print postfixInput prompt  
		li $v0,4                # print_string syscall code = 4 
		la	$a0, postfixInput	# load postfix input prompt
		syscall				    # call operating system to perform print operation 	
		li $v0, 12 				# get users input 
		syscall
		move $s0, $v0				#Store input in $t0
		
		jal calc				# call function calc
		
		
pop:	move $v0,$t0
		beq $t0,$zero,invalidPostfix	# if pointer == 0 throw invalid error
		sub $sp,$sp,4					
		sw $v0, ($sp)
		addi $s1, $s1, -1 				# i--
		jr $ra							# return to program
		
		   
push:	


calc:
		bnq $s0,addSign,subTest 	#if input == '+' 
				jal pop						#pop()
				move $s1,$v0				# $s1= $v0
				jal pop						#pop()
				add $a0,$s1,$v0				#$a0 = $s1 + $v0
				jal push					# push $a0
				jr $ra					#return to loop
				
		subTest:
				bnq $s0,minusSign,mulTest 	#if input == '-' 
				jal pop						#pop()
				move $s1,$v0				# $s1= $v0
				jal pop						#pop()
				sub $a0,$s1,$v0				#$a0 = $s1 - $v0
				jal push					# push $a0
				jr $ra						#return to loop

		mulTest:
				bnq $s0,mulSign,divTest   	#if input == '*' 
				jal pop						#pop()
				move $s1,$v0				# $s1= $v0
				jal pop						#pop()
				mul $a0,$s1,$v0				#$a0 = $s1 * $v0
				jal push					# push $a0
				jr $ra						#return to loop

		divTest:
				bnq $s0,divSign,divTest   	#if input == '/' 
				jal pop						#pop()
				move $s1,$v0				# $s1= $v0
				jal pop						#pop()
				beq $v0,$zero,divideByZeroError # goto divideByZeroError , print error and exit
				div $a0,$s1,$v0				#$a0 = $s1 * $v0
				jal push					# push $a0
				jr $ra						#return to loop
				



invalidPostfix: 					# Print error
		li $v0, 4					# print_string syscall code = 4 
		la $a0, invalid  		 	# load invalid postfix prompt
		syscall						# call operating system to perform print operation 	
		j exit
		
divideByZeroError: 
									# Print error
		li $v0, 4					# print_string syscall code = 4 
		la $a0, divideByZeroErrorMsg   # load divideByZeroError prompt
		syscall						# call operating system to perform print operation 	
		j exit

exit:		li $v0,10   			#exit program
			syscall
# ------------------------------------------------------------------	
.data

MAX: .word 20
p: .space 80
postfixInput: .asciiz "Postfix (input): "
result: .asciiz "Postfix Evaluation (output): "
evaluation: .asciiz "Postfix Evaluation: "
invalid: .asciiz "Invalid Postfix"
divideByZeroErrorMsg: .asciiz "Divide by zero"
addSign: .asciiz "+"
subSign: .asciiz "-"
mulSign: .asciiz "*"
divSign: .asciiz "/"
eqSign: .asciiz "="