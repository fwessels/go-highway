// Generated by PeachPy 0.2.0 from sum.py


// func hashSSE(keys uintptr, init0 uintptr, init1 uintptr, p_base uintptr, p_len int64, p_cap int64) uint64
TEXT ·hashSSE(SB),4,$0-56
	MOVQ keys+0(FP), AX
	MOVQ init0+8(FP), BX
	MOVQ init1+16(FP), CX
	MOVOU 0(AX), X0
	MOVOU 16(AX), X1
	MOVOU 0(BX), X4
	MOVOU 16(BX), X5
	MOVOU 0(CX), X6
	MOVOU 16(CX), X7
	PSHUFL $177, X1, X2
	PSHUFL $177, X0, X3
	PXOR X4, X0
	PXOR X5, X1
	PXOR X6, X2
	PXOR X7, X3
	MOVQ p_base+24(FP), AX
	MOVQ p_len+32(FP), BX
	CMPQ BX, $32
	JLT loop0_end
loop0_begin:
		MOVOU 0(AX), X8
		MOVOU 16(AX), X9
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
		MOVQ $4223284375849987, CX
		MOVQ CX, X10
		MOVQ $506661594022413323, CX
		MOVQ CX, X8
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
		ADDQ $32, AX
		SUBQ $32, BX
		CMPQ BX, $32
		JGE loop0_begin
loop0_end:
	MOVQ BX, CX
	ANDQ $3, CX
	MOVQ p_len+32(FP), DX
	SHLQ $24, DX
	MOVL DX, DX
	MOVQ AX, DI
	ADDQ BX, DI
	SUBQ CX, DI
	CMPQ CX, $0
	JEQ done
	MOVBLZX 0(DI), SI
	SHLL $0, SI
	ADDL SI, DX
	DECQ CX
	CMPQ CX, $0
	JEQ done
	MOVBLZX 1(DI), SI
	SHLL $8, SI
	ADDL SI, DX
	DECQ CX
	CMPQ CX, $0
	JEQ done
	MOVBLZX 2(DI), SI
	SHLL $16, SI
	ADDL SI, DX
	DECQ CX
	CMPQ CX, $0
	JEQ done
	MOVBLZX 3(DI), SI
	SHLL $24, SI
	ADDL SI, DX
	DECQ CX
done:
	PXOR X8, X8
	PXOR X9, X9
	MOVQ BX, CX
	ANDQ $3, CX
	NEGQ CX
	ADDQ BX, CX
	CMPQ CX, $0
	JEQ memcpy32_fin
	CMPQ CX, $16
	JLT memcpy32_skipLoad16
	MOVOU 0(AX), X8
	ADDQ $16, AX
	SUBQ $16, CX
	XORQ DI, DI
	CMPQ CX, $8
	JLT skip80
	MOVQ 0(AX), BX
	MOVQ BX, X9
	SUBQ $8, CX
	ADDQ $8, AX
	MOVQ $1, DI
skip80:
	XORQ BX, BX
	CMPQ CX, $0
	JEQ __local2
	CMPQ CX, $1
	JEQ __local1
	CMPQ CX, $2
	JEQ __local6
	CMPQ CX, $3
	JEQ __local4
	CMPQ CX, $4
	JEQ __local13
	CMPQ CX, $5
	JEQ __local0
	CMPQ CX, $6
	JEQ __local12
	MOVBQZX 6(AX), CX
	SHLQ $48, CX
	ORQ CX, BX
__local12:
	MOVBQZX 5(AX), CX
	SHLQ $40, CX
	ORQ CX, BX
__local0:
	MOVBQZX 4(AX), CX
	SHLQ $32, CX
	ORQ CX, BX
__local13:
	MOVBQZX 3(AX), CX
	SHLQ $24, CX
	ORQ CX, BX
__local4:
	MOVBQZX 2(AX), CX
	SHLQ $16, CX
	ORQ CX, BX
__local6:
	MOVBQZX 1(AX), CX
	SHLQ $8, CX
	ORQ CX, BX
__local1:
	MOVBQZX 0(AX), CX
	SHLQ $0, CX
	ORQ CX, BX
	CMPQ DI, $1
	JEQ insert10
	PINSRQ $0, BX, X9
	JMP fin160
insert10:
	PINSRQ $1, BX, X9
fin160:
__local2:
	JMP memcpy32_fin
memcpy32_skipLoad16:
	XORQ DI, DI
	CMPQ CX, $8
	JLT skip81
	MOVQ 0(AX), BX
	MOVQ BX, X8
	SUBQ $8, CX
	ADDQ $8, AX
	MOVQ $1, DI
skip81:
	XORQ BX, BX
	CMPQ CX, $0
	JEQ __local14
	CMPQ CX, $1
	JEQ __local11
	CMPQ CX, $2
	JEQ __local5
	CMPQ CX, $3
	JEQ __local7
	CMPQ CX, $4
	JEQ __local10
	CMPQ CX, $5
	JEQ __local8
	CMPQ CX, $6
	JEQ __local3
	MOVBQZX 6(AX), CX
	SHLQ $48, CX
	ORQ CX, BX
__local3:
	MOVBQZX 5(AX), CX
	SHLQ $40, CX
	ORQ CX, BX
__local8:
	MOVBQZX 4(AX), CX
	SHLQ $32, CX
	ORQ CX, BX
__local10:
	MOVBQZX 3(AX), CX
	SHLQ $24, CX
	ORQ CX, BX
__local7:
	MOVBQZX 2(AX), CX
	SHLQ $16, CX
	ORQ CX, BX
__local5:
	MOVBQZX 1(AX), CX
	SHLQ $8, CX
	ORQ CX, BX
__local11:
	MOVBQZX 0(AX), CX
	SHLQ $0, CX
	ORQ CX, BX
	CMPQ DI, $1
	JEQ insert11
	PINSRQ $0, BX, X8
	JMP fin161
insert11:
	PINSRQ $1, BX, X8
fin161:
__local14:
memcpy32_fin:
	PINSRD $3, DX, X9
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
	MOVQ $4223284375849987, AX
	MOVQ AX, X10
	MOVQ $506661594022413323, AX
	MOVQ AX, X8
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
	MOVQ $4, AX
loop1_begin:
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
		JNE loop1_begin
	PADDQ X2, X0
	PADDQ X6, X4
	PADDQ X4, X0
	MOVQ X0, AX
	MOVQ AX, ret+48(FP)
	RET
