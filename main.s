.include "macros.i"

.section .data

def_msg startup_msg, "INFO: Starting web server...\n"
def_msg write_err_msg, "ERROR: Failed to write to STDOUT.\n"
def_msg socket_err_msg, "ERROR: Improper socket configuration.\n"

.section .bss

.lcomm sock_fd, 8
.lcomm sockaddr, 64

.section .text

.globl _start
_start:
        write_stdout $startup_msg, $startup_msg_len
        check_error write_err

        socket $af_inet, $sock_stream, $tcp
        check_error socket_err
        movq %rax, sock_fd(%rip) # Save socket file descriptor

        # Set up sockaddr_in
        movw $af_inet, sockaddr+sin_family_offset(%rip)
        movw $0xD204, sockaddr+in_port_t_offset(%rip)
        movl $0x0100007F, sockaddr+in_addr_offset(%rip)

        bind sock_fd(%rip), sockaddr(%rip), $sockaddr_len
        check_error socket_err

        listen sock_fd(%rip), $num_connections
        check_error socket_err

        accept sock_fd(%rip)
        check_error socket_err

        # Exit successfully
        exit $success

write_err:
        write_stdout $write_err_msg, $write_err_msg_len
        exit %rax

socket_err:
        write_stdout $socket_err_msg, $socket_err_msg_len
        exit %rax
