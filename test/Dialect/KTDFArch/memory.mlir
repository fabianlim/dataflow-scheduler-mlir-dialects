// RUN: dataflow-scheduler-dialects-opt --split-input-file %s \
// RUN:   | dataflow-scheduler-dialects-opt --split-input-file | FileCheck %s

// CHECK: #[[REG:.*]] = {kind = "REG", size = 2048 : i64, unit_name = "reg_file"}
// CHECK-LABEL: ktdf_arch.device @unit_name
ktdf_arch.device @unit_name {
  group share() {
    // CHECK: memory #[[REG]]
    memory { kind = "REG", size = 2048, unit_name = "reg_file" }
    %unit = exec_unit
    yield %unit
  } -> exec_unit
}

// -----

// The memory stays private to the group that yields the execution unit as long
// as no nested group takes it further down.
// CHECK: #[[REG:.*]] = {kind = "REG", unit_name = "reg_file"}
// CHECK-LABEL: ktdf_arch.device @unit_name_beside_nested_group
ktdf_arch.device @unit_name_beside_nested_group {
  group share() {
    // CHECK: memory #[[REG]]
    memory { kind = "REG", unit_name = "reg_file" }
    %scratch = memory { kind = "SCRATCH" }
    group share(%scratch) {
      %helper = exec_unit
      datapath %scratch to %helper : memory, exec_unit
    }
    %unit = exec_unit
    yield %unit
  } -> exec_unit
}
