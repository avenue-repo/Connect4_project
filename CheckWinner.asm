.data

.text

#Goes through the board to check if any of the win conditions have been met
#Checks for horizontal, vertical, and diagnal win condition
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

CheckWinner:
lw $a3, 0($t4) #value of piece with 4 in a row
#j done #go back up to print the board one more time

done:
add $s0, $zero, $zero  #reset register for player input
add $t8, $zero, $zero #t8 holds the starting row for printing
addi $t9,$zero, 1

