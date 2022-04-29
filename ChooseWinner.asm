.data
p1Winner: .asciiz "Player 1 won the game!"
p2Winner: .asciiz "Player 2 won the game!"
tie: .asciiz "Tied Game!"

.text

#Determines which player won the game and prints out the accordning message
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