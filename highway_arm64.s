//+build !noasm !appengine

//
// Minio Cloud Storage, (C) 2017 Minio, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

/* S S E   v e r s i o n */
// def update(plo, phi, state):
// v1 += packet;
// PADDQ(state.v1lo, plo)
// PADDQ(state.v1hi, phi)
// v1 += mul0;
// PADDQ(state.v1lo, state.mul0lo)
// PADDQ(state.v1hi, state.mul0hi)
//
// dstlo = XMMRegister()
// dsthi = XMMRegister()
// srclo = XMMRegister()
// srchi = XMMRegister()
//
// setup src=(v0) and dst=(v1)
// MOVDQA(srclo, state.v0lo)
// MOVDQA(srchi, state.v0hi)
// MOVDQA(dstlo, state.v1lo)
// MOVDQA(dsthi, state.v1hi)
// PSRLQ(dstlo, 32)
// PSRLQ(dsthi, 32)
//
// V4x64U(mm256_mul_epu32(v1 , v0 >> 32));
// PMULUDQ(dstlo, srclo)
// PMULUDQ(dsthi, srchi)
// mul0 ˆ=
// PXOR(state.mul0lo, dstlo)
// PXOR(state.mul0hi, dsthi)
//
// ###
//
// v0 += mul1
// PADDQ(state.v0lo, state.mul1lo)
// PADDQ(state.v0hi, state.mul1hi)
//
// ###
//
// setup src=(v1) and dst=(v0)
// MOVDQA(srclo, state.v1lo)
// MOVDQA(srchi, state.v1hi)
// MOVDQA(dstlo, state.v0lo)
// MOVDQA(dsthi, state.v0hi)
// PSRLQ(dstlo, 32)
// PSRLQ(dsthi, 32)
//
// V4x64U(mm256_mul_epu32(v0 , v1 >> 32));
// PMULUDQ(dstlo, srclo)
// PMULUDQ(dsthi, srchi)
// mul1 ˆ=
// PXOR(state.mul1lo, dstlo)
// PXOR(state.mul1hi, dsthi)
//
// ######
//
// mask = zippermask()
// zipper(mask, state.v1lo, state.v1hi, dstlo, dsthi)
// PADDQ(state.v0lo, dstlo)
// PADDQ(state.v0hi, dsthi)
//
// zipper(mask, state.v0lo, state.v0hi, dstlo, dsthi)
// PADDQ(state.v1lo, dstlo)
// PADDQ(state.v1hi, dsthi)


/* P S U E D O   C O D E */
// v0, v1, mul0 mul1: 256 bit
// 32 byte vector of inputs (packet) into the 1024-bit internal state by multiplying and permuting

// v1 += packet;
// v1 += mul0;
// mul0 ˆ= V4x64U(mm256_mul_epu32(v1 , v0 >> 32));
// v0 += mul1;
// mul1 ˆ= V4x64U(mm256_mul_epu32(v0 , v1 >> 32));
// v0 += ZipperMerge (v1);
// v1 += ZipperMerge (v0);


//
// ARM64 version of HighwayHash
//
// Use github.com/minio/asm2plan9s on this file to assemble ARM instructions to
// their Plan9 equivalents
//

TEXT ·update(SB), 7, $0
	MOVD h+0(FP), R0
	MOVD message+24(FP), R1
	MOVD lenmessage+32(FP), R2 // length of message
	SUBS $32, R2
	BMI  complete

    // v0 = v0.lo
    // v1 = v0.hi
    // v2 = v1.lo
    // v3 = v1.hi
    // v4 = mul0.lo
    // v5 = mul0.hi
    // v6 = mul1.lo
    // v7 = mul1.hi
	                 // ld1	{v0.4s-v7.4s}, [x0] // Load state

loop:
	// Main loop
	                 // ld1	{v16.4s-v17.4s}, [x1], #32 // Load message
                     // add	v0.4s, v0.4s, v16.4s
                     // add	v1.4s, v1.4s, v17.4s
                     // add	v0.4s, v0.4s, v4.4s
                     // add	v1.4s, v1.4s, v5.4s

	SUBS $32, R2
	BPL  loop

	// Store result
	                 // st1	{v0.4s, v7.4s}, [x0] // Save state

