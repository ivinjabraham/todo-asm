.include "macros.i"

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
