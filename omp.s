	.file	"omp.c"
	.text
	.p2align 4
	.globl	transpose
	.type	transpose, @function
transpose:
.LFB6393:
	.cfi_startproc
	sall	$2, %edx
	movslq	%edx, %rdx
	leaq	(%rdi,%rdx,8), %rax
	leaq	128(%rsi), %rdx
.L2:
	vmovapd	(%rax), %ymm5
	addq	$32, %rsi
	addq	$1024, %rax
	vunpcklpd	-768(%rax), %ymm5, %ymm2
	vmovapd	-512(%rax), %ymm7
	vunpcklpd	-256(%rax), %ymm7, %ymm3
	vunpckhpd	-768(%rax), %ymm5, %ymm0
	vunpckhpd	-256(%rax), %ymm7, %ymm1
	vinsertf128	$1, %xmm3, %ymm2, %ymm4
	vperm2f128	$49, %ymm3, %ymm2, %ymm2
	vmovapd	%ymm4, -32(%rsi)
	vinsertf128	$1, %xmm1, %ymm0, %ymm4
	vperm2f128	$49, %ymm1, %ymm0, %ymm0
	vmovapd	%ymm4, 96(%rsi)
	vmovapd	%ymm2, 224(%rsi)
	vmovapd	%ymm0, 352(%rsi)
	cmpq	%rsi, %rdx
	jne	.L2
	vzeroupper
	ret
	.cfi_endproc
.LFE6393:
	.size	transpose, .-transpose
	.p2align 4
	.globl	matmul_worker_row
	.type	matmul_worker_row, @function
matmul_worker_row:
.LFB6394:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	sall	$2, %ecx
	vxorpd	%xmm3, %xmm3, %xmm3
	leaq	4096(%rdi), %rax
	vmovapd	%ymm3, %ymm2
	vmovapd	%ymm3, %ymm1
	vmovapd	%ymm3, %ymm0
	movslq	%ecx, %rcx
	salq	$3, %rcx
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	andq	$-32, %rsp
	addq	%rcx, %rsi
	subq	$8, %rsp
.L6:
	vmovapd	(%rsi), %ymm4
	vbroadcastsd	(%rdi), %ymm8
	addq	$1024, %rdi
	addq	$512000, %rsi
	vbroadcastsd	-1016(%rdi), %ymm7
	vbroadcastsd	-1008(%rdi), %ymm6
	vbroadcastsd	-1000(%rdi), %ymm5
	vfmadd132pd	%ymm4, %ymm0, %ymm8
	vmovapd	-384000(%rsi), %ymm0
	vfmadd132pd	%ymm4, %ymm1, %ymm7
	vfmadd132pd	%ymm4, %ymm2, %ymm6
	vbroadcastsd	-744(%rdi), %ymm1
	vbroadcastsd	-752(%rdi), %ymm2
	vfmadd132pd	%ymm4, %ymm3, %ymm5
	vbroadcastsd	-768(%rdi), %ymm4
	vbroadcastsd	-760(%rdi), %ymm3
	vfmadd132pd	%ymm0, %ymm8, %ymm4
	vbroadcastsd	-512(%rdi), %ymm8
	vfmadd132pd	%ymm0, %ymm7, %ymm3
	vfmadd132pd	%ymm0, %ymm6, %ymm2
	vbroadcastsd	-504(%rdi), %ymm7
	vbroadcastsd	-496(%rdi), %ymm6
	vfmadd132pd	%ymm0, %ymm5, %ymm1
	vmovapd	-256000(%rsi), %ymm0
	vbroadcastsd	-488(%rdi), %ymm5
	vfmadd132pd	%ymm0, %ymm4, %ymm8
	vmovapd	-128000(%rsi), %ymm4
	vfmadd132pd	%ymm0, %ymm3, %ymm7
	vfmadd132pd	%ymm0, %ymm2, %ymm6
	vbroadcastsd	-232(%rdi), %ymm3
	vbroadcastsd	-240(%rdi), %ymm2
	vfmadd132pd	%ymm0, %ymm1, %ymm5
	vbroadcastsd	-256(%rdi), %ymm0
	vbroadcastsd	-248(%rdi), %ymm1
	cmpq	%rdi, %rax
	vfmadd132pd	%ymm4, %ymm8, %ymm0
	vfmadd132pd	%ymm4, %ymm7, %ymm1
	vfmadd132pd	%ymm4, %ymm6, %ymm2
	vfmadd132pd	%ymm4, %ymm5, %ymm3
	vmovapd	%ymm0, -120(%rsp)
	vmovapd	%ymm1, -88(%rsp)
	vmovapd	%ymm2, -56(%rsp)
	vmovapd	%ymm3, -24(%rsp)
	jne	.L6
	addq	%rcx, %rdx
	leaq	-120(%rsp), %rax
	leaq	8(%rsp), %rcx
