// RUN: dataflow-scheduler-dialects-opt --split-input-file --verify-diagnostics %s

// Negative: the value is not of the element type.

func.func @init_register_value_type_mismatch() {
  // expected-error@+1 {{failed to verify that type of 'value' matches element type of 'result'}}
  %reg = ktdf.init_register 0.0 : f32 on "SFU" -> memref<64xf16, "SFU_REG">
  return
}

// -----

// Negative: a dynamic shape.

func.func @init_register_dynamic_shape() {
  // expected-error@+1 {{must be statically shaped memref of any type values}}
  %reg = ktdf.init_register 0.0 : f16 on "SFU" -> memref<?xf16, "SFU_REG">
  return
}
