// Generated by PeachPy 0.2.0 from sum.py


// func permuteSSE(vptr uintptr, permuted_ptr uintptr)
TEXT ·permuteSSE(SB),4,$0-16
	MOVQ vptr+0(FP), AX
	MOVQ permuted_ptr+8(FP), BX
	MOVOU 16(AX), X0
	MOVOU 0(AX), X1
	PSHUFL $177, X0, X0
	PSHUFL $177, X1, X1
	MOVOU X0, 0(BX)
	MOVOU X1, 16(BX)
	RET

// func zipperSSE(mul0 uintptr, v0 uintptr)
TEXT ·zipperSSE(SB),4,$0-16
	MOVQ mul0+0(FP), AX
	MOVQ v0+8(FP), BX
	MOVOU 0(AX), X0
	MOVOU 16(AX), X1
	MOVQ $4223284375849987, AX
	MOVQ AX, X2
	MOVQ $506661594022413323, AX
	MOVQ AX, X3
	MOVLHPS X3, X2
	MOVO X0, X0
	PSHUFB X2, X0
	MOVO X1, X1
	PSHUFB X2, X1
	MOVOU X0, 0(BX)
	MOVOU X1, 16(BX)
	RET

// func updateSSE(sptr uintptr, p_base uintptr, p_len int64, p_cap int64)
TEXT ·updateSSE(SB),4,$0-32
	MOVQ sptr+0(FP), AX
	MOVQ p_base+8(FP), BX
	MOVOU 0(AX), X0
	MOVOU 16(AX), X1
	MOVOU 32(AX), X2
	MOVOU 48(AX), X3
	MOVOU 64(AX), X4
	MOVOU 80(AX), X5
	MOVOU 96(AX), X6
	MOVOU 112(AX), X7
	MOVOU 0(BX), X8
	MOVOU 16(BX), X9
	PADDQ X8, X2
	PADDQ X9, X3
	PADDQ X4, X2
	PADDQ X5, X3
	MOVO X0, X10
	MOVO X1, X11
	MOVO X2, X8
	MOVO X3, X9
	PSRLQ $32, X8
	PSRLQ $32, X9
	PMULULQ X10, X8
	PMULULQ X11, X9
	PXOR X8, X4
	PXOR X9, X5
	PADDQ X6, X0
	PADDQ X7, X1
	MOVO X2, X10
	MOVO X3, X11
	MOVO X0, X8
	MOVO X1, X9
	PSRLQ $32, X8
	PSRLQ $32, X9
	PMULULQ X10, X8
	PMULULQ X11, X9
	PXOR X8, X6
	PXOR X9, X7
	MOVQ $4223284375849987, BX
	MOVQ BX, X10
	MOVQ $506661594022413323, BX
	MOVQ BX, X8
	MOVLHPS X8, X10
	MOVO X2, X8
	PSHUFB X10, X8
	MOVO X3, X9
	PSHUFB X10, X9
	PADDQ X8, X0
	PADDQ X9, X1
	MOVO X0, X8
	PSHUFB X10, X8
	MOVO X1, X9
	PSHUFB X10, X9
	PADDQ X8, X2
	PADDQ X9, X3
	MOVOU X0, 0(AX)
	MOVOU X1, 16(AX)
	MOVOU X2, 32(AX)
	MOVOU X3, 48(AX)
	MOVOU X4, 64(AX)
	MOVOU X5, 80(AX)
	MOVOU X6, 96(AX)
	MOVOU X7, 112(AX)
	RET

// func updateStateSSE(sptr uintptr, p_base uintptr, p_len int64, p_cap int64)
TEXT ·updateStateSSE(SB),4,$0-32
	MOVQ sptr+0(FP), AX
	MOVQ p_base+8(FP), BX
	MOVQ p_len+16(FP), CX
	MOVOU 0(AX), X0
	MOVOU 16(AX), X1
	MOVOU 32(AX), X2
	MOVOU 48(AX), X3
	MOVOU 64(AX), X4
	MOVOU 80(AX), X5
	MOVOU 96(AX), X6
	MOVOU 112(AX), X7
	CMPQ CX, $0
	JEQ loop_end
loop_begin:
		MOVOU 0(BX), X8
		MOVOU 16(BX), X9
		PADDQ X8, X2
		PADDQ X9, X3
		PADDQ X4, X2
		PADDQ X5, X3
		MOVO X0, X10
		MOVO X1, X11
		MOVO X2, X8
		MOVO X3, X9
		PSRLQ $32, X8
		PSRLQ $32, X9
		PMULULQ X10, X8
		PMULULQ X11, X9
		PXOR X8, X4
		PXOR X9, X5
		PADDQ X6, X0
		PADDQ X7, X1
		MOVO X2, X10
		MOVO X3, X11
		MOVO X0, X8
		MOVO X1, X9
		PSRLQ $32, X8
		PSRLQ $32, X9
		PMULULQ X10, X8
		PMULULQ X11, X9
		PXOR X8, X6
		PXOR X9, X7
		MOVQ $4223284375849987, DX
		MOVQ DX, X10
		MOVQ $506661594022413323, DX
		MOVQ DX, X8
		MOVLHPS X8, X10
		MOVO X2, X8
		PSHUFB X10, X8
		MOVO X3, X9
		PSHUFB X10, X9
		PADDQ X8, X0
		PADDQ X9, X1
		MOVO X0, X8
		PSHUFB X10, X8
		MOVO X1, X9
		PSHUFB X10, X9
		PADDQ X8, X2
		PADDQ X9, X3
		ADDQ $32, BX
		SUBQ $32, CX
		CMPQ CX, $0
		JNE loop_begin
