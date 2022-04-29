#connect 4 program
.data
playerPrompt: .asciiz "Where would you like to play your piece? Pick a column 1-7. "
errorMessage: .asciiz "Input is not in range of the number of columns. Enter an integer between 1-7. "
fullColumn: .asciiz "The column you chose is full. Pick a different column."

count: .word 0 #keeps count of how many moves made

.text
.globl main

main:
lw $s4, count

Loop3:
add $t9, $zero, $zero
add $v0, $zero, $zero
la $a0, playerPrompt #print the prompt for the player
li $v0, 4
syscall
Loop1: #loop until player enters valid input or next turn
li $v0, 5 #wait for player to choose where to play
syscall

#error check to make sure that the player has entered a valid number
#if number is greater than or less than the number of columns print error
add $s0, $v0, $zero #$s0 now holds what the player entered
addi $t0, $zero, 1 #minimun number that can to be entered
addi $t3, $zero, 7 #max number that can to be entered
slt $t1, $s0, $t0 #check greater than min
beq $t1, $zero, Lab1
la $a0, errorMessage #print error message
li $v0, 4
syscall
j Loop1 #go back to player prompt to let player try entering another value
Lab1: 
sgt $t1, $s0, $t3 #check less than max
beq $t1, $zero, checkFull
la $a0, errorMessage #print error message
li $v0, 4
syscall

j Loop1 #go back to player prompt to let player try entering another value
checkFull: #check to see if the column that the player has chosen is already full
add $a0, $s0, $zero
jal FindColumn
add $s5, $v1, $zero
lw $t1, 0($s5)
beq $t1, $zero, Lab2 #if the space at the top of the column is empty then the user can play there
la $a0, fullColumn #print error message if the column is already full
li $v0, 4
syscall
j Loop1 #go back to player prompt to let player try entering another value

Lab2:

addi $t7, $t7, 7 #register that holds the total # of columns
addi $s2, $zero, 1 # value of player space
addi $s3, $zero, 2 #value of computer space
addi $s1, $zero, 1	#Value of player turn (computer:1, player:0)


addi $s6, $zero, 6
addi $s7, $zero, 5
add $a0, $zero, $s0 #put input value into argument to pass to subrouting
jal FindColumn #value will be returned in $v1
add $s5, $zero, $v1 #move returned value to $s5

add $t3, $zero, $zero

#bne $t9, $zero, PrintReturn

Loop2:#check to find an empty row in the chosen column
sll $t3, $t3, 2 #times 4 so word aligned
add $t4, $t3, $s5 #added to column starting address
lw $t5, 0($t4) #get the value at new address
bne $t5, $zero, Lab4 #check to see if its empty by checking if its equal to 0
srl $t3, $t3, 2 #divide by 4
addi $t3, $t3, 1 
sgt $t6, $t3, $s7 #check to make sure it has not gone over the number of rows
bne $t6, $zero, Lab3
j Loop2

Lab4: # value of space was not 0, so there was a piece in that column
srl $t3, $t3, 2 #divide by 4

#found the lowest empty row in the chosen column
# here player can make the move 
#addi $s4, $s4, 1 #incrementing the counter 
Lab3:
subi $t3, $t3, 1 #subtract 1, because piece will need to be placed on top of other pieces
sll $t3, $t3, 2 #times 4 so word aligned
add $t4, $t3, $s5 #add the row offset to the address of the array for the column
beq $s1, $zero, L10		#If $s1 is 1 then sets the space to computer player space
sw $s2, 0($t4) #store the value of a player piece at this location
addi $s4, $s4, 1
j skip
L10:
sw $s3, 0($t4)  #store the value of a player piece
addi $s4, $s4, 1

skip:
.include "CheckWinner.asm"		#Links to file that checks the win conditions

.include "PrintBoard.asm"		#Links to file to print the board

addi $t1, $zero, 4
beq $t2, $t1, chooseWinner #if 4 in a row, last print so choose winner
#check for tie
CheckTie:
addi $a3, $zero, 42
beq $s4, $a3, tiedGame

beq $s1, $zero, L9		#Tests whose turn it is
j ComputerLoop 	#Loops to computer turn if $s1 is 1
L9:				#Loop to let the player take a turn if $s1 is 0
j Loop3

ComputerLoop:			#Generates random number to calculate computer column	
newColumn:
addi $t0, $zero, 1		#initializes $t0 to 1
addi $a1, $zero, 7		#upperbound of random number
addi $v0, $zero, 42
syscall				#generates number from 0-6 and stores in $a0
addi $a0, $a0, 1		#Sets the lower bound to 1 and upper bound to 8

jal FindColumn #value will be returned in $v1
add $s5, $zero, $v1 #move returned value to $s5
add $t4, $s5, $zero
lw $t4, 0($t4) #make sure the column the computer chooses is not full
bne $t4, $zero, newColumn
add $t3, $zero, $zero
addi $s1, $zero, 0		#sets the player turn to player
add $s0, $a0, $zero
j Loop2

#TEST
.include "ChooseWinner.asm"		#Links to file to choose which player won

