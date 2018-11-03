# Division (inefficiently)
# Divides the number in $a0 by $a1
# Stores quotient in $v0, remainder in $v1

# Initialize values with functions we have implemented
addi $a0 $zero 5555
addi $a1 $zero 5

jal divide
j end

divide:
# Check that $a0 is less than $a1
slt $t2 $a0 $a1
bne $t2 $zero except_end

#Initialize registers
add $t0 $zero $a0
addi $t1 $zero 0

loop:
sub $t0 $t0 $a1
addi $t1 $t1 1

#If running subtraction isn't done, loop
slt $t2 $t0 $a1
beq $t2 $zero loop 

add $v0 $zero $t1
add $v1 $zero $t0
jr  $ra

except_end:
addi $v0 $zero 0
add $v1 $zero $a0
jr $ra

end:
j end