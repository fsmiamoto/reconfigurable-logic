onerror {quit -f}
vlib work
vlog -work work RootMeanSquare.vo
vlog -work work RootMeanSquare.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.RootMeanSquare_vlg_vec_tst
vcd file -direction RootMeanSquare.msim.vcd
vcd add -internal RootMeanSquare_vlg_vec_tst/*
vcd add -internal RootMeanSquare_vlg_vec_tst/i1/*
add wave /*
run -all
