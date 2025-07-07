.data
    prompt: .asciiz "Ingrese un numero n para Fibonacci: "
    start_sequence_msg: .asciiz "La sucesion de Fibonacci hasta F(n) es:\n"
    comma: .asciiz ", "
    newline: .asciiz "\n"

.text
.globl main

main:
   
     # Solicitar al usuario que ingrese n
    li $v0, 4             # Código de servicio para imprimir string
    la $a0, prompt        # Cargar dirección del string prompt
    syscall

    # Leer el número n del usuario
    li $v0, 5             # Código de servicio para leer entero
    syscall
    move $s0, $v0         # Guardar n en $s0

    # Imprimir el mensaje de inicio de la sucesión
    li $v0, 4             # Código de servicio para imprimir string
    la $a0, start_sequence_msg # Cargar dirección del string
    syscall

    # Llamar a la función fibonacci_print_sequence
    move $a0, $s0         # Mover n_input a $a0 (argumento para fib)
    jal fibonacci_print_sequence # Llamar a la función que imprime la sucesión

    # Imprimir un salto de línea final para mejor formato
    li $v0, 4
    la $a0, newline
    syscall

    # Salir del programa
    li $v0, 10            # Código de servicio para salir
    syscall

#--------------------------------------------------------------------------------------

#funcion Fibonacci

fibonacci_print_sequence:
    move $s0, $a0         # Guardar n en $s0 para usar $a0 en llamadas syscall

    # Caso base: n = 0
    bge $s0, $zero, handle_n_zero # Si n >= 0, ir a manejar el caso F(0)
    j fib_seq_end         # Si n es negativo (no esperado), simplemente terminar

handle_n_zero:
    # Imprimir F(0) = 0
    li $a0, 0             # Cargar 0 para imprimir
    li $v0, 1             # Código para imprimir entero
    syscall
    # Si n fue 0, no necesitamos imprimir comas ni más números, solo terminar
    beq $s0, $zero, fib_seq_end_print

    # Para n > 0, inicializar y continuar con F(1) en adelante
    li $t0, 0             # a = 0 (F_0)
    li $t1, 1             # b = 1 (F_1)

    # Inicializar contador k
    li $t2, 1             # k = 1 (vamos a imprimir F(1) después de F(0))

fib_seq_loop:
   
    bgt $t2, $s0, fib_seq_end_print	 # Si k > n, hemos terminado de imprimir

    # Imprimir la coma y espacio antes del siguiente número (excepto para el primer número después de F(0))
    li $v0, 4             # Código para imprimir string
    la $a0, comma   # Cargar ", "
    syscall

    # Imprimir el valor actual de b (que es F(k))
    move $a0, $t1         # Cargar b para imprimir
    li $v0, 1             # Código para imprimir entero
    syscall

    # Calcular siguiente_fib = a + b
    add $t3, $t0, $t1     # $t3 = a + b (siguiente_fib)

    # Actualizar a y b para la siguiente iteración
    move $t0, $t1         # a = b
    move $t1, $t3         # b = siguiente_fib

    # Incrementar contador k
    addi $t2, $t2, 1      # k++

    j fib_seq_loop            # Volver al inicio del bucle

fib_seq_end_print:
    # Salto de línea para la sucesión
    li $v0, 4
    la $a0, newline
    syscall

fib_seq_end:
    jr $ra                # Retornar al llamador