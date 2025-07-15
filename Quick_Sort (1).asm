.data
	vector : .word 4,5,6,2,1,8,1,4,98,2,30
	n: .word 11

	str_arr_init: .asciiz "["
	str_arr_md: .asciiz " "
	str_arr_fin: .asciiz "]\n"

.text

	main:

	
	la $a0, vector
	lw $a1, n
	jal mostrar_lista
	

	la $a0, vector
	add $a1, $zero, $zero
	lw $a2, n
	sub $a2, $a2, 1
	jal quicksort
	
	la $a0, vector
	lw $a1, n
	jal mostrar_lista
	
	li $v0, 10
	syscall


swap:
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)

	mul $t6, $a1, 4
	mul $t7, $a2, 4
	
	add $t6, $a0, $t6
	add $t7, $a0, $t7

	
	lw $s7, 0($t6) 
	lw $s6, 0($t7) 
	sw $s7, 0($t7)
	sw $s6, 0($t6)

	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	jr $ra



partition:
	
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	# direccion de memoria el array
	move $t0, $a0
	# low
	move $t1, $a1
	# high
	move $t2, $a2
	
	# multiplcamos para llegar al indice
	mul $t3, $t2, 4
	
	add $t0, $t0, $t3
	
	#pivot
	lw $s0, 0($t0) 
	
	sub $t0, $t0, $t3
	
	#indice el elemento mas pequeño
	sub $s1, $t1, 1
	
	#preparando los valor para el for
	# la j de for
	move $s2, $t1
	
	sub $t4, $t2, 1
	for:
		bgt $s2, $t4, fin_for
		
		mul $t3, $s2, 4
	 	add $t0, $t0, $t3
	 	#pivot
		lw $t5, 0($t0) 
	
		sub $t0, $t0, $t3
	 	
	 	if_for_swap:
	 		bgt $t5, $s0, fin_if_for_swap
	 		add $s1, $s1, 1 
	 		
	 		move $a1, $s1
	 		move $a2, $s2
	 		jal swap
	 	
	 	fin_if_for_swap:
	
		add $s2, $s2, 1
	
		j for
	fin_for:


	add $s1, $s1, 1
	move $a1, $s1
	move $a2, $t2
	jal swap

	move $v0, $s1

	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	
	jr $ra




quicksort:
	addi $sp, $sp, -16
	sw $a0, 0($sp)	#array
	sw $a1, 4($sp)	#low
	sw $a2, 8($sp)	#high
	sw $ra, 12($sp)
	
	add $t1, $a2, 1
	if:
		bgt $a1, $a2, end_if
		
		jal partition
		
		move $t0, $a2
		sub $a2, $v0, 1
		jal quicksort
		
		add $a1, $a2, 2
		move $a2, $t0
		jal quicksort
		
	
	end_if:
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16

	jr $ra

mostrar_lista:
	
	move $t0, $a0        # Guardar dirección del arreglo
    	move $t1, $a1        # Guardar tamaño
    	li $t2, 0            # Inicializar contador
		
	# imprime =>  [
	li $v0, 4
	la $a0, str_arr_init
	syscall
	
	
	while:
	#cuando #t1 == #a1 va a ir exit_while
	beq $t1, $t2, exit_while 
	
	
	
	# imprime => " " solo un espacio en blanco xD
	li $v0, 4
	la $a0, str_arr_md
	syscall
	
	#imprimos el valor
	li $v0, 1
	# cargamos el valor de intArray[$t1] a $t0 
	lw $a0, 0($t0)
	syscall

	
	# sumamos en a nuestro indice $t1 + 4 
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	
	j while
	
exit_while:
	
	# imprime => " " solo un espacio en blanco xD
	li $v0, 4
	la $a0, str_arr_md
	syscall

	# imprime =>  ]
	li $v0, 4
	la $a0, str_arr_fin
	syscall

	jr $ra
