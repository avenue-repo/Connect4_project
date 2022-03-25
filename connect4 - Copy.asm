#connect 4 program
.data
col1: .word 0, 0, 0, 0, 0, 0
col2: .word 0, 0, 0, 0, 0, 0
col3: .word 0, 0, 0, 0, 0, 0
col4: .word 0, 0, 0, 0, 0, 0
col5: .word 0, 0, 0, 0, 0, 0
col6: .word 0, 0, 0, 0, 0, 0
col7: .word 0, 0, 0, 0, 0, 0
playerPrompt: .asciiz "Where would you like to play your piece? Pick a column 1-7. "
errorMessage: .asciiz "Input is not in range. Enter an integer between 1-7. "
emptySpace: .asciiz " . "
playerSpace: .asciiz " X "
computerSpace: .asciiz " 0 "
newLine: .asciiz "\n"
.text
Loop3:
add $t9, $zero, $zero
add $v0, $zero, $zero
la $a0, playerPrompt #print the prompt for the player
li $v0, 4
syscall
Loop1: #loop until player enters valid input or next turn
li $v0, 5 #wait for player to choose where to play
syscall

add $s0, $v0, $zero
addi $t0, $zero, 1
addi $t3, $t3, 7
slt $t1, $s0, $t0
beq $t1, $zero, Lab1
la $a0, errorMessage #print error message
li $v0, 4
syscall
j Loop1
Lab1:
sgt $t1, $s0, $t3
beq $t1, $zero, Lab2
la $a0, errorMessage #print error message
li $v0, 4
syscall
j Loop1
Lab2:

addi $t7, $t7, 7
addi $s2, $zero, 1 # value of player space
addi $s3, $zero, 2 #value of computer space


addi $s6, $zero, 6
addi $s7, $zero, 5
FindColumn:
addi $t0, $zero, 1

bne $s0, $t0, L2
la $s5, col1

L2: addi $t0, $t0, 1
bne $s0, $t0 , L3
la $s5, col2

L3: addi $t0, $t0, 1
bne $s0, $t0 , L4
la $s5, col3

L4: addi $t0, $t0, 1
bne $s0, $t0 , L5
la $s5, col4

L5: addi $t0, $t0, 1
bne $s0, $t0 , L6
la $s5, col5

L6: addi $t0, $t0, 1
bne $s0, $t0 , L7
la $s5, col6

L7: addi $t0, $t0, 1
bne $s0, $t0 , L8
la $s5, col7

L8:
add $t3, $zero, $zero

bne $t9, $zero, PrintReturn

Loop2:
sll $t3, $t3, 2
add $t4, $t3, $s5
lw $t5, 0($t4)
bne $t5, $zero, Lab4
srl $t3, $t3, 2
addi $t3, $t3, 1
sgt $t6, $t3, $s7
bne $t6, $zero, Lab3
j Loop2

Lab4:
srl $t3, $t3, 2


Lab3:
subi $t3, $t3, 1
sll $t3, $t3, 2
add $t4, $t3, $s5
sw $s2, 0($t4)

add $s0, $zero, $zero
add $t8, $zero, $zero
addi $t9,$zero, 1
Print:

addi $s0, $s0, 1 
j FindColumn
PrintReturn:
PrintLoop:
#sll $t8, $t8, 2
add $t4, $s5, $t8
lw $t5, 0($t4)
bne $t5, $zero, P1
la $a0, emptySpace
li $v0, 4
syscall
P1: bne $t5, $s2, P2
la $a0, playerSpace
li $v0, 4
syscall
P2: bne $t5, $s3, P3
la $a0, computerSpace
li $v0, 4
syscall
P3:
sgt $t6, $s0, $s6
bne $t6, $zero, PrintUpdate
add $t5, $zero, $zero
j Print
PrintUpdate:
#srl $t8, $t8, 2
addi $t8, $t8, 4
srl $t5, $t8, 2
sgt $t6, $t5, $s7
la $a0, newLine
li $v0, 4
syscall
add $s0, $zero, $zero
bne $t6, $zero, PrintEnd
j Print
PrintEnd:
j Loop3