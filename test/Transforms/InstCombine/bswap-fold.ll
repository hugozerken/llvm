; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; rdar://5992453
; A & 255
define i32 @test4(i32 %a) nounwind  {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 %a, 255
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp2 = tail call i32 @llvm.bswap.i32( i32 %a )
  %tmp4 = lshr i32 %tmp2, 24
  ret i32 %tmp4
}

; A
define i32 @test5(i32 %a) nounwind {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i32 %a
;
  %tmp2 = tail call i32 @llvm.bswap.i32( i32 %a )
  %tmp4 = tail call i32 @llvm.bswap.i32( i32 %tmp2 )
  ret i32 %tmp4
}

; a >> 24
define i32 @test6(i32 %a) nounwind {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 %a, 24
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp2 = tail call i32 @llvm.bswap.i32( i32 %a )
  %tmp4 = and i32 %tmp2, 255
  ret i32 %tmp4
}

; PR5284
define i16 @test7(i32 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 %A, 16
; CHECK-NEXT:    [[D:%.*]] = trunc i32 [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[D]]
;
  %B = tail call i32 @llvm.bswap.i32(i32 %A) nounwind
  %C = trunc i32 %B to i16
  %D = tail call i16 @llvm.bswap.i16(i16 %C) nounwind
  ret i16 %D
}

define i16 @test8(i64 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 %A, 48
; CHECK-NEXT:    [[D:%.*]] = trunc i64 [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[D]]
;
  %B = tail call i64 @llvm.bswap.i64(i64 %A) nounwind
  %C = trunc i64 %B to i16
  %D = tail call i16 @llvm.bswap.i16(i16 %C) nounwind
  ret i16 %D
}

; Misc: Fold bswap(undef) to undef.
define i64 @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    ret i64 undef
;
  %a = call i64 @llvm.bswap.i64(i64 undef)
  ret i64 %a
}

; PR15782
; Fold: OP( BSWAP(x), BSWAP(y) ) -> BSWAP( OP(x, y) )
; Fold: OP( BSWAP(x), CONSTANT ) -> BSWAP( OP(x, BSWAP(CONSTANT) ) )
define i16 @bs_and16i(i16 %a, i16 %b) #0 {
; CHECK-LABEL: @bs_and16i(
; CHECK-NEXT:    [[TMP1:%.*]] = and i16 %a, 4391
; CHECK-NEXT:    [[TMP2:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %1 = tail call i16 @llvm.bswap.i16(i16 %a)
  %2 = and i16 %1, 10001
  ret i16 %2
}

define i16 @bs_and16(i16 %a, i16 %b) #0 {
; CHECK-LABEL: @bs_and16(
; CHECK-NEXT:    [[TMP1:%.*]] = and i16 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %tmp1 = tail call i16 @llvm.bswap.i16(i16 %a)
  %tmp2 = tail call i16 @llvm.bswap.i16(i16 %b)
  %tmp3 = and i16 %tmp1, %tmp2
  ret i16 %tmp3
}

define i16 @bs_or16(i16 %a, i16 %b) #0 {
; CHECK-LABEL: @bs_or16(
; CHECK-NEXT:    [[TMP1:%.*]] = or i16 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %tmp1 = tail call i16 @llvm.bswap.i16(i16 %a)
  %tmp2 = tail call i16 @llvm.bswap.i16(i16 %b)
  %tmp3 = or i16 %tmp1, %tmp2
  ret i16 %tmp3
}

define i16 @bs_xor16(i16 %a, i16 %b) #0 {
; CHECK-LABEL: @bs_xor16(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i16 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %tmp1 = tail call i16 @llvm.bswap.i16(i16 %a)
  %tmp2 = tail call i16 @llvm.bswap.i16(i16 %b)
  %tmp3 = xor i16 %tmp1, %tmp2
  ret i16 %tmp3
}

define i32 @bs_and32i(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @bs_and32i(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, -1585053440
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp1 = tail call i32 @llvm.bswap.i32(i32 %a)
  %tmp2 = and i32 %tmp1, 100001
  ret i32 %tmp2
}

define i32 @bs_and32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @bs_and32(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp1 = tail call i32 @llvm.bswap.i32(i32 %a)
  %tmp2 = tail call i32 @llvm.bswap.i32(i32 %b)
  %tmp3 = and i32 %tmp1, %tmp2
  ret i32 %tmp3
}

define i32 @bs_or32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @bs_or32(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp1 = tail call i32 @llvm.bswap.i32(i32 %a)
  %tmp2 = tail call i32 @llvm.bswap.i32(i32 %b)
  %tmp3 = or i32 %tmp1, %tmp2
  ret i32 %tmp3
}

define i32 @bs_xor32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @bs_xor32(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %tmp1 = tail call i32 @llvm.bswap.i32(i32 %a)
  %tmp2 = tail call i32 @llvm.bswap.i32(i32 %b)
  %tmp3 = xor i32 %tmp1, %tmp2
  ret i32 %tmp3
}

define i64 @bs_and64i(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64i(
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 %a, 129085117527228416
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %tmp1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %tmp2 = and i64 %tmp1, 1000000001
  ret i64 %tmp2
}

define i64 @bs_and64(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64(
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %tmp1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %tmp2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %tmp3 = and i64 %tmp1, %tmp2
  ret i64 %tmp3
}

define i64 @bs_or64(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_or64(
; CHECK-NEXT:    [[TMP1:%.*]] = or i64 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %tmp1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %tmp2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %tmp3 = or i64 %tmp1, %tmp2
  ret i64 %tmp3
}

define i64 @bs_xor64(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_xor64(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 %a, %b
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %tmp1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %tmp2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %tmp3 = xor i64 %tmp1, %tmp2
  ret i64 %tmp3
}

define <2 x i32> @bs_and32vec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_and32vec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %tmp1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %tmp2 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %b)
  %tmp3 = and <2 x i32> %tmp1, %tmp2
  ret <2 x i32> %tmp3
}

define <2 x i32> @bs_or32vec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_or32vec(
; CHECK-NEXT:    [[TMP1:%.*]] = or <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %tmp1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %tmp2 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %b)
  %tmp3 = or <2 x i32> %tmp1, %tmp2
  ret <2 x i32> %tmp3
}

define <2 x i32> @bs_xor32vec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_xor32vec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %tmp1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %tmp2 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %b)
  %tmp3 = xor <2 x i32> %tmp1, %tmp2
  ret <2 x i32> %tmp3
}

define <2 x i32> @bs_and32ivec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_and32ivec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[A:%.*]], <i32 -1585053440, i32 -1585053440>
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %tmp1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %tmp2 = and <2 x i32> %tmp1, <i32 100001, i32 100001>
  ret <2 x i32> %tmp2
}

