.data
col1: .word 0, 0, 0, 0, 0, 0
col2: .word 0, 0, 0, 0, 0, 0
col3: .word 0, 0, 0, 0, 0, 0
col4: .word 0, 0, 0, 0, 0, 0
col5: .word 0, 0, 0, 0, 0, 0
col6: .word 0, 0, 0, 0, 0, 0
col7: .word 0, 0, 0, 0, 0, 0
# total number of spaces is 42

.text
.globl FindColumn

#find the starting address of the array for the chosen column
#$t0 will get incremented until it matches the number entered
#once it matches the address of the chosen column will be loaded into $s5
FindColumn:
addi $t0, $zero, 1 

bne $a0, $t0, L2
la $v1, col1

L2: addi $t0, $t0, 1
bne $a0, $t0 , L3
la $v1, col2

L3: addi $t0, $t0, 1
bne $a0, $t0 , L4
la $v1, col3

L4: addi $t0, $t0, 1
bne $a0, $t0 , L5
la $v1, col4

L5: addi $t0, $t0, 1
bne $a0, $t0 , L6
la $v1, col5

L6: addi $t0, $t0, 1
bne $a0, $t0 , L7
la $v1, col6

L7: addi $t0, $t0, 1
bne $a0, $t0 , L8
la $v1, col7

L8:
jr $ra
