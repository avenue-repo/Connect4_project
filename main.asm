#connect 4 program
.include "board.asm"

.data
col1: .word 0, 0, 0, 0, 0, 0
col2: .word 0, 0, 0, 0, 0, 0
col3: .word 0, 0, 0, 0, 0, 0
col4: .word 0, 0, 0, 0, 0, 0
col5: .word 0, 0, 0, 0, 0, 0
col6: .word 0, 0, 0, 0, 0, 0
col7: .word 0, 0, 0, 0, 0, 0

# total number of spaces is 42
playerPrompt: .asciiz "Where would you like to play your piece? Pick a column 1-7. "
errorMessage: .asciiz "Input is not in range of the number of columns. Enter an integer between 1-7. "
fullColumn: .asciiz "The column you chose is full. Pick a different column."
emptySpace: .asciiz " _ "
playerSpace: .asciiz " X "
computerSpace: .asciiz " 0 "
wall: .asciiz "|"
newLine: .asciiz "\n"
p1Winner: .asciiz "Player 1 won the game!"
p2Winner: .asciiz "Player 2 won the game!"
tie: .asciiz "Tied Game!"
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
checkForWinningMove: #see if someone has made a move to connect 4 in a row
add $t8, $t3, $zero #set conditions for testing
add $t9, $s0, $zero
addi $t2, $zero, 1 
lw $t5, 0($t4)
left: #find out how many matching pieces to the left are connected to this piece
addi $t1, $zero, 7 #check bounds to make sure yu can still check to the left
slt $t0, $t9, $t1
beq $t0, $zero, R #move on if out of bounds
addi $t9, $t9, 1 #increment column to get space to the left in nextcolumn
add $a0, $t9, $zero
jal FindColumn #get the address for the array of the next column
add $t7, $v1, $zero
add $t7, $t7, $t8 #add the row offset
lw $t6, 0($t7)#get the value of the space to the left
bne $t5, $t6, R  #if they do not match move on
add $t6, $t5, $zero
addi $t2, $t2, 1 #increment counter
beq $t2, 4, CheckWinner #if 4 mathcing in a row someone has won
j left#check next piece to the left

R:
add $t8, $t3, $zero#reset testing conditions
add $t9, $s0, $zero
lw $t5, 0($t4)
right: #find how many matching spaces to the right are connected to this space
addi $t1, $zero, 1 #check bounds, move on if not in bounds to check right
sgt $t0, $t9, $t1
beq $t0, $zero, D
addi $t9, $t9, -1 #decrease columns to get space to the right
add $a0, $t9, $zero
jal FindColumn #get the address of the array for this column
add $t7, $v1, $zero
add $t7, $t7, $t8
lw $t6, 0($t7) #add offset and get the value of the space
bne $t5, $t6, D#move on if they do not match
add $t6, $t5, $zero 
addi $t2, $t2, 1 #increment counter
beq $t2, 4, CheckWinner #if 4 matching in a row someone has won
j right #check the next space to the right

D:
add $t8, $t3, $zero #reset testing conditions
add $t9, $s0, $zero
addi $t2, $zero, 1 #reset counter
lw $t5, 0($t4)
down:
addi $t1, $zero, 5 #check bounds
srl $t3, $t3, 2
slt $t0, $t3, $t1
sll $t3, $t3, 2
beq $t0, $zero, LU
addi $t8, $t8, 4 #add 4 to row offset to get next index in array
add $a0, $t9, $zero
jal FindColumn #get the address of the array of the column
add $t7, $v1, $zero
add $t7, $t7, $t8
lw $t6, 0($t7) #find the value of this space
bne $t5, $t6, LU #if they do not match move on
add $t6, $t5, $zero
addi $t2, $t2, 1 #increment counter
beq $t2, 4, CheckWinner #if 4 matching in a row someone has won
j down #check the next space below


LU:
add $t8, $t3, $zero #reset testing conditions
add $t9, $s0, $zero
addi $t2, $zero, 1 
lw $t5, 0($t4)

leftUp:
addi $t1, $zero, 0 #check bounds
srl $t8, $t8, 2
sgt $t0, $t8, $t1
sll $t8, $t8, 2
beq $t0, $zero, RD
addi $t1, $zero, 7
slt $t0, $t9, $t1
beq $t0, $zero, RD
addi $t8, $t8, -4 #decrease 4 for row offset and add 1 to column
addi $t9, $t9, 1
add $a0, $t9, $zero
jal FindColumn #get the address of the column array
add $t7, $v1, $zero
add $t7, $t7, $t8
lw $t6, 0($t7)#get the value of this space
bne $t5, $t6, RD #if they do not match move on
add $t6, $t5, $zero
addi $t2, $t2, 1 #increment counter
beq $t2, 4, CheckWinner #if 4 matching in a row someone has won
j leftUp #get the value of the next space up and to the left

