	.file	"common.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"r"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC1:
	.string	"/sys/devices/system/cpu/cpu0/cache/index3/size"
	.section	.rodata.str1.1
.LC2:
	.string	"%d"
.LC3:
	.string	"l3_cache_size: %d\n"
.LC4:
	.string	"failed to get L3 cache size"
	.text
	.p2align 4
	.globl	get_cache_size
	.type	get_cache_size, @function
get_cache_size:
.LFB6393:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	leaq	.LC0(%rip), %rsi
	leaq	.LC1(%rip), %rdi
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movl	$0, 12(%rsp)
	call	fopen@PLT
	testq	%rax, %rax
	je	.L2
	leaq	.LC2(%rip), %rsi
	movq	%rax, %rdi
	movq	%rax, %rbx
	leaq	12(%rsp), %rdx
	xorl	%eax, %eax
	call	__isoc99_fscanf@PLT
	movq	%rbx, %rdi
	call	fclose@PLT
	movl	12(%rsp), %esi
	leaq	.LC3(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
.L3:
	movl	12(%rsp), %eax
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L2:
	.cfi_restore_state
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	jmp	.L3
	.cfi_endproc
.LFE6393:
	.size	get_cache_size, .-get_cache_size
	.p2align 4
	.globl	prefetch
	.type	prefetch, @function
prefetch:
.LFB6394:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L13
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L8:
	prefetcht0	(%rdi,%rax)
	addq	$64, %rax
	cmpq	%rsi, %rax
	jb	.L8
.L13:
	ret
	.cfi_endproc
.LFE6394:
	.size	prefetch, .-prefetch
	.p2align 4
	.globl	flush
	.type	flush, @function
flush:
.LFB6395:
	.cfi_startproc
	testl	%esi, %esi
	jle	.L15
	decl	%esi
	shrl	$6, %esi
	salq	$6, %rsi
	leaq	64(%rdi,%rsi), %rax
	.p2align 4,,10
	.p2align 3
.L16:
	clflushopt	(%rdi)
	addq	$64, %rdi
	cmpq	%rax, %rdi
	jne	.L16
.L15:
	sfence
	ret
	.cfi_endproc
.LFE6395:
	.size	flush, .-flush
	.section	.rodata.str1.1
.LC5:
	.string	"rb"
.LC6:
	.string	"input_A.bin"
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"matrix A has been read from input_A.bin"
	.section	.rodata.str1.1
.LC8:
	.string	"input_B.bin"
	.section	.rodata.str1.8
	.align 8
.LC9:
	.string	"matrix B has been read from input_B.bin"
	.text
	.p2align 4
	.globl	prepare
	.type	prepare, @function
prepare:
.LFB6396:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	leaq	.LC5(%rip), %r13
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r12
	movq	%r13, %rsi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdi, %rbp
	leaq	.LC6(%rip), %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	call	fopen@PLT
	testq	%rax, %rax
	je	.L22
	testq	%rbp, %rbp
	je	.L22
	movq	%rax, %rcx
	movl	$512, %edx
	movl	$8, %esi
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	fread@PLT
	movq	%rbx, %rdi
	call	fclose@PLT
	leaq	.LC7(%rip), %rdi
	call	puts@PLT
	movq	%r13, %rsi
	leaq	.LC8(%rip), %rdi
	call	fopen@PLT
	movq	%rax, %rbx
	testq	%rax, %rax
	je	.L22
	testq	%r12, %r12
	je	.L22
	movq	%rax, %rcx
	movl	$32768000, %edx
	movl	$8, %esi
	movq	%r12, %rdi
	call	fread@PLT
	movq	%rbx, %rdi
	call	fclose@PLT
	leaq	.LC9(%rip), %rdi
	call	puts@PLT
	xorl	%eax, %eax
.L18:
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
.L22:
	.cfi_restore_state
	movl	$-1, %eax
	jmp	.L18
	.cfi_endproc
.LFE6396:
	.size	prepare, .-prepare
	.section	.rodata.str1.1
.LC10:
	.string	"wb"
.LC11:
	.string	"result_C.bin"
	.section	.rodata.str1.8
	.align 8
.LC12:
	.string	"result has been write to result_C.bin"
	.text
	.p2align 4
	.globl	writeback
	.type	writeback, @function
writeback:
.LFB6397:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	.LC10(%rip), %rsi
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	leaq	.LC11(%rip), %rdi
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	fopen@PLT
	testq	%rax, %rax
	je	.L35
	testq	%rbp, %rbp
	je	.L35
	movq	%rax, %rcx
	movl	$512000, %edx
	movl	$8, %esi
	movq	%rax, %rbx
	movq	%rbp, %rdi
	call	fwrite@PLT
	movq	%rbx, %rdi
	call	fclose@PLT
	leaq	.LC12(%rip), %rdi
	call	puts@PLT
	xorl	%eax, %eax
.L33:
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
.L35:
	.cfi_restore_state
	movl	$-1, %eax
	jmp	.L33
	.cfi_endproc
.LFE6397:
	.size	writeback, .-writeback
	.section	.rodata.str1.1
.LC13:
	.string	"result_C_std.bin"
.LC14:
	.string	"mismatch at %d\n"
.LC15:
	.string	"result has been fully tested"
	.section	.rodata.str1.8
	.align 8
.LC16:
	.string	"failed to read std result file"
	.text
	.p2align 4
	.globl	check
	.type	check, @function
check:
.LFB6398:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	leaq	.LC5(%rip), %rsi
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdi, %r13
	leaq	.LC13(%rip), %rdi
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
	je	.L44
	testq	%r13, %r13
	je	.L44
	movq	%rax, %r12
	xorl	%ebx, %ebx
	leaq	8(%rsp), %r14
	jmp	.L47
	.p2align 4,,10
	.p2align 3
.L45:
	incq	%rbx
	cmpq	$512000, %rbx
	je	.L46
.L47:
	movq	%r12, %rcx
	movl	$1, %edx
	movl	$8, %esi
	movq	%r14, %rdi
	call	fread@PLT
	vmovsd	0(%r13,%rbx,8), %xmm0
	vsubsd	8(%rsp), %xmm0, %xmm0
	vcvttsd2sil	%xmm0, %ebp
	testl	%ebp, %ebp
	je	.L45
	movl	%ebx, %esi
	leaq	.LC14(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
	movl	$-1, %ebp
.L46:
	movq	%r12, %rdi
	call	fclose@PLT
	leaq	.LC15(%rip), %rdi
	call	puts@PLT
.L43:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	movl	%ebp, %eax
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L44:
	.cfi_restore_state
	leaq	.LC16(%rip), %rdi
	call	puts@PLT
	movl	$-1, %ebp
	jmp	.L43
	.cfi_endproc
.LFE6398:
	.size	check, .-check
	.p2align 4
	.globl	get_time
	.type	get_time, @function
get_time:
.LFB6399:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rdi
	xorl	%esi, %esi
	call	gettimeofday@PLT
	vxorps	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	8(%rsp), %xmm1, %xmm0
	vcvtsi2sdq	(%rsp), %xmm1, %xmm1
	vmulsd	.LC17(%rip), %xmm0, %xmm0
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	vaddsd	%xmm1, %xmm0, %xmm0
	ret
	.cfi_endproc
.LFE6399:
	.size	get_time, .-get_time
	.p2align 4
	.globl	start_perf
	.type	start_perf, @function
start_perf:
.LFB6400:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rdi
	xorl	%esi, %esi
	call	gettimeofday@PLT
	vxorps	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	8(%rsp), %xmm1, %xmm0
	vcvtsi2sdq	(%rsp), %xmm1, %xmm1
	vmulsd	.LC17(%rip), %xmm0, %xmm0
	vaddsd	%xmm1, %xmm0, %xmm0
	vmovsd	%xmm0, timestamp(%rip)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6400:
	.size	start_perf, .-start_perf
	.section	.rodata.str1.1
.LC18:
	.string	"times: %.6lfs\n"
	.text
	.p2align 4
	.globl	end_perf
	.type	end_perf, @function
end_perf:
.LFB6401:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsp, %rdi
	xorl	%esi, %esi
	call	gettimeofday@PLT
	vxorps	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	8(%rsp), %xmm1, %xmm0
	vcvtsi2sdq	(%rsp), %xmm1, %xmm1
	leaq	.LC18(%rip), %rdi
	movl	$1, %eax
	vmulsd	.LC17(%rip), %xmm0, %xmm0
	vaddsd	%xmm1, %xmm0, %xmm0
	vsubsd	timestamp(%rip), %xmm0, %xmm0
	vmovsd	%xmm0, timestamp(%rip)
	call	printf@PLT
	vmovsd	timestamp(%rip), %xmm0
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6401:
	.size	end_perf, .-end_perf
	.local	timestamp
	.comm	timestamp,8,8
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC17:
	.long	-1598689907
	.long	1051772663
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