.L7:
	vmovapd	(%rax), %ymm5
	addq	$32, %rax
	addq	$128000, %rdx
	vmovntpd	%ymm5, -128000(%rdx)
	cmpq	%rax, %rcx
	jne	.L7
	vzeroupper
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6394:
	.size	matmul_worker_row, .-matmul_worker_row
	.p2align 4
	.type	matmul_row._omp_fn.0, @function
matmul_row._omp_fn.0:
.LFB6397:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	16(%rdi), %rbx
	movq	8(%rdi), %r12
	movq	(%rdi), %rbp
	call	omp_get_thread_num@PLT
	movl	%eax, %r13d
	call	omp_get_num_threads@PLT
	leal	(%r13,%r13), %r10d
	cmpl	$3999, %r10d
	jg	.L19
	leal	(%rax,%rax), %r14d
	leaq	4096000(%rbp), %r13
	.p2align 4,,10
	.p2align 3
.L14:
	leal	1(%r10), %r11d
	movq	%r12, %r9
	movq	%rbp, %r8
	.p2align 4,,10
	.p2align 3
.L13:
	movq	%r8, %rdx
	movq	%r9, %rdi
	movl	%r10d, %ecx
	movq	%rbx, %rsi
	call	matmul_worker_row
	movq	%r8, %rdx
	movq	%r9, %rdi
	movl	%r11d, %ecx
	movq	%rbx, %rsi
	addq	$512000, %r8
	addq	$32, %r9
	call	matmul_worker_row
	cmpq	%r13, %r8
	jne	.L13
	addl	%r14d, %r10d
	cmpl	$3999, %r10d
	jle	.L14
.L19:
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6397:
	.size	matmul_row._omp_fn.0, .-matmul_row._omp_fn.0
	.p2align 4
	.globl	matmul_row
	.type	matmul_row, @function
matmul_row:
.LFB6395:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	xorl	%ecx, %ecx
	movq	%rdx, 16(%rsp)
	movl	$6, %edx
	movq	%rsi, 8(%rsp)
	movq	%rsp, %rsi
	movq	%rdi, (%rsp)
	leaq	matmul_row._omp_fn.0(%rip), %rdi
	call	GOMP_parallel@PLT
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6395:
	.size	matmul_row, .-matmul_row
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"failed to open file while reading data"
	.align 8
.LC1:
	.string	"failed to write result to file"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"result test failed"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB6396:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movl	$4096, %edx
	movl	$64, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$64, %rsp
	.cfi_def_cfa_offset 96
	leaq	8(%rsp), %rdi
	call	posix_memalign@PLT
	leaq	16(%rsp), %rdi
	movl	$2048000, %edx
	movl	$64, %esi
	call	posix_memalign@PLT
	leaq	24(%rsp), %rdi
	movl	$4096000, %edx
	movl	$64, %esi
	call	posix_memalign@PLT
	movq	16(%rsp), %rsi
	movq	8(%rsp), %rdi
	call	prepare@PLT
	testl	%eax, %eax
	jne	.L32
	xorl	%eax, %eax
	movl	$65536, %ebx
	leaq	32(%rsp), %r12
	call	start_perf@PLT
	leaq	matmul_row._omp_fn.0(%rip), %rbp
	.p2align 4,,10
	.p2align 3
.L26:
	vmovq	24(%rsp), %xmm1
	movq	16(%rsp), %rax
	xorl	%ecx, %ecx
	movq	%r12, %rsi
	vpinsrq	$1, 8(%rsp), %xmm1, %xmm0
	movl	$6, %edx
	movq	%rbp, %rdi
	movq	%rax, 48(%rsp)
	vmovdqa	%xmm0, 32(%rsp)
	call	GOMP_parallel@PLT
	subl	$1, %ebx
	jne	.L26
	xorl	%eax, %eax
	call	end_perf@PLT
	movq	24(%rsp), %rdi
	call	writeback@PLT
	testl	%eax, %eax
	jne	.L33
	movq	24(%rsp), %rdi
	call	check@PLT
	testl	%eax, %eax
	movl	%eax, %ebx
	jne	.L34
	movq	8(%rsp), %rdi
	call	free@PLT
	movq	16(%rsp), %rdi
	call	free@PLT
	movq	24(%rsp), %rdi
	call	free@PLT
.L23:
	addq	$64, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	movl	%ebx, %eax
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L32:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
.L25:
	orl	$-1, %ebx
	jmp	.L23
.L34:
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	jmp	.L25
.L33:
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	jmp	.L25
	.cfi_endproc
.LFE6396:
	.size	main, .-main
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
