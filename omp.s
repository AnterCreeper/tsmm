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
	vmovapd	512(%rax), %ymm7
	vunpcklpd	256(%rax), %ymm5, %ymm2
	vunpcklpd	768(%rax), %ymm7, %ymm3
	vunpckhpd	256(%rax), %ymm5, %ymm0
	vunpckhpd	768(%rax), %ymm7, %ymm1
	vinsertf128	$1, %xmm3, %ymm2, %ymm4
	vmovapd	%ymm4, (%rsi)
	vperm2f128	$49, %ymm3, %ymm2, %ymm2
	vinsertf128	$1, %xmm1, %ymm0, %ymm4
	vperm2f128	$49, %ymm1, %ymm0, %ymm0
	vmovapd	%ymm4, 128(%rsi)
	vmovapd	%ymm2, 256(%rsi)
	vmovapd	%ymm0, 384(%rsi)
	addq	$32, %rsi
	addq	$1024, %rax
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
	movslq	%ecx, %rcx
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	andq	$-32, %rsp
	subq	$8, %rsp
	vxorpd	%xmm3, %xmm3, %xmm3
	salq	$3, %rcx
	addq	%rcx, %rsi
	leaq	4096(%rdi), %rax
	vmovapd	%ymm3, %ymm2
	vmovapd	%ymm3, %ymm1
	vmovapd	%ymm3, %ymm0
.L6:
	vmovapd	(%rsi), %ymm4
	vbroadcastsd	(%rdi), %ymm8
	vbroadcastsd	8(%rdi), %ymm7
	vbroadcastsd	16(%rdi), %ymm6
	vbroadcastsd	24(%rdi), %ymm5
	vfmadd132pd	%ymm4, %ymm0, %ymm8
	vfmadd132pd	%ymm4, %ymm1, %ymm7
	vfmadd132pd	%ymm4, %ymm2, %ymm6
	vfmadd132pd	%ymm4, %ymm3, %ymm5
	vmovapd	128000(%rsi), %ymm0
	vbroadcastsd	256(%rdi), %ymm4
	vbroadcastsd	264(%rdi), %ymm3
	vbroadcastsd	272(%rdi), %ymm2
	vbroadcastsd	280(%rdi), %ymm1
	vfmadd132pd	%ymm0, %ymm8, %ymm4
	vfmadd132pd	%ymm0, %ymm7, %ymm3
	vfmadd132pd	%ymm0, %ymm6, %ymm2
	vfmadd132pd	%ymm0, %ymm5, %ymm1
	vbroadcastsd	512(%rdi), %ymm8
	vmovapd	256000(%rsi), %ymm0
	vbroadcastsd	520(%rdi), %ymm7
	vbroadcastsd	528(%rdi), %ymm6
	vbroadcastsd	536(%rdi), %ymm5
	vfmadd132pd	%ymm0, %ymm4, %ymm8
	vfmadd132pd	%ymm0, %ymm3, %ymm7
	vfmadd132pd	%ymm0, %ymm2, %ymm6
	vfmadd132pd	%ymm0, %ymm1, %ymm5
	vbroadcastsd	784(%rdi), %ymm2
	vbroadcastsd	768(%rdi), %ymm0
	vbroadcastsd	776(%rdi), %ymm1
	vbroadcastsd	792(%rdi), %ymm3
	vmovapd	384000(%rsi), %ymm4
	addq	$1024, %rdi
	vfmadd132pd	%ymm4, %ymm8, %ymm0
	vfmadd132pd	%ymm4, %ymm7, %ymm1
	vfmadd132pd	%ymm4, %ymm6, %ymm2
	vfmadd132pd	%ymm4, %ymm5, %ymm3
	addq	$512000, %rsi
	vmovapd	%ymm0, -120(%rsp)
	vmovapd	%ymm1, -88(%rsp)
	vmovapd	%ymm2, -56(%rsp)
	vmovapd	%ymm3, -24(%rsp)
	cmpq	%rdi, %rax
	jne	.L6
	addq	%rcx, %rdx
	leaq	-120(%rsp), %rax
	leaq	8(%rsp), %rcx
.L7:
	vmovapd	(%rax), %ymm5
	addq	$32, %rax
	vmovntpd	%ymm5, (%rdx)
	addq	$128000, %rdx
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
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	movq	8(%rdi), %rax
	movq	(%rdi), %rbp
	movq	16(%rdi), %rbx
	movq	%rax, (%rsp)
	movq	%rbp, 8(%rsp)
	call	omp_get_thread_num@PLT
	movl	%eax, %r14d
	sall	$2, %r14d
	call	omp_get_num_threads@PLT
	cmpl	$3999, %r14d
	jg	.L19
	movl	%eax, %r8d
	leal	0(,%rax,4), %r15d
	leaq	4096000(%rbp), %r13
	.p2align 4,,10
	.p2align 3
.L14:
	movq	(%rsp), %r10
	movq	8(%rsp), %r9
	leal	1(%r14), %r12d
	leal	2(%r14), %ebp
	leal	3(%r14), %r11d
	.p2align 4,,10
	.p2align 3
.L13:
	movq	%r9, %rdx
	movq	%r10, %rdi
	movl	%r14d, %ecx
	movq	%rbx, %rsi
	call	matmul_worker_row
	movq	%r9, %rdx
	movq	%r10, %rdi
	movl	%r12d, %ecx
	movq	%rbx, %rsi
	call	matmul_worker_row
	movq	%r9, %rdx
	movq	%r10, %rdi
	movl	%ebp, %ecx
	movq	%rbx, %rsi
	call	matmul_worker_row
	movq	%r9, %rdx
	movq	%r10, %rdi
	movl	%r11d, %ecx
	movq	%rbx, %rsi
	addq	$512000, %r9
	call	matmul_worker_row
	addq	$32, %r10
	cmpq	%r13, %r9
	jne	.L13
	addl	%r15d, %r14d
	cmpl	$3999, %r14d
	jle	.L14
.L19:
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
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
	movq	%rdx, 16(%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rdi, (%rsp)
	movq	%rsp, %rsi
	xorl	%ecx, %ecx
	movl	$6, %edx
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
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"start benchmark %d rounds\n"
	.section	.rodata.str1.8
	.align 8
.LC2:
	.string	"failed to write result to file"
	.section	.rodata.str1.1
.LC3:
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
	movl	$65536000, %edx
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
	movl	$65536, %esi
	leaq	.LC1(%rip), %rdi
	movl	%eax, %ebx
	xorl	%eax, %eax
	call	printf@PLT
	xorl	%eax, %eax
	call	start_perf@PLT
	leaq	32(%rsp), %r12
	leaq	matmul_row._omp_fn.0(%rip), %rbp
	.p2align 4,,10
	.p2align 3
.L26:
	movl	%ebx, %eax
	andl	$31, %eax
	vmovq	24(%rsp), %xmm1
	imulq	$256000, %rax, %rax
	movq	16(%rsp), %rdx
	vpinsrq	$1, 8(%rsp), %xmm1, %xmm0
	leaq	(%rdx,%rax,8), %rax
	xorl	%ecx, %ecx
	movl	$6, %edx
	movq	%r12, %rsi
	movq	%rbp, %rdi
	incl	%ebx
	movq	%rax, 48(%rsp)
	vmovdqa	%xmm0, 32(%rsp)
	call	GOMP_parallel@PLT
	cmpl	$65536, %ebx
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
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	jmp	.L25
.L33:
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	jmp	.L25
	.cfi_endproc
.LFE6396:
	.size	main, .-main
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