RD:
add $t8, $t3, $zero#reset testing conditions
add $t9, $s0, $zero
lw $t5, 0($t4)

rightDown:
addi $t1, $zero, 5 #check bounds
srl $t8, $t8, 2
slt $t0, $t8, $t1
sll $t8, $t8, 2
beq $t0, $zero, RU
addi $t1, $zero, 1
sgt $t0, $t9, $t1
beq $t0, $zero, RU
addi $t8, $t8, 4 #increase row offset and decrease column
addi $t9, $t9, -1
add $a0, $t9, $zero
jal FindColumn #get the address for the column of this space
add $t7, $v1, $zero
add $t7, $t7, $t8
lw $t6, 0($t7) #get the value of this space
bne $t5, $t6, RU #if they do not match, move on
add $t6, $t5, $zero
addi $t2, $t2, 1 #increment counter
beq $t2, 4, CheckWinner #if 4 mathcing in a row, someone has won
j rightDown #get the value of the next space down and to the right

RU:
add $t8, $t3, $zero #reset testing conditions
add $t9, $s0, $zero
addi $t2, $zero, 1 
lw $t5, 0($t4)

rightUp:
addi $t1, $zero, 0 #check bounds
srl $t8, $t8, 2
sgt $t0, $t8, $t1
sll $t8, $t8, 2
beq $t0, $zero, LD
addi $t1, $zero, 1
sgt $t0, $t9, $t1
beq $t0, $zero, LD
addi $t8, $t8, -4 #decrease column and row offset
addi $t9, $t9, -1
add $a0, $t9, $zero
jal FindColumn #get the address of the column for this array
add $t7, $v1, $zero
add $t7, $t7, $t8
lw $t6, 0($t7)#get the value of the space 
bne $t5, $t6, LD #if they do not match, move on
add $t6, $t5, $zero
addi $t2, $t2, 1 #increment counter
beq $t2, 4, CheckWinner #if 4 mathcing in a row someone has won
j rightUp # get the value of the next space up and to the right

LD:
add $t8, $t3, $zero #reset testing conditions
add $t9, $s0, $zero
lw $t5, 0($t4)

leftDown:
addi $t1, $zero, 5 #check the bounds
srl $t8, $t8, 2
slt $t0, $t8, $t1
sll $t8, $t8, 2
beq $t0, $zero, done
addi $t1, $zero, 7
slt $t0, $t9, $t1
beq $t0, $zero, done
addi $t8, $t8, 4 #increase column and row offset
addi $t9, $t9, 1
add $a0, $t9, $zero
jal FindColumn #get address of the array for this column
add $t7, $v1, $zero
add $t7, $t7, $t8
lw $t6, 0($t7) #get tha value of this space
bne $t5, $t6, done #if they do not match, move on
add $t6, $t5, $zero
addi $t2, $t2, 1 #increment counter
beq $t2, 4, CheckWinner #if counter is 4 then someone won
j leftDown #get the the value of the next space down and to the left

done:
add $s0, $zero, $zero  #reset register for player input
add $t8, $zero, $zero #t8 holds the starting row for printing
addi $t9,$zero, 1

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

ComputerLoop:			#Generates random number to calculate computer column	
newColumn:
addi $t0, $zero, 1		#initializes $t0 to 1
addi $a1, $zero, 7		#upperbound of random number
addi $v0, $zero, 42
syscall				#generates number from 0-6 and stores in $a0
addi $a0, $a0, 1		#Sets the lower bound to 1 and upper bound to 8

#addi $v0, $zero, 1
#syscall

jal FindColumn #value will be returned in $v1
add $s5, $zero, $v1 #move returned value to $s5
add $t4, $s5, $zero
lw $t4, 0($t4) #make sure the column the computer chooses is not full
bne $t4, $zero, newColumn
add $t3, $zero, $zero
addi $s1, $zero, 0		#sets the player turn to player
add $s0, $a0, $zero
j Loop2


CheckWinner:
lw $a3, 0($t4) #value of piece with 4 in a row
j done #go back up to print the board one more time
chooseWinner:
beq $a3, 1, p1Won   #if this space is a player place space the player (player 1) won
j p2Won #else player 2 (the computer) won

tiedGame: # no more empty space left in the board
la $a0, tie #print game tied message
li $v0, 4
syscall
li $v0, 10 #exiting the program 
syscall

p1Won:
la $a0, p1Winner #print player 1 message 
li $v0, 4
syscall

li $v0, 10 #exiting the program 
syscall


p2Won:
la $a0, p2Winner #print player 2 message
li $v0, 4
syscall

li $v0, 10 #exiting the program 
syscall



