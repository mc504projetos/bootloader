# Anderson Murillo Tito Lira Leite, 248221
# Isaac do Nascimento Oliveira, 247175


.section .text
    .globl _start

_start:
    # colocar a CPU em Machine Mode (M-mode)
    # define MPP (modo de privilégio da CPU) para M-mode no mstatus
    li t0, 0x300            # MSTATUS address
    li t1, 0x1800           # set MPP to Machine Mode (M-mode)
    csrw mstatus, t1        # escreve o valor em mstatus

    # inicializar o Stack Pointer (SP)
    la sp, _stack_top       # configura o ponteiro da pilha (stack pointer)

    # inicializacao da UART para saida no console
    lui a0, %hi(UART_BASE)
    addi a0, a0, %lo(UART_BASE)
    
    # exibe a mensagem "Hello, Boot!" no console
    la a1, hello_msg

print_loop:
    lb a2, 0(a1)          # carrega o proximo caractere
    beqz a2, halt         # se for zero (fim da string), sai
    call uart_putc        # escreve o caractere na UART
    addi a1, a1, 1        # proximo caractere
    j print_loop          # continua o loop

halt:
    j halt                # loop infinito

# funcao para escrever na UART
uart_putc:
    sb a2, 0(a0)          # escreve o caractere em a2 na UART
    ret                   # retorna da funcao

# dados da mensagem
.section .data
hello_msg:
    .asciz "Hello, Boot!"

# definicao do endereco base da UART
.equ UART_BASE, 0x10000000

# reserva espaço para a pilha
.section .bss
_stack_top:
    .space 1024            # reserva 1KB para a pilha
