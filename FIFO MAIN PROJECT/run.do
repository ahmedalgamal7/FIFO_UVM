vlib work
vlog -f src_files.txt +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/fifo_interface/*
add wave -position insertpoint  \
sim:/top/dut/wr_ptr \
sim:/top/dut/rd_ptr \
sim:/top/dut/mem \
sim:/top/dut/count
coverage save top.ucdb -onexit
run -all
#quit -sim
#vcover report top.ucdb -details -all -annotate -output cover_rpt.txt