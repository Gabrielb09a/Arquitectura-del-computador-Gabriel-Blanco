.data
array:      .word 5, 3, 8, 4, 2, 7, 1, 10, 6, 9   # Array a ordenar
size:       .word 10                              # Tamaño del array
msg_original: .asciiz "Array original: "
msg_ordenado: .asciiz "\nArray ordenado: "
espacio:    .asciiz " "

.text
.globl main

main:
    # Mostrar array original
    la $a0, msg_original
    li $v0, 4
    syscall
    
    jal imprimir_array
    
    # Ordenar el array
    jal ordenamiento_burbuja
    
    # Mostrar array ordenado
    la $a0, msg_ordenado
    li $v0, 4
    syscall
    
    jal imprimir_array
    
    # Salir del programa
    li $v0, 10
    syscall

# Subrutina para imprimir el array
imprimir_array:
    la $t0, array         # Cargar dirección del array
    lw $t1, size          # Cargar tamaño del array
    li $t2, 0             # Contador i = 0
    
    bucle_imprimir:
        beq $t2, $t1, fin_imprimir  # Si i == tamaño, terminar
        
        # Imprimir elemento array[i]
        lw $a0, 0($t0)
        li $v0, 1
        syscall
        
        # Imprimir espacio
        la $a0, espacio
        li $v0, 4
        syscall
        
        addi $t0, $t0, 4   # Siguiente elemento
        addi $t2, $t2, 1   # i++
        j bucle_imprimir
    
    fin_imprimir:
        jr $ra

# Subrutina de ordenamiento burbuja
ordenamiento_burbuja:
    la $t0, array         # Cargar dirección del array
    lw $t1, size          # Cargar tamaño del array
    addi $t1, $t1, -1     # tamaño - 1 para el bucle externo
    
    li $t2, 0             # i = 0 (bucle externo)
    
    bucle_externo:
        bge $t2, $t1, fin_ordenamiento  # Si i >= tamaño-1, terminar
        
        li $t3, 0         # j = 0 (bucle interno)
        sub $t4, $t1, $t2 # tamaño-1-i (límite para j)
        
        bucle_interno:
            bge $t3, $t4, fin_bucle_interno  # Si j >= tamaño-1-i, terminar bucle interno
            
            # Cargar array[j] y array[j+1]
            sll $t5, $t3, 2        # j * 4 (desplazamiento en bytes)
            add $t5, $t0, $t5      # dirección de array[j]
            lw $t6, 0($t5)         # array[j]
            lw $t7, 4($t5)         # array[j+1]
            
            # Comparar array[j] y array[j+1]
            ble $t6, $t7, no_intercambiar  # Si array[j] <= array[j+1], no intercambiar
            
            # Intercambiar elementos
            sw $t7, 0($t5)
            sw $t6, 4($t5)
            
            no_intercambiar:
                addi $t3, $t3, 1   # j++
                j bucle_interno
        
        fin_bucle_interno:
            addi $t2, $t2, 1       # i++
            j bucle_externo
    
    fin_ordenamiento:
        jr $ra