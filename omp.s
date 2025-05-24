	.file	"omp.c"
	.text
	.p2align 4
	.type	matmul._omp_fn.0, @function
matmul._omp_fn.0:
.LFB6397:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	movl	24(%rdi), %r12d
	movq	8(%rdi), %r15
	movq	(%rdi), %r13
	andq	$-32, %rsp
	call	omp_get_thread_num@PLT
	movl	%eax, %r14d
	call	omp_get_num_threads@PLT
	leal	(%r14,%r14), %r10d
	cmpl	$3999, %r10d
	jg	.L13
	leal	0(,%rax,8), %r9d
	leal	(%rax,%rax), %r11d
	leal	4(,%r10,4), %eax
	movslq	%r9d, %r9
	cltq
	salq	$3, %r9
	leaq	(%r15,%rax,8), %r8
	leal	0(,%r14,8), %eax
	cltq
	leaq	(%r15,%rax,8), %rdi
	imull	$16000, %r12d, %eax
	addl	%r10d, %eax
	sall	$2, %eax
	cltq
	leaq	0(%r13,%rax,8), %r13
	.p2align 4,,10
	.p2align 3
.L4:
	movq	%r13, %r12
	xorl	%ecx, %ecx
.L3:
	movq	16(%rbx), %rdx
	movq	%rdi, %rax
	vxorpd	%xmm4, %xmm4, %xmm4
	addq	%rcx, %rdx
	leaq	128(%rdx), %rsi
.L5:
	vmovapd	(%rdx), %ymm0
	addq	$32, %rdx
	addq	$512000, %rax
	vbroadcastsd	%xmm0, %ymm3
	vpermpd	$85, %ymm0, %ymm2
	vpermpd	$170, %ymm0, %ymm1
	vfmadd132pd	-512000(%rax), %ymm4, %ymm3
	vpermpd	$255, %ymm0, %ymm0
	vfmadd132pd	-384000(%rax), %ymm3, %ymm2
	vmovapd	%ymm0, %ymm4
	vfmadd132pd	-256000(%rax), %ymm2, %ymm1
	vfmadd132pd	-128000(%rax), %ymm1, %ymm4
	cmpq	%rdx, %rsi
	jne	.L5
	vmovntpd	%ymm4, (%r12)
	movq	16(%rbx), %rdx
	movq	%r8, %rax
	vxorpd	%xmm4, %xmm4, %xmm4
	addq	%rcx, %rdx
	leaq	128(%rdx), %rsi
.L6:
	vmovapd	(%rdx), %ymm0
	addq	$32, %rdx
	addq	$512000, %rax
	vbroadcastsd	%xmm0, %ymm3
	vpermpd	$85, %ymm0, %ymm2
	vpermpd	$170, %ymm0, %ymm1
	vfmadd132pd	-512000(%rax), %ymm4, %ymm3
	vpermpd	$255, %ymm0, %ymm0
	vfmadd132pd	-384000(%rax), %ymm3, %ymm2
	vmovapd	%ymm0, %ymm4
	vfmadd132pd	-256000(%rax), %ymm2, %ymm1
	vfmadd132pd	-128000(%rax), %ymm1, %ymm4
	cmpq	%rdx, %rsi
	jne	.L6
	subq	$-128, %rcx
	vmovntpd	%ymm4, 32(%r12)
	addq	$128000, %r12
	cmpq	$512, %rcx
	jne	.L3
	addl	%r11d, %r10d
	addq	%r9, %r8
	addq	%r9, %rdi
	addq	%r9, %r13
	cmpl	$3999, %r10d
	jle	.L4
	vzeroupper
.L13:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6397:
	.size	matmul._omp_fn.0, .-matmul._omp_fn.0
	.p2align 4
	.globl	matmul
	.type	matmul, @function
matmul:
.LFB6395:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	movq	%rdi, %r14
	pushq	%r13
	.cfi_offset 13, -40
	movq	%rsi, %r13
	pushq	%r12
	.cfi_offset 12, -48
	xorl	%r12d, %r12d
	pushq	%rbx
	andq	$-64, %rsp
	subq	$576, %rsp
	.cfi_offset 3, -56
	leaq	32(%rsp), %rax
	movq	%rdx, 24(%rsp)
	leaq	64(%rsp), %rbx
	movq	%rax, 16(%rsp)
	leaq	192(%rsp), %r15
	.p2align 4,,10
	.p2align 3
.L17:
	movq	%r12, %rdx
	movl	%r12d, %ecx
	movq	%rbx, %rax
	salq	$5, %rdx
	addq	%r13, %rdx
.L18:
	vmovapd	(%rdx), %ymm5
	vmovapd	512(%rdx), %ymm7
	addq	$32, %rax
	addq	$1024, %rdx
	vunpcklpd	-768(%rdx), %ymm5, %ymm2
	vunpcklpd	-256(%rdx), %ymm7, %ymm3
	vunpckhpd	-768(%rdx), %ymm5, %ymm0
	vunpckhpd	-256(%rdx), %ymm7, %ymm1
	vinsertf128	$1, %xmm3, %ymm2, %ymm4
	vperm2f128	$49, %ymm3, %ymm2, %ymm2
	vmovapd	%ymm4, -32(%rax)
	vinsertf128	$1, %xmm1, %ymm0, %ymm4
	vperm2f128	$49, %ymm1, %ymm0, %ymm0
	vmovapd	%ymm4, 96(%rax)
	vmovapd	%ymm2, 224(%rax)
	vmovapd	%ymm0, 352(%rax)
	cmpq	%r15, %rax
	jne	.L18
	movq	24(%rsp), %rax
	movl	%ecx, 56(%rsp)
	xorl	%ecx, %ecx
	movl	$6, %edx
	movq	%r14, 32(%rsp)
	movq	16(%rsp), %rsi
	leaq	matmul._omp_fn.0(%rip), %rdi
	movq	%rax, 40(%rsp)
	movq	%rbx, 48(%rsp)
	vzeroupper
	call	GOMP_parallel@PLT
	addq	$1, %r12
	cmpq	$8, %r12
	jne	.L17
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6395:
	.size	matmul, .-matmul
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
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	$4096, %edx
	movl	$64, %esi
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	leaq	8(%rsp), %rdi
	call	posix_memalign@PLT
	leaq	16(%rsp), %rdi
	movl	$2048000, %edx
	movl	$64, %esi
	call	posix_memalign@PLT
	leaq	24(%rsp), %rdi
	movl	$64, %esi
	movl	$4096000, %edx
	call	posix_memalign@PLT
	movq	16(%rsp), %rsi
	movq	8(%rsp), %rdi
	call	prepare@PLT
	testl	%eax, %eax
	jne	.L32
	xorl	%eax, %eax
	movl	$65536, %ebx
	call	start_perf@PLT
	.p2align 4,,10
	.p2align 3
.L26:
	movq	16(%rsp), %rdx
	movq	8(%rsp), %rsi
	movq	24(%rsp), %rdi
	call	matmul
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
	movl	%eax, %ebx
	testl	%eax, %eax
	jne	.L34
	movq	8(%rsp), %rdi
	call	free@PLT
	movq	16(%rsp), %rdi
	call	free@PLT
	movq	24(%rsp), %rdi
	call	free@PLT
.L23:
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	movl	%ebx, %eax
	popq	%rbx
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
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
