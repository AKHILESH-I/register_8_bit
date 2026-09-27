cd ../tb

vdel -all
vlib work
vmap work work

vlog -sv uvm_register_8_bit.sv
vlog -sv uvm_register_if.sv
vlog -sv uvm_register_pkg.sv
vlog -sv uvm_register_assertions.sv
vlog -sv uvm_register_8_bit_tb.sv

cd ../sim
