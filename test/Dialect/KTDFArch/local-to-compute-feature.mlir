// RUN: dataflow-scheduler-dialects-opt --split-input-file --verify-diagnostics %s

// Test 1: local_to_compute is accepted on a memory node.
ktdf_arch.device @local_to_compute_on_memory {
  memory { kind = "SFU_LRF", ktdf_arch.features = { ktdf_arch.feature.local_to_compute } }
}

// -----

// Test 2: local_to_compute is accepted on an exec_unit.
ktdf_arch.device @local_to_compute_on_exec_unit {
  exec_unit { ktdf_arch.features = { ktdf_arch.feature.local_to_compute } }
}

// -----

// Test 3: local_to_compute is rejected on a datapath (link).
ktdf_arch.device @local_to_compute_on_datapath {
  %a = exec_unit
  %b = exec_unit

  // expected-error@+1 {{'ktdf_arch.feature.local_to_compute' is only valid on memory or execution unit resources}}
  datapath { ktdf_arch.features = { ktdf_arch.feature.local_to_compute } } %a to %b : exec_unit, exec_unit
}
