	.file	"common.c"
	.text
	.p2align 4
	.globl	prefetch
	.type	prefetch, @function
prefetch:
.LFB6393:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L8
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L3:
	addq	$1, %rax
	prefetcht2	(%rdi)
	addq	$64, %rdi
	cmpq	%rax, %rsi
	jne	.L3
.L8:
	ret
	.cfi_endproc
.LFE6393:
	.size	prefetch, .-prefetch
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"rb"
.LC1:
	.string	"input_A.bin"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"matrix A has been read from input_A.bin"
	.section	.rodata.str1.1
.LC3:
	.string	"input_B.bin"
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"matrix B has been read from input_B.bin"
	.text
	.p2align 4
	.globl	prepare
	.type	prepare, @function
prepare:
.LFB6394:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leaq	.LC0(%rip), %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rdi, %r12
	leaq	.LC1(%rip), %rdi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rsi, %rbx
	movq	%r13, %rsi
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	call	fopen@PLT
	testq	%rax, %rax
	je	.L14
	testq	%r12, %r12
	je	.L14
	movq	%rax, %rcx
	movl	$512, %edx
	movl	$8, %esi
	movq	%rax, %rbp
	movq	%r12, %rdi
	call	fread@PLT
	movq	%rbp, %rdi
	call	fclose@PLT
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movq	%r13, %rsi
	leaq	.LC3(%rip), %rdi
	call	fopen@PLT
	testq	%rax, %rax
	movq	%rax, %rbp
	je	.L14
	testq	%rbx, %rbx
	je	.L14
	movl	$256000, %edx
	movq	%rax, %rcx
	movl	$8, %esi
	movq	%rbx, %rdi
	call	fread@PLT
	movq	%rbx, %rax
	leaq	256000(%rbx), %rdx
	.p2align 4,,10
	.p2align 3
.L15:
	prefetcht2	(%rax)
	addq	$64, %rax
	cmpq	%rdx, %rax
	jne	.L15
	movq	%rbp, %rdi
	call	fclose@PLT
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	xorl	%eax, %eax
.L10:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L14:
	.cfi_restore_state
	movl	$-1, %eax
	jmp	.L10
	.cfi_endproc
.LFE6394:
	.size	prepare, .-prepare
	.section	.rodata.str1.1
.LC5:
	.string	"wb"
.LC6:
	.string	"result_C.bin"
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"result has been write to result_C.bin"
	.text
	.p2align 4
	.globl	writeback
	.type	writeback, @function
writeback:
.LFB6395:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	.LC5(%rip), %rsi
	movq	%rdi, %rbp
	leaq	.LC6(%rip), %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	fopen@PLT
	testq	%rax, %rax
	je	.L29
	testq	%rbp, %rbp
	je	.L29
	movq	%rax, %rcx
	movl	$512000, %edx
	movl	$8, %esi
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	fwrite@PLT
	movq	%rbx, %rdi
	call	fclose@PLT
	leaq	.LC7(%rip), %rdi
	call	puts@PLT
	xorl	%eax, %eax
.L27:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L29:
	.cfi_restore_state
	movl	$-1, %eax
	jmp	.L27
	.cfi_endproc
.LFE6395:
	.size	writeback, .-writeback
	.section	.rodata.str1.1
.LC8:
	.string	"result_C_std.bin"
.LC9:
	.string	"mismatch at %d\n"
.LC10:
	.string	"result has been fully tested"
	.section	.rodata.str1.8
	.align 8
.LC11:
	.string	"failed to read std result file"
	.text
	.p2align 4
	.globl	check
	.type	check, @function
check:
.LFB6396:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	leaq	.LC0(%rip), %rsi
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r13
	leaq	.LC8(%rip), %rdi
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp
	.cfi_def_cfa_offset 64
	call	fopen@PLT
	testq	%rax, %rax
	je	.L38
	testq	%r13, %r13
	je	.L38
	movq	%rax, %r12
	xorl	%ebx, %ebx
	leaq	8(%rsp), %r14
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L39:
	addq	$1, %rbx
	cmpq	$512000, %rbx
	je	.L40
.L41:
	movq	%r12, %rcx
	movl	$1, %edx
	movl	$8, %esi
	movq	%r14, %rdi
	call	fread@PLT
	vmovsd	0(%r13,%rbx,8), %xmm0
	vsubsd	8(%rsp), %xmm0, %xmm0
	vcvttsd2sil	%xmm0, %ebp
	testl	%ebp, %ebp
	je	.L39
	movl	%ebx, %esi
	leaq	.LC9(%rip), %rdi
	xorl	%eax, %eax
	movl	$-1, %ebp
	call	printf@PLT
.L40:
	movq	%r12, %rdi
	call	fclose@PLT
	leaq	.LC10(%rip), %rdi
	call	puts@PLT
.L37:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	movl	%ebp, %eax
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
.L38:
	.cfi_restore_state
	leaq	.LC11(%rip), %rdi
	movl	$-1, %ebp
	call	puts@PLT
	jmp	.L37
	.cfi_endproc
.LFE6396:
	.size	check, .-check
	.p2align 4
	.globl	get_time
	.type	get_time, @function
get_time:
.LFB6397:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%esi, %esi
	movq	%rsp, %rdi
	call	gettimeofday@PLT
	vxorps	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	8(%rsp), %xmm1, %xmm0
	vmulsd	.LC12(%rip), %xmm0, %xmm0
	vcvtsi2sdq	(%rsp), %xmm1, %xmm1
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	vaddsd	%xmm1, %xmm0, %xmm0
	ret
	.cfi_endproc
.LFE6397:
	.size	get_time, .-get_time
	.p2align 4
	.globl	start_perf
	.type	start_perf, @function
start_perf:
.LFB6398:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%esi, %esi
	movq	%rsp, %rdi
	call	gettimeofday@PLT
	vxorps	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	8(%rsp), %xmm1, %xmm0
	vmulsd	.LC12(%rip), %xmm0, %xmm0
	vcvtsi2sdq	(%rsp), %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, timestamp(%rip)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6398:
	.size	start_perf, .-start_perf
	.section	.rodata.str1.1
.LC13:
	.string	"times: %.6lfs\n"
	.text
	.p2align 4
	.globl	end_perf
	.type	end_perf, @function
end_perf:
.LFB6399:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%esi, %esi
	movq	%rsp, %rdi
	call	gettimeofday@PLT
	vxorps	%xmm1, %xmm1, %xmm1
	movl	$1, %eax
	leaq	.LC13(%rip), %rdi
	vcvtsi2sdq	8(%rsp), %xmm1, %xmm0
	vmulsd	.LC12(%rip), %xmm0, %xmm0
	vcvtsi2sdq	(%rsp), %xmm1, %xmm1
	vaddsd	%xmm1, %xmm0, %xmm0
	vsubsd	timestamp(%rip), %xmm0, %xmm0
	vmovsd	%xmm0, timestamp(%rip)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	jmp	printf@PLT
	.cfi_endproc
.LFE6399:
	.size	end_perf, .-end_perf
	.local	timestamp
	.comm	timestamp,8,8
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC12:
	.long	-1598689907
	.long	1051772663
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
