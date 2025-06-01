	.file	"omp.c"
	.text
	.p2align 4
	.type	matmul_row._omp_fn.0, @function
matmul_row._omp_fn.0:
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
	andq	$-32, %rsp
	subq	$160, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	16(%rdi), %r9
	movq	8(%rdi), %r13
	movq	%r9, 24(%rsp)
	movq	(%rdi), %r15
	call	omp_get_thread_num@PLT
	movl	%eax, %ebx
	leal	(%rbx,%rbx), %r14d
	call	omp_get_num_threads@PLT
	cmpl	$3999, %r14d
	jg	.L17
	leaq	32(%r15), %rdi
	movq	24(%rsp), %r9
	movl	%eax, %edx
	movq	%rdi, 24(%rsp)
	sall	$3, %ebx
	leaq	4096(%r13), %rdi
	leal	0(,%rdx,8), %r12d
	movslq	%ebx, %rbx
	leal	4(,%r14,4), %edx
	movq	%rdi, 16(%rsp)
	movq	%r13, 8(%rsp)
	movslq	%r12d, %r12
	movslq	%edx, %rdx
	salq	$3, %rbx
	leaq	(%r9,%rdx,8), %r10
	leal	(%rax,%rax), %eax
	salq	$3, %r12
	addq	%rbx, %r9
	leaq	4352(%r13), %r11
	leaq	32(%rsp), %r8
	leaq	160(%rsp), %rcx
.L4:
	movq	24(%rsp), %rdi
	movq	16(%rsp), %rsi
	leaq	(%rdi,%rbx), %r13
	movq	8(%rsp), %rdi
	.p2align 4,,10
	.p2align 3
.L3:
	vxorpd	%xmm6, %xmm6, %xmm6
	movq	%rdi, %rdx
	movq	%r9, %r15
	vmovapd	%ymm6, %ymm4
	vmovapd	%ymm6, %ymm2
	vmovapd	%ymm6, %ymm0
.L5:
	vbroadcastsd	16(%rdx), %ymm5
	vmovapd	(%r15), %ymm8
	vbroadcastsd	(%rdx), %ymm1
	vbroadcastsd	8(%rdx), %ymm3
	vbroadcastsd	24(%rdx), %ymm7
	vfmadd231pd	%ymm8, %ymm5, %ymm4
	vfmadd231pd	%ymm8, %ymm1, %ymm0
	vfmadd231pd	%ymm8, %ymm3, %ymm2
	vfmadd231pd	%ymm8, %ymm7, %ymm6
	vbroadcastsd	272(%rdx), %ymm5
	vmovapd	128000(%r15), %ymm1
	vbroadcastsd	280(%rdx), %ymm3
	vbroadcastsd	256(%rdx), %ymm10
	vbroadcastsd	264(%rdx), %ymm9
	vfmadd132pd	%ymm1, %ymm4, %ymm5
	vfmadd132pd	%ymm1, %ymm0, %ymm10
	vfmadd132pd	%ymm1, %ymm2, %ymm9
	vfmadd132pd	%ymm3, %ymm6, %ymm1
	vmovapd	256000(%r15), %ymm0
	vbroadcastsd	512(%rdx), %ymm8
	vbroadcastsd	520(%rdx), %ymm7
	vbroadcastsd	536(%rdx), %ymm3
	vmovapd	%ymm5, %ymm2
	vbroadcastsd	528(%rdx), %ymm5
	vfmadd132pd	%ymm0, %ymm1, %ymm3
	vfmadd132pd	%ymm0, %ymm2, %ymm5
	vfmadd132pd	%ymm0, %ymm10, %ymm8
	vfmadd132pd	%ymm0, %ymm9, %ymm7
	vbroadcastsd	776(%rdx), %ymm2
	vbroadcastsd	768(%rdx), %ymm0
	vbroadcastsd	784(%rdx), %ymm4
	vbroadcastsd	792(%rdx), %ymm6
	vmovapd	384000(%r15), %ymm1
	addq	$1024, %rdx
	vfmadd132pd	%ymm1, %ymm8, %ymm0
	vfmadd132pd	%ymm1, %ymm7, %ymm2
	vfmadd132pd	%ymm1, %ymm5, %ymm4
	vfmadd132pd	%ymm1, %ymm3, %ymm6
	addq	$512000, %r15
	vmovapd	%ymm0, 32(%rsp)
	vmovapd	%ymm2, 64(%rsp)
	vmovapd	%ymm4, 96(%rsp)
	vmovapd	%ymm6, 128(%rsp)
	cmpq	%rdx, %rsi
	jne	.L5
	movq	%r8, %rdx
	leaq	-32(%r13), %r15