loop_end:
	MOVOU X0, 0(AX)
	MOVOU X1, 16(AX)
	MOVOU X2, 32(AX)
	MOVOU X3, 48(AX)
	MOVOU X4, 64(AX)
	MOVOU X5, 80(AX)
	MOVOU X6, 96(AX)
	MOVOU X7, 112(AX)
	RET

// func permuteAndUpdateSSE(sptr uintptr)
TEXT ·permuteAndUpdateSSE(SB),4,$0-8
	MOVQ sptr+0(FP), AX
	MOVOU 0(AX), X0
	MOVOU 16(AX), X1
	MOVOU 32(AX), X2
	MOVOU 48(AX), X3
	MOVOU 64(AX), X4
	MOVOU 80(AX), X5
	MOVOU 96(AX), X6
	MOVOU 112(AX), X7
	PSHUFL $177, X1, X8
	PSHUFL $177, X0, X9
	PADDQ X8, X2
	PADDQ X9, X3
	PADDQ X4, X2
	PADDQ X5, X3
	MOVO X0, X10
	MOVO X1, X11
	MOVO X2, X8
	MOVO X3, X9
	PSRLQ $32, X8
	PSRLQ $32, X9
	PMULULQ X10, X8
	PMULULQ X11, X9
	PXOR X8, X4
	PXOR X9, X5
	PADDQ X6, X0
	PADDQ X7, X1
	MOVO X2, X10
	MOVO X3, X11
	MOVO X0, X8
	MOVO X1, X9
	PSRLQ $32, X8
	PSRLQ $32, X9
	PMULULQ X10, X8
	PMULULQ X11, X9
	PXOR X8, X6
	PXOR X9, X7
	MOVQ $4223284375849987, BX
	MOVQ BX, X10
	MOVQ $506661594022413323, BX
	MOVQ BX, X8
	MOVLHPS X8, X10
	MOVO X2, X8
	PSHUFB X10, X8
	MOVO X3, X9
	PSHUFB X10, X9
	PADDQ X8, X0
	PADDQ X9, X1
	MOVO X0, X8
	PSHUFB X10, X8
	MOVO X1, X9
	PSHUFB X10, X9
	PADDQ X8, X2
	PADDQ X9, X3
	MOVOU X0, 0(AX)
	MOVOU X1, 16(AX)
	MOVOU X2, 32(AX)
	MOVOU X3, 48(AX)
	MOVOU X4, 64(AX)
	MOVOU X5, 80(AX)
	MOVOU X6, 96(AX)
	MOVOU X7, 112(AX)
	RET

// func finalizeSSE(sptr uintptr) uint64
TEXT ·finalizeSSE(SB),4,$0-16
	MOVQ sptr+0(FP), AX
	MOVOU 0(AX), X0
	MOVOU 16(AX), X1
	MOVOU 32(AX), X2
	MOVOU 48(AX), X3
	MOVOU 64(AX), X4
	MOVOU 80(AX), X5
	MOVOU 96(AX), X6
	MOVOU 112(AX), X7
	MOVQ $4, AX
loop_begin:
		PSHUFL $177, X1, X8
		PSHUFL $177, X0, X9
		PADDQ X8, X2
		PADDQ X9, X3
		PADDQ X4, X2
		PADDQ X5, X3
		MOVO X0, X10
		MOVO X1, X11
		MOVO X2, X8
		MOVO X3, X9
		PSRLQ $32, X8
		PSRLQ $32, X9
		PMULULQ X10, X8
		PMULULQ X11, X9
		PXOR X8, X4
		PXOR X9, X5
		PADDQ X6, X0
		PADDQ X7, X1
		MOVO X2, X10
		MOVO X3, X11
		MOVO X0, X8
		MOVO X1, X9
		PSRLQ $32, X8
		PSRLQ $32, X9
		PMULULQ X10, X8
		PMULULQ X11, X9
		PXOR X8, X6
		PXOR X9, X7
		MOVQ $4223284375849987, BX
		MOVQ BX, X10
		MOVQ $506661594022413323, BX
		MOVQ BX, X8
		MOVLHPS X8, X10
		MOVO X2, X8
		PSHUFB X10, X8
		MOVO X3, X9
		PSHUFB X10, X9
		PADDQ X8, X0
		PADDQ X9, X1
		MOVO X0, X8
		PSHUFB X10, X8
		MOVO X1, X9
		PSHUFB X10, X9
		PADDQ X8, X2
		PADDQ X9, X3
		DECQ AX
		JNE loop_begin
	PADDQ X2, X0
	PADDQ X6, X4
	PADDQ X4, X0
	MOVQ X0, AX
	MOVQ AX, ret+8(FP)
	RET

// func newstateSSE(sptr uintptr, keys uintptr, init0 uintptr, init1 uintptr)
TEXT ·newstateSSE(SB),4,$0-32
	MOVQ sptr+0(FP), AX
	MOVQ keys+8(FP), BX
	MOVOU X0, 0(AX)
	MOVOU X1, 16(AX)
	MOVOU X2, 32(AX)
	MOVOU X3, 48(AX)
	MOVOU X4, 64(AX)
	MOVOU X5, 80(AX)
	MOVOU X6, 96(AX)
	MOVOU X7, 112(AX)
	RET
