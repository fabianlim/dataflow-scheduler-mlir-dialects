// RUN: dataflow-scheduler-dialects-opt %s | dataflow-scheduler-dialects-opt | FileCheck %s

// CHECK-LABEL:   func.func @init_register_float() -> memref<64xf16, "SFU_REG"> {
// CHECK-NEXT:      %[[REG:.*]] = ktdf.init_register 0.000000e+00 : f16 on "SFU" -> memref<64xf16, "SFU_REG">
// CHECK-NEXT:      return %[[REG]] : memref<64xf16, "SFU_REG">
// CHECK-NEXT:    }

func.func @init_register_float() -> memref<64xf16, "SFU_REG"> {
  %reg = ktdf.init_register 0.0 : f16 on "SFU" -> memref<64xf16, "SFU_REG">
  return %reg : memref<64xf16, "SFU_REG">
}

// CHECK-LABEL:   func.func @init_register_integer() -> memref<32xi32, "SFU_REG"> {
// CHECK-NEXT:      %[[REG:.*]] = ktdf.init_register -1 : i32 on "SFU" -> memref<32xi32, "SFU_REG">
// CHECK-NEXT:      return %[[REG]] : memref<32xi32, "SFU_REG">
// CHECK-NEXT:    }

func.func @init_register_integer() -> memref<32xi32, "SFU_REG"> {
  %reg = ktdf.init_register -1 : i32 on "SFU" -> memref<32xi32, "SFU_REG">
  return %reg : memref<32xi32, "SFU_REG">
}
