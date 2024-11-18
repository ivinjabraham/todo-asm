.include "macros.i"

.section .data

startup_msg:
        .asciz "Starting web server...\n"
        .set startup_msg_len, . - startup_msg

.section .bss

.lcomm sock_fd, 8

.section .text

.globl _start
_start:
        # Print startup message
        write $stdout, $startup_msg, $startup_msg_len
        check_error

        socket $af_inet, $sock_stream, $tcp
        check_error
        movq %rax, sock_fd

        # Exit successfully
        exit $success

error_exit:
        exit %rax
