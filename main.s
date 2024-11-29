.include "macros.i"

.section .data

bind_error_msg:
        .asciz "Could not bind a socket.\n"
        .set bind_error_msg_len, . - bind_error_msg

startup_msg:
        .asciz "Starting web server...\n"
        .set startup_msg_len, . - startup_msg

.section .bss

.lcomm sock_fd, 8
.lcomm sockaddr, 64

.section .text

.globl _start
_start:
        # Print startup message
        write $stdout, $startup_msg, $startup_msg_len
        check_error

        # Create a socket
        socket $af_inet, $sock_stream, $tcp
        check_error
        movq %rax, sock_fd(%rip)

        # Set up sockaddr_in
        movw $af_inet, sockaddr+sin_family_offset(%rip)
        movw $0xD204, sockaddr+in_port_t_offset(%rip)    # sin_port = 1234 in hex big endian
        movl $0x0100007F, sockaddr+in_addr_offset(%rip)  # sin_addr = 127.0.0.1 in hex big endian

        # Bind the socket
        bind sock_fd(%rip), sockaddr(%rip), $sockaddr_len
        check_error

        # Listen
        listen sock_fd(%rip), $num_connections
        check_error

        # Exit successfully
        exit $success

error_exit:
        write $stdout, $bind_error_msg, $bind_error_msg_len
        exit %rax
