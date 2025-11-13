	.arch armv9-a+crc
	.file	"test.c"
	.text
	.align	2
	.p2align 4,,11
	.global	matmul_worker
	.type	matmul_worker, %function
matmul_worker:
.LFB0:
	.cfi_startproc
	sbfiz	x3, x3, 5, 32
	sub	sp, sp, #160
	.cfi_def_cfa_offset 160
	add	x1, x1, x3
	add	x9, sp, 96
	add	x12, x1, 126976
	add	x11, x1, 253952
	add	x10, x1, 380928
	add	x12, x12, 1024
	add	x11, x11, 2048
	add	x10, x10, 3072
	mov	x5, sp
	add	x8, sp, 64
	add	x7, sp, 128
	add	x6, sp, 32
	mov	x4, 0
	stp	xzr, xzr, [sp, 32]
	stp	xzr, xzr, [sp, 48]
	stp	xzr, xzr, [sp, 64]
	stp	xzr, xzr, [sp, 80]
	stp	xzr, xzr, [sp, 96]
	stp	xzr, xzr, [sp, 112]
	stp	xzr, xzr, [sp, 128]
	stp	xzr, xzr, [sp, 144]
.L2:
	add	x16, x1, x4
	ldr	q25, [x1, x4]
	add	x15, x12, x4
	ldr	q21, [x16, 16]
	add	x14, x11, x4
	ldp	q0, q1, [sp, 96]
	add	x13, x10, x4
	ld1r	{v2.2d}, [x0]
	ldr	q19, [x12, x4]
	ldr	q18, [x15, 16]
	ldp	d6, d24, [x0, 256]
	fmla	v1.2d, v21.2d, v2.2d
	ldr	d20, [x0, 768]
	fmla	v0.2d, v2.2d, v25.2d
	ldr	d2, [x0, 512]
	ldp	d3, d23, [x0, 8]
	ldp	q4, q5, [sp, 64]
	ldr	q17, [x11, x4]
	ldr	q16, [x14, 16]
	fmla	v1.2d, v18.2d, v6.d[0]
	ldr	d22, [x0, 520]
	fmla	v0.2d, v19.2d, v6.d[0]
	ldr	d28, [x0, 272]
	fmla	v4.2d, v25.2d, v3.d[0]
	ldr	d27, [x0, 24]
	fmla	v5.2d, v21.2d, v3.d[0]
	ldr	d26, [x0, 528]
	ldr	q6, [x10, x4]
	add	x4, x4, 512000
	ldr	q7, [x13, 16]
	fmla	v1.2d, v16.2d, v2.d[0]
	fmla	v0.2d, v17.2d, v2.d[0]
	ldp	q3, q2, [sp, 128]
	fmla	v4.2d, v19.2d, v24.d[0]
	fmla	v5.2d, v18.2d, v24.d[0]
	ldr	d24, [x0, 280]
	fmla	v1.2d, v7.2d, v20.d[0]
	fmla	v0.2d, v6.2d, v20.d[0]
	ldr	d20, [x0, 536]
	fmla	v3.2d, v25.2d, v23.d[0]
	add	x0, x0, 1024
	fmla	v2.2d, v21.2d, v23.d[0]
	fmla	v5.2d, v16.2d, v22.d[0]
	fmla	v4.2d, v17.2d, v22.d[0]
	stp	q0, q1, [sp]
	ldp	q0, q1, [sp, 32]
	ldp	q22, q23, [x5]
	fmla	v3.2d, v19.2d, v28.d[0]
	ldr	d29, [x0, -248]
	fmla	v2.2d, v18.2d, v28.d[0]
	fmla	v0.2d, v25.2d, v27.d[0]
	stp	q22, q23, [x9]
	fmla	v5.2d, v7.2d, v29.d[0]
	fmla	v4.2d, v6.2d, v29.d[0]
	fmla	v1.2d, v21.2d, v27.d[0]
	fmla	v2.2d, v16.2d, v26.d[0]
	fmla	v3.2d, v17.2d, v26.d[0]
	fmla	v0.2d, v19.2d, v24.d[0]
	stp	q4, q5, [sp]
	ldr	d4, [x0, -240]
	fmla	v1.2d, v18.2d, v24.d[0]
	fmla	v2.2d, v7.2d, v4.d[0]
	fmla	v3.2d, v6.2d, v4.d[0]
	fmla	v1.2d, v16.2d, v20.d[0]
	fmla	v0.2d, v17.2d, v20.d[0]
	ldp	q5, q16, [x5]
	stp	q3, q2, [sp]
	ldr	d2, [x0, -232]
	ldp	q3, q4, [x5]
	stp	q5, q16, [x8]
	fmla	v1.2d, v7.2d, v2.d[0]
	fmla	v0.2d, v6.2d, v2.d[0]
	stp	q3, q4, [x7]
	stp	q0, q1, [sp]
	ldp	q0, q1, [x5]
	stp	q0, q1, [x6]
	cmp	x4, 2048000
	bne	.L2
	add	x0, x2, x3
	add	x3, x0, 126976
	add	x2, x0, 253952
	add	x3, x3, 1024
	add	x2, x2, 2048
	add	x1, x0, 380928
	stp	q22, q23, [x0]
	add	x1, x1, 3072
	stp	q5, q16, [x3]
	stp	q3, q4, [x2]
	stp	q0, q1, [x1]
	add	sp, sp, 160
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	matmul_worker, .-matmul_worker
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