complete:
	RET

	// Load constants table pointer
	// MOVD $·constants(SB), R3

	// Cache constants table in registers v16 - v31
	                 // ld1	{v16.4s-v19.4s}, [x3], #64 // 4 regs of 16 bytes = 128 bits
	                 // ld1	{v0.4s}, [x0], #16
	                 // ld1	{v20.4s-v23.4s}, [x3], #64

	                 // ld1	{v1.4s}, [x0]
	                 // ld1	{v24.4s-v27.4s}, [x3], #64
	                 // sub	x0, x0, #0x10
	                 // ld1	{v28.4s-v31.4s}, [x3], #64

	                 // ld1	{v5.16b-v8.16b}, [x1], #64
	                 // mov	v2.16b, v0.16b
	                 // mov	v3.16b, v1.16b
	                 // rev32	v5.16b, v5.16b
	                 // rev32	v6.16b, v6.16b
	                 // add	v9.4s, v5.4s, v16.4s
	                 // rev32	v7.16b, v7.16b
	                 // add	v10.4s, v6.4s, v17.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v9.4s
	                 // sha256h2	q3, q4, v9.4s
	                 // sha256su0	v5.4s, v6.4s
	                 // rev32	v8.16b, v8.16b
	                 // add	v9.4s, v7.4s, v18.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v10.4s
	                 // sha256h2	q3, q4, v10.4s
	                 // sha256su0	v6.4s, v7.4s
	                 // sha256su1	v5.4s, v7.4s, v8.4s
	                 // add	v10.4s, v8.4s, v19.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v9.4s
	                 // sha256h2	q3, q4, v9.4s
	                 // sha256su0	v7.4s, v8.4s
	                 // sha256su1	v6.4s, v8.4s, v5.4s
	                 // add	v9.4s, v5.4s, v20.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v10.4s
	                 // sha256h2	q3, q4, v10.4s
	                 // sha256su0	v8.4s, v5.4s
	                 // sha256su1	v7.4s, v5.4s, v6.4s
	                 // add	v10.4s, v6.4s, v21.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v9.4s
	                 // sha256h2	q3, q4, v9.4s
	                 // sha256su0	v5.4s, v6.4s
	                 // sha256su1	v8.4s, v6.4s, v7.4s
	                 // add	v9.4s, v7.4s, v22.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v10.4s
	                 // sha256h2	q3, q4, v10.4s
	                 // sha256su0	v6.4s, v7.4s
	                 // sha256su1	v5.4s, v7.4s, v8.4s
	                 // add	v10.4s, v8.4s, v23.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v9.4s
	                 // sha256h2	q3, q4, v9.4s
	                 // sha256su0	v7.4s, v8.4s
	                 // sha256su1	v6.4s, v8.4s, v5.4s
	                 // add	v9.4s, v5.4s, v24.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v10.4s
	                 // sha256h2	q3, q4, v10.4s
	                 // sha256su0	v8.4s, v5.4s
	                 // sha256su1	v7.4s, v5.4s, v6.4s
	                 // add	v10.4s, v6.4s, v25.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v9.4s
	                 // sha256h2	q3, q4, v9.4s
	                 // sha256su0	v5.4s, v6.4s
	                 // sha256su1	v8.4s, v6.4s, v7.4s
	                 // add	v9.4s, v7.4s, v26.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v10.4s
	                 // sha256h2	q3, q4, v10.4s
	                 // sha256su0	v6.4s, v7.4s
	                 // sha256su1	v5.4s, v7.4s, v8.4s
	                 // add	v10.4s, v8.4s, v27.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v9.4s
	                 // sha256h2	q3, q4, v9.4s
	                 // sha256su0	v7.4s, v8.4s
	                 // sha256su1	v6.4s, v8.4s, v5.4s
	                 // add	v9.4s, v5.4s, v28.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v10.4s
	                 // sha256h2	q3, q4, v10.4s
	                 // sha256su0	v8.4s, v5.4s
	                 // sha256su1	v7.4s, v5.4s, v6.4s
	                 // add	v10.4s, v6.4s, v29.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v9.4s
	                 // sha256h2	q3, q4, v9.4s
	                 // sha256su1	v8.4s, v6.4s, v7.4s
	                 // add	v9.4s, v7.4s, v30.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v10.4s
	                 // sha256h2	q3, q4, v10.4s
	                 // add	v10.4s, v8.4s, v31.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v9.4s
	                 // sha256h2	q3, q4, v9.4s
	                 // mov	v4.16b, v2.16b
	                 // sha256h	q2, q3, v10.4s
	                 // sha256h2	q3, q4, v10.4s
	                 // add	v1.4s, v1.4s, v3.4s
	                 // add	v0.4s, v0.4s, v2.4s

	SUBS $64, R2
	BPL  loop

	// Store result
	                 // st1	{v0.4s, v1.4s}, [x0]

