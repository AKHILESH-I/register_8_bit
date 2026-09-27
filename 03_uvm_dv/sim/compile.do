vdel -all
vlib work
vmap work work

vlog -sv ../rtl/uvm_register_8_bit.sv
vlog -sv ../tb/uvm_register_if.sv
vlog -sv ../tb/uvm_register_pkg.sv
vlog -sv ../tb/uvm_register_assertions.sv
vlog -sv ../tb/uvm_register_8_bit_tb.sv
