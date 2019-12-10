
	.data
input:	.space	256
output:	.space	256

	.text
	.globl main
main:
	li	$v0, 8			# Ask the user for the string they want to reverse
	la	$a0, input		# We'll store it in 'input'
	li	$a1, 256		# Only 256 chars/bytes allowed
	syscall
	
	li	$v0, 4			# We output the string to verify
	la	$a0, input
	syscall
	
	jal	strlen			# JAL to strlen function, saves return address to $ra
	
	add	$t1, $zero, $v0		# Copy some of our parameters for our reverse function
	add	$t2, $zero, $a0		# We need to save our input string to $t2, it gets
	add	$a0, $zero, $v0		# butchered by the syscall.
	li	$v0, 1			# This prints the length that we found in 'strlen'
	syscall

	
exit:
	li	$v0, 4			# Print
	la	$a0, output		# the string!
	syscall
		
	li	$v0, 10			# exit()
	syscall
	

# strlen:
# a0 is our input string
# v0 returns the length
# -- This function loops over the character array until it encounters
# the null byte, interestingly, the 0x0a character is stored by default
# for input strings requested through the syscall. So we just subtract one
# from the end result.

strlen:
	li	$t0, 0
	li	$t2, 0
	
	strlen_loop:
		add	$t2, $a0, $t0
		lb	$t1, 0($t2)
		beqz	$t1, strlen_exit
		addiu	$t0, $t0, 1
		j	strlen_loop
		
	strlen_exit:
		subi	$t0, $t0, 1
		add	$v0, $zero, $t0
		add	$t0, $zero, $zero
		jr	$ra
	