define <2 x i32> @bs_or32ivec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_or32ivec(
; CHECK-NEXT:    [[TMP1:%.*]] = or <2 x i32> [[A:%.*]], <i32 -1585053440, i32 -1585053440>
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %tmp1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %tmp2 = or <2 x i32> %tmp1, <i32 100001, i32 100001>
  ret <2 x i32> %tmp2
}

define <2 x i32> @bs_xor32ivec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_xor32ivec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i32> [[A:%.*]], <i32 -1585053440, i32 -1585053440>
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %tmp1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %tmp2 = xor <2 x i32> %tmp1, <i32 100001, i32 100001>
  ret <2 x i32> %tmp2
}

define i64 @bs_and64_multiuse1(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64_multiuse1(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[A:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[B:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[A]], [[B]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = mul i64 [[TMP4]], [[TMP2]]
; CHECK-NEXT:    ret i64 [[TMP5]]
;
  %tmp1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %tmp2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %tmp3 = and i64 %tmp1, %tmp2
  %tmp4 = mul i64 %tmp3, %tmp1 ; to increase use count of the bswaps
  %tmp5 = mul i64 %tmp4, %tmp2 ; to increase use count of the bswaps
  ret i64 %tmp5
}

define i64 @bs_and64_multiuse2(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64_multiuse2(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[A:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[A]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    ret i64 [[TMP4]]
;
  %tmp1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %tmp2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %tmp3 = and i64 %tmp1, %tmp2
  %tmp4 = mul i64 %tmp3, %tmp1 ; to increase use count of the bswaps
  ret i64 %tmp4
}

define i64 @bs_and64_multiuse3(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64_multiuse3(
; CHECK-NEXT:    [[TMP2:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[B:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[A:%.*]], [[B]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP2]]
; CHECK-NEXT:    ret i64 [[TMP4]]
;
  %tmp1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %tmp2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %tmp3 = and i64 %tmp1, %tmp2
  %tmp4 = mul i64 %tmp3, %tmp2 ; to increase use count of the bswaps
  ret i64 %tmp4
}

define i64 @bs_and64i_multiuse(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64i_multiuse(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[A:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[A]], 129085117527228416
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %tmp1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %tmp2 = and i64 %tmp1, 1000000001
  %tmp3 = mul i64 %tmp2, %tmp1 ; to increase use count of the bswap
  ret i64 %tmp3
}

declare i16 @llvm.bswap.i16(i16)
declare i32 @llvm.bswap.i32(i32)
declare i64 @llvm.bswap.i64(i64)
declare <2 x i32> @llvm.bswap.v2i32(<2 x i32>)
