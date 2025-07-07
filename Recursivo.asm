.data
prompt:     .asciiz "Ingrese n para calcular fib(n): "
result:     .asciiz "El resultado es: "
newline:    .asciiz "\n"

.text
.globl main

main:
    # Solicitar entrada
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Leer n
    li $v0, 5
    syscall
    move $a0, $v0
    
    # Validar entrada
    bltz $a0, invalido
    
    # Calcular fib(n)
    jal fibonacci
    move $s0, $v0
    
    # Mostrar resultado
    li $v0, 4
    la $a0, result
    syscall
    
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    # Salir
    li $v0, 10
    syscall
    
invalido:
    li $v0, 10
    syscall

fibonacci:
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $a0, 4($sp)      # Guardar n original
    
    # Casos base: fib(0)=0, fib(1)=1
    li $t0, 1
    ble $a0, $t0, base_case
    
    # Calcular fib(n-1)
    addi $a0, $a0, -1
    jal fibonacci
    sw $v0, 0($sp)      # Guardar fib(n-1)
    
    # Calcular fib(n-2)
    lw $a0, 4($sp)      # Recuperar n original
    addi $a0, $a0, -2
    jal fibonacci
    
    # Sumar resultados
    lw $t0, 0($sp)      # fib(n-1)
    add $v0, $t0, $v0   # fib(n-1) + fib(n-2)
    
    # Restaurar contexto
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra
    
base_case:
    move $v0, $a0       # Para n=0 o n=1, retornar n
    jr $ra