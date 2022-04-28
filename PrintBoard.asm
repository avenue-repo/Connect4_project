.data
emptySpace: .asciiz " _ "
playerSpace: .asciiz " X "
computerSpace: .asciiz " 0 "
wall: .asciiz "|"
newLine: .asciiz "\n"

.text

#print the board: goes through arrays for the column and prints the characters for player,
#opponent or empty spaces depending on the value. Needs to be printed row by row. so need 
#to get the first values of each column, and then the second values of each column, etc.
Print:
addi $s0, $s0, 1  #start $s0 at 1, to start printing the first column
add $a0, $s0, $zero #move to arguments to pass to subroutine
jal FindColumn 
add $s5, $v1, $zero #move returned value to $s5

PrintLoop:
add $t4, $s5, $t8 # add row offset to staring address of column array
lw $t5, 0($t4) #get the value at this address

la $a0, wall #print the wall between the spaces
li $v0, 4
syscall

bne $t5, $zero, P1 # if it is equal to 0 it is empty space so print empty space char
la $a0, emptySpace
li $v0, 4
syscall

P1: bne $t5, $s2, P2 #if it is equal to 1 it is a player space, so print the correct char
la $a0, playerSpace
li $v0, 4
syscall
P2: bne $t5, $s3, P3 # if it is equal to 2 it is a opponent space, so print the correct char
la $a0, computerSpace
li $v0, 4
syscall
P3:
sgt $t6, $s0, $s6 #check to see if the whole column has been printed yet
bne $t6, $zero, PrintUpdate #update the row all of the current row has been printed
add $t5, $zero, $zero #if not all columns printed, continue printing current row
j Print

PrintUpdate:
addi $t8, $t8, 4 #update row for next row
srl $t5, $t8, 2
sgt $t6, $t5, $s7 #make sure max rows is not passed

la $a0, wall #print the last wall for the column
li $v0, 4
syscall

la $a0, newLine #print a new line character after each row to make it look like a board
li $v0, 4
syscall
add $s0, $zero, $zero # reset to first column
bne $t6, $zero, PrintEnd #if max rows is passed the entire board is printed
j Print
PrintEnd:
la $a0, newLine #print a new line character after the ascii board prints to differentiate between turns
li $v0, 4
syscall