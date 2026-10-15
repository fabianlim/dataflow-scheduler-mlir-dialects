// RUN: dataflow-scheduler-dialects-opt -canonicalize %s | FileCheck %s

// Checks that canonicalization merges an init_register neither with an equal
// constant nor with an equal init_register.

// CHECK-LABEL:   func.func @init_register_not_merged(
// CHECK-NEXT:      %[[CST:.*]] = arith.constant 0.000000e+00 : f16
// CHECK-NEXT:      %[[A:.*]] = ktdf.init_register 0.000000e+00 : f16 on "SFU" -> memref<64xf16, "SFU_REG">
// CHECK-NEXT:      %[[B:.*]] = ktdf.init_register 0.000000e+00 : f16 on "SFU" -> memref<64xf16, "SFU_REG">
// CHECK-NEXT:      return %[[CST]], %[[A]], %[[B]]
// CHECK-NEXT:    }

func.func @init_register_not_merged() -> (f16, memref<64xf16, "SFU_REG">, memref<64xf16, "SFU_REG">) {
  %cst = arith.constant 0.0 : f16
  %a = ktdf.init_register 0.0 : f16 on "SFU" -> memref<64xf16, "SFU_REG">
  %b = ktdf.init_register 0.0 : f16 on "SFU" -> memref<64xf16, "SFU_REG">
  return %cst, %a, %b : f16, memref<64xf16, "SFU_REG">, memref<64xf16, "SFU_REG">
}
