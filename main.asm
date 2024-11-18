.equ success, 0      # Success return code
.equ stdout, 1       # File Descriptor for STDOUT

.equ SYS_exit, 60
.equ SYS_write, 1

.macro write fd, buf, len
        movq $SYS_write, %rax
        movq \fd, %rdi
        movq \buf, %rsi
        movq \len, %rdx
        syscall
.endm

.macro exit code
        movq $SYS_exit, %rax
        movq \code, %rdi
        syscall
.endm

.section .data

startup_msg:
        .asciz "Starting web server...\n"
        .set startup_msg_len, . - startup_msg

.section .text

.globl _start
_start:
        # Print startup message
        write $stdout, $startup_msg, $startup_msg_len

        # Exit successfully
        exit $success