.L6:
	vmovapd	(%rdx), %ymm7
	addq	$32, %rdx
	vmovapd	%ymm7, (%r15)
	addq	$128000, %r15
	cmpq	%rdx, %rcx
	jne	.L6
	vxorpd	%xmm6, %xmm6, %xmm6
	movq	%rdi, %rdx
	movq	%r10, %r15
	vmovapd	%ymm6, %ymm4
	vmovapd	%ymm6, %ymm2
	vmovapd	%ymm6, %ymm0
.L7:
	vbroadcastsd	8(%rdx), %ymm3
	vmovapd	(%r15), %ymm8
	vbroadcastsd	(%rdx), %ymm1
	vbroadcastsd	16(%rdx), %ymm5
	vbroadcastsd	24(%rdx), %ymm7
	vfmadd231pd	%ymm8, %ymm3, %ymm2
	vfmadd231pd	%ymm8, %ymm1, %ymm0
	vfmadd231pd	%ymm8, %ymm5, %ymm4
	vfmadd231pd	%ymm8, %ymm7, %ymm6
	vbroadcastsd	272(%rdx), %ymm5
	vbroadcastsd	264(%rdx), %ymm9
	vmovapd	128000(%r15), %ymm1
	vbroadcastsd	280(%rdx), %ymm3
	vbroadcastsd	256(%rdx), %ymm10
	vfmadd132pd	%ymm1, %ymm2, %ymm9
	vmovapd	%ymm5, %ymm2
	vfmadd132pd	%ymm1, %ymm4, %ymm2
	vfmadd132pd	%ymm1, %ymm0, %ymm10
	vfmadd132pd	%ymm3, %ymm6, %ymm1
	vmovapd	256000(%r15), %ymm0
	vbroadcastsd	512(%rdx), %ymm8
	vbroadcastsd	520(%rdx), %ymm7
	vbroadcastsd	528(%rdx), %ymm5
	vbroadcastsd	536(%rdx), %ymm3
	vfmadd132pd	%ymm0, %ymm2, %ymm5
	vfmadd132pd	%ymm0, %ymm1, %ymm3
	vfmadd132pd	%ymm0, %ymm10, %ymm8
	vfmadd132pd	%ymm0, %ymm9, %ymm7
	vbroadcastsd	776(%rdx), %ymm2
	vbroadcastsd	768(%rdx), %ymm0
	vbroadcastsd	784(%rdx), %ymm4
	vbroadcastsd	792(%rdx), %ymm6
	vmovapd	384000(%r15), %ymm1
	addq	$1024, %rdx
	vfmadd132pd	%ymm1, %ymm8, %ymm0
	vfmadd132pd	%ymm1, %ymm7, %ymm2
	vfmadd132pd	%ymm1, %ymm5, %ymm4
	vfmadd132pd	%ymm1, %ymm3, %ymm6
	addq	$512000, %r15
	vmovapd	%ymm0, 32(%rsp)
	vmovapd	%ymm2, 64(%rsp)
	vmovapd	%ymm4, 96(%rsp)
	vmovapd	%ymm6, 128(%rsp)
	cmpq	%rdx, %rsi
	jne	.L7
	movq	%r8, %rdx
	movq	%r13, %r15
