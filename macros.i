.macro check_error
        cmpq $0, %rax
        jl error_exit
.endm

.macro write fd, buf, len
        movq $SYS_write, %rax
        movq \fd, %rdi
        movq \buf, %rsi
        movq \len, %rdx
        syscall
.endm

.macro socket domain, type, proto
        movq $SYS_socket, %rax
        movq \domain, %rdi
        movq \type, %rsi
        movq \proto, %rdx
        syscall
.endm

.macro bind sockfd, sockaddr, addrlen
        movq $SYS_bind, %rax
        movq \sockfd, %rdi
        lea \sockaddr, %rsi
        movq \addrlen, %rdx
        syscall
.endm

.macro exit code
        movq $SYS_exit, %rax
        movq \code, %rdi
        syscall
.endm

.equ success, 0      # Success return code
.equ stdout, 1       # File Descriptor for STDOUT
.equ af_inet, 2
.equ sock_stream, 1
.equ tcp, 0
.equ sin_family_offset, 0
.equ in_port_t_offset, 16
.equ in_addr_offset, 32
.equ sockaddr_len, 64

# syscall numbers
.equ SYS_exit, 60
.equ SYS_write, 1
.equ SYS_socket, 41
.equ SYS_bind, 49
