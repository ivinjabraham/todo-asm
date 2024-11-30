.macro def_msg name, content
        \name:
                .asciz "\content"
                .set \name\()_len, . - \name
.endm

.macro check_error label
        cmpq $0, %rax
        jl \label
.endm

.macro write fd, buf, len
        movq $SYS_write, %rax
        movq \fd, %rdi
        movq \buf, %rsi
        movq \len, %rdx
        syscall
.endm

.macro write_stdout buf, len
        write $stdout, \buf, \len
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

.macro listen sockfd, num_con
        movq $SYS_listen, %rax
        movq \sockfd, %rdi
        movq \num_con, %rsi
        syscall
.endm

.macro accept sockfd
        movq $SYS_accept, %rax
        movq \sockfd, %rdi
        xorq %rsi, %rsi
        xorq %rdx, %rdx
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
.equ in_port_t_offset, 2
.equ in_addr_offset, 4
.equ sockaddr_len, 16
.equ num_connections, 1
.equ port_num, 53764       # hex(1234) in big endian 
.equ localhost, 0x0100007F # hex(127.0.0.1) in big endian

# syscall numbers
.equ SYS_exit, 60
.equ SYS_write, 1
.equ SYS_socket, 41
.equ SYS_bind, 49
.equ SYS_listen, 50
.equ SYS_accept, 43
