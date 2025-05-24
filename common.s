	.file	"common.c"
	.text
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
.LFB12:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leaq	.LC0(%rip), %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r12
	movq	%r13, %rsi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdi, %rbp
	leaq	.LC1(%rip), %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	call	fopen@PLT
	testq	%rax, %rax
	je	.L5
	testq	%rbp, %rbp
	je	.L5
	movq	%rax, %rcx
	movl	$512, %edx
	movl	$8, %esi
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	fread@PLT
	movq	%rbx, %rdi
	call	fclose@PLT
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movq	%r13, %rsi
	leaq	.LC3(%rip), %rdi
	call	fopen@PLT
	movq	%rax, %rbx
	testq	%rax, %rax
	je	.L5
	testq	%r12, %r12
	je	.L5
	movq	%rax, %rcx
	movl	$256000, %edx
	movl	$8, %esi
	movq	%r12, %rdi
	call	fread@PLT
	movq	%rbx, %rdi
	call	fclose@PLT
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	xorl	%eax, %eax
.L1:
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
	.p2align 4,,10
	.p2align 3
.L5:
	.cfi_restore_state
	movl	$-1, %eax
	jmp	.L1
	.cfi_endproc
.LFE12:
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
.LFB13:
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
	je	.L19
	testq	%rbp, %rbp
	je	.L19
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
.L17:
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
.L19:
	.cfi_restore_state
	movl	$-1, %eax
	jmp	.L17
	.cfi_endproc
.LFE13:
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
.LFB14:
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
	je	.L28
	testq	%r13, %r13
	je	.L28
	movq	%rax, %r12
	xorl	%ebx, %ebx
	leaq	8(%rsp), %r14
	jmp	.L31
	.p2align 4,,10
	.p2align 3
.L29:
	addq	$1, %rbx
	cmpq	$512000, %rbx
	je	.L30
.L31:
	movq	%r12, %rcx
	movl	$1, %edx
	movl	$8, %esi
	movq	%r14, %rdi
	call	fread@PLT
	movsd	0(%r13,%rbx,8), %xmm0
	subsd	8(%rsp), %xmm0
	cvttsd2sil	%xmm0, %ebp
	testl	%ebp, %ebp
	je	.L29
	movl	%ebx, %esi
	leaq	.LC9(%rip), %rdi
	xorl	%eax, %eax
	movl	$-1, %ebp
	call	printf@PLT
.L30:
	movq	%r12, %rdi
	call	fclose@PLT
	leaq	.LC10(%rip), %rdi
	call	puts@PLT
.L27:
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
.L28:
	.cfi_restore_state
	leaq	.LC11(%rip), %rdi
	movl	$-1, %ebp
	call	puts@PLT
	jmp	.L27
	.cfi_endproc
.LFE14:
	.size	check, .-check
	.p2align 4
	.globl	get_time
	.type	get_time, @function
get_time:
.LFB15:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%esi, %esi
	movq	%rsp, %rdi
	call	gettimeofday@PLT
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	8(%rsp), %xmm0
	mulsd	.LC12(%rip), %xmm0
	cvtsi2sdq	(%rsp), %xmm1
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	addsd	%xmm1, %xmm0
	ret
	.cfi_endproc
.LFE15:
	.size	get_time, .-get_time
	.p2align 4
	.globl	start_perf
	.type	start_perf, @function
start_perf:
.LFB16:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%esi, %esi
	movq	%rsp, %rdi
	call	gettimeofday@PLT
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	8(%rsp), %xmm0
	mulsd	.LC12(%rip), %xmm0
	cvtsi2sdq	(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, timestamp(%rip)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE16:
	.size	start_perf, .-start_perf
	.section	.rodata.str1.1
.LC13:
	.string	"times: %.6lfs\n"
	.text
	.p2align 4
	.globl	end_perf
	.type	end_perf, @function
end_perf:
.LFB17:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%esi, %esi
	movq	%rsp, %rdi
	call	gettimeofday@PLT
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	leaq	.LC13(%rip), %rdi
	cvtsi2sdq	8(%rsp), %xmm0
	mulsd	.LC12(%rip), %xmm0
	movl	$1, %eax
	cvtsi2sdq	(%rsp), %xmm1
	addsd	%xmm1, %xmm0
	subsd	timestamp(%rip), %xmm0
	movsd	%xmm0, timestamp(%rip)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	jmp	printf@PLT
	.cfi_endproc
.LFE17:
	.size	end_perf, .-end_perf
	.local	timestamp
	.comm	timestamp,8,8
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC12:
	.long	-1598689907
	.long	1051772663
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
