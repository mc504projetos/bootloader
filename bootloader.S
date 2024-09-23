# Anderson Murillo Tito Lira Leite, 248221
# Isaac do Nascimento Oliveira, 247175

# Olá! Para rodar executar o bootloader em um ambiente
# Ubuntu 24.04 LTS com arquitetura x86_64, use:
# > riscv64-unknown-elf-gcc -nostdlib -Ttext 0x80000000 -o bootloader.elf bootloader.S
# > qemu-system-riscv64 -nographic -machine virt -kernel bootloader.elf -bios none

# O uso de -bios none deve-se ao fato de que sem essa flag, o qemu tentava executar o 
# firmaware dinamico padrao OpenSBI no mesmo endereco que o bootloader, 0x80000000, 
# a solucao foi desabilita-lo, mas tambem pode-se usar um linker.ld e alterar o
# endereco base 0x80200000, por exemplo


# dados da mensagem
.section .data
msg:
    .asciz "Hello, Boot!"

# definicao do endereco base da UART
.equ UART_BASE, 0x10000000

# reserva espaço para a pilha
.section .bss
_stack_top:
    .space 1024            # reserva 1KB para a pilha

.section .text
    .globl _start

_start:
    # set da CPU em Machine Mode (M-mode)
    # define MPP (modo de privilégio da CPU) para M-mode no mstatus
    li t0, 0x300            # endereco do MSTATUS
    li t1, 0x1800           # set MPP em Machine Mode (M-mode)
    csrw mstatus, t1        # escreve o valor em mstatus

    # inicializar o Stack Pointer (SP)
    la sp, _stack_top       

    # inicializa UART para saida no console
    lui a0, %hi(UART_BASE)
    addi a0, a0, %lo(UART_BASE)
    
    # passa a str "Hello, Boot!" como parametro
    la a1, msg

print:
    lb a2, 0(a1)          # carrega o proximo caractere
    beqz a2, loop         # se for zero (fim da string), sai
    call uart_putc        # escreve o caractere na UART
    addi a1, a1, 1        # proximo caractere
    j print         

loop:
    j loop

# funcao para escrever na UART
uart_putc:
    sb a2, 0(a0)          # escreve o caractere em a2 na UART
    ret                  
