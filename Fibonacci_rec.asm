.data
    prompt: .asciiz "Ingrese un número entero no negativo para calcular su Fibonacci: "
    result_msg: .asciiz "El número de Fibonacci es: "
    newline: .asciiz "\n"
    error_negative: .asciiz "Error: Por favor, ingrese un número no negativo.\n"
    error_invalid: .asciiz "Error: Entrada inválida. Por favor, ingrese un número entero.\n"

.text
.globl main

main:
    # Imprimir prompt
    li   $v0, 4                 # syscall para imprimir string
    la   $a0, prompt
    syscall

    # Leer entero del usuario
    li   $v0, 5                 # syscall para leer entero
    syscall
    move $s0, $v0               # Guardar la entrada del usuario en $s0 (n)

    # Validar si n es negativo
    bltz $s0, handle_negative_input # Si n < 0, ir a manejar error

    # Llamar a la función fibonacci
    move $a0, $s0               # Pasar n a $a0 (argumento para fibonacci)
    jal  fibonacci              # Llamar a fibonacci
    move $s1, $v0               # Guardar el resultado de fibonacci en $s1

    # Imprimir mensaje de resultado
    li   $v0, 4                 # syscall para imprimir string
    la   $a0, result_msg
    syscall

    # Imprimir el resultado
    li   $v0, 1                 # syscall para imprimir entero
    move $a0, $s1               # El resultado está en $s1
    syscall

    # Imprimir nueva línea
    li   $v0, 4
    la   $a0, newline
    syscall

    # Salir del programa
    li   $v0, 10                # syscall para salir
    syscall

handle_negative_input:
    li   $v0, 4
    la   $a0, error_negative
    syscall
    j    exit_program

exit_program:
    li   $v0, 10
    syscall

fibonacci:
    # Prológo: Guardar $ra y $a0 (n) en la pila
    addi $sp, $sp, -12          # Espacio para 3 registros: $ra, $s0 (n), $s1 (fib(n-1))
    sw   $ra, 8($sp)            # Guarda la dirección de retorno
    sw   $a0, 4($sp)            # Guarda n (original) en $s0 de la pila

    # Caso base: n == 0
    beqz $a0, fib_base_0        # if n == 0, goto fib_base_0

    # Caso base: n == 1
    li   $t0, 1
    beq  $a0, $t0, fib_base_1   # if n == 1, goto fib_base_1

    # Caso recursivo: fibonacci(n-1)
    addi $a0, $a0, -1           # n = n - 1
    jal  fibonacci              # Llamada recursiva a fibonacci(n-1)
    sw   $v0, 0($sp)            # Guarda fib(n-1) en la pila (posición 0($sp))

    # Caso recursivo: fibonacci(n-2)
    lw   $a0, 4($sp)            # Restaura el n original para calcular n-2 (estaba en 4($sp))
    addi $a0, $a0, -2           # n = n - 2
    jal  fibonacci              # Llamada recursiva a fibonacci(n-2)

    # Suma de resultados
    lw   $t1, 0($sp)            # Carga fib(n-1) de la pila
    add  $v0, $t1, $v0          # $v0 = fib(n-1) + fib(n-2) (donde $v0 ya contiene fib(n-2))
    j    fib_epilogue

fib_base_0:
    li   $v0, 0                 # Resultado es 0
    j    fib_epilogue

fib_base_1:
    li   $v0, 1                 # Resultado es 1

fib_epilogue:
    # Epílogo: Restaurar $ra y mover el puntero de pila
    lw   $ra, 8($sp)            # Restaura la dirección de retorno
    addi $sp, $sp, 12           # Libera el espacio de la pila
    jr   $ra                    # Retorna al llamador