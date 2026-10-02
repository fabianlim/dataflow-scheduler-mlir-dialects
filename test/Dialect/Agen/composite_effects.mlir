// RUN: dataflow-scheduler-dialects-opt -canonicalize %s | FileCheck %s

// A composite op's body runs once per time step, so the op has the effects of
// its body as well as those of its own memory accesses. A composite load
// without results is not dead when its body sends the loaded vector.

// CHECK-LABEL:   func.func @load_and_send(
// CHECK:           agen.composite_load
// CHECK:             dataflow.send
// CHECK:             agen.yield
func.func @load_and_send(%mem: memref<64xf16>, %unit: index) {
  %c0 = arith.constant 0 : index
  agen.composite_load %mem[%c0]
    time_symbols()(%iv: vector<64xf16>)
    {load_order = affine_map<(d0) -> (d0)>,
     load_set = affine_set<(d0) : (d0 >= 0, -d0 + 63 >= 0)>,
     time_addr_map = affine_map<(d0) -> (0)>,
     time_order = affine_map<(d0) -> (d0)>,
     time_set = affine_set<(d0) : (d0 == 0)>}
  {
    dataflow.send %unit, %iv : vector<64xf16>
    agen.yield
  } : memref<64xf16>
  return
}

// A composite load whose body only yields has no effect but its read, and is
// still removed.

// CHECK-LABEL:   func.func @load_only(
// CHECK-NOT:       agen.composite_load
// CHECK:           return
func.func @load_only(%mem: memref<64xf16>) {
  %c0 = arith.constant 0 : index
  agen.composite_load %mem[%c0]
    time_symbols()(%iv: vector<64xf16>)
    {load_order = affine_map<(d0) -> (d0)>,
     load_set = affine_set<(d0) : (d0 >= 0, -d0 + 63 >= 0)>,
     time_addr_map = affine_map<(d0) -> (0)>,
     time_order = affine_map<(d0) -> (d0)>,
     time_set = affine_set<(d0) : (d0 == 0)>}
  {
    agen.yield
  } : memref<64xf16>
  return
}
