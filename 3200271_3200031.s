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

	li $t1,0 				    # initialize result (result = 0) 
			
								# Print postfixInput prompt  
		li $v0,4                # print_string syscall code = 4 
		la	$a0, postfixInput	# load address of string to be printed into $a0
		syscall				    # call operating system to perform print operation 
	
		

	
	
	
pop:
		beq $t0,$zero,invalidPostfix			# if pointer == 0 
		$a0,CRLF						# print error
		li $v0,1
        syscall	
		   
push:


calc:

exit:		li $v0,10   		#exit program
			syscall
invalidPostfix: 							# Print error
		li $v0, 4					# print_string syscall code = 4 
		la $a0, invalid   # load address of string to be printed
		syscall						# call operating system to perform print operation 	
		li $v0,10 					# System exit code = 10
		syscall
		
error_divideByZero: 
									# Print error
		li $v0, 4					# print_string syscall code = 4 
		la $a0, divideByZeroError   # load address of string to be printed
		syscall						# call operating system to perform print operation 	
		li $v0,10 					# System exit code = 10
		syscall


# ------------------------------------------------------------------	
.data

MAX: .word 20
p: .space 80
postfixInput: .asciiz "Postfix (input): "
result: .asciiz "Postfix Evaluation (output): "
evaluation: .asciiz "Postfix Evaluation: "
invalid: .asciiz "Invalid Postfix"
divideByZeroError: .asciiz "Divide by zero"