.L8:
	vmovapd	(%rdx), %ymm7
	addq	$32, %rdx
	vmovapd	%ymm7, (%r15)
	addq	$128000, %r15
	cmpq	%rdx, %rcx
	jne	.L8
	addq	$32, %rsi
	addq	$512000, %r13
	addq	$32, %rdi
	cmpq	%rsi, %r11
	jne	.L3
	addl	%eax, %r14d
	addq	%r12, %r10
	addq	%r12, %rbx
	addq	%r12, %r9
	cmpl	$3999, %r14d
	jle	.L4
	vzeroupper
.L17:
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
	.size	matmul_row._omp_fn.0, .-matmul_row._omp_fn.0
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
.L21:
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
	jne	.L21
	vzeroupper
	ret
	.cfi_endproc
.LFE6393:
	.size	transpose, .-transpose
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
	subq	$576, %rsp
	.cfi_def_cfa_offset 608
	movq	%rsp, %rdi
	call	posix_memalign@PLT
	leaq	8(%rsp), %rdi
	movl	$262144000, %edx
	movl	$64, %esi
	call	posix_memalign@PLT
	leaq	16(%rsp), %rdi
	movl	$64, %esi
	movl	$4096000, %edx
	call	posix_memalign@PLT
	movq	8(%rsp), %rsi
	movq	(%rsp), %rdi
	call	prepare@PLT
	testl	%eax, %eax
	jne	.L38
	leaq	24(%rsp), %rdi
	movl	%eax, %ebx
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	leaq	64(%rsp), %rdi
	movl	$512, %edx
	xorl	%esi, %esi
	call	memset@PLT
	.p2align 4,,10
	.p2align 3
.L28:
	call	rand@PLT
	cltd
	shrl	$25, %edx
	addl	%edx, %eax
	andl	$127, %eax
	subl	%edx, %eax
	cltq
	movl	64(%rsp,%rax,4), %ebp
	testl	%ebp, %ebp
	jne	.L28
	movl	%ebx, 64(%rsp,%rax,4)
	incl	%ebx
	cmpl	$128, %ebx
	jne	.L28
	movl	$65536, %esi
	leaq	.LC1(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
	xorl	%eax, %eax
	call	start_perf@PLT
	leaq	32(%rsp), %r12
	leaq	matmul_row._omp_fn.0(%rip), %rbx
	.p2align 4,,10
	.p2align 3
.L30:
	movl	%ebp, %eax
	andl	$127, %eax
	vmovq	16(%rsp), %xmm1
	imulq	$256000, %rax, %rax
	movq	8(%rsp), %rdx
	vpinsrq	$1, (%rsp), %xmm1, %xmm0
	leaq	(%rdx,%rax,8), %rax
	xorl	%ecx, %ecx
	movl	$6, %edx
	movq	%r12, %rsi
	movq	%rbx, %rdi
	incl	%ebp
	movq	%rax, 48(%rsp)
	vmovdqa	%xmm0, 32(%rsp)
	call	GOMP_parallel@PLT
	cmpl	$65536, %ebp
	jne	.L30
	xorl	%eax, %eax
	call	end_perf@PLT
	movq	16(%rsp), %rdi
	call	writeback@PLT
	testl	%eax, %eax
	jne	.L39
	movq	16(%rsp), %rdi
	call	check@PLT
	movl	%eax, %ebx
	testl	%eax, %eax
	jne	.L40
	movq	(%rsp), %rdi
	call	free@PLT
	movq	8(%rsp), %rdi
	call	free@PLT
	movq	16(%rsp), %rdi
	call	free@PLT
.L25:
	addq	$576, %rsp
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
.L38:
	.cfi_restore_state
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
.L27:
	orl	$-1, %ebx
	jmp	.L25
.L40:
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	jmp	.L27
.L39:
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	jmp	.L27
	.cfi_endproc
.LFE6396:
	.size	main, .-main
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
