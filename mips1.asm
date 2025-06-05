.data

frase: .asciiz "Hola mundo!"

.text

li $v0,4
la $a0,frase
syscall