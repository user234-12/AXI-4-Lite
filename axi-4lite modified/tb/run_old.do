vlib work
vlog +incdir+./interface +incdir+./config_db +incdir+./write +incdir+./read +incdir+./test +incdir+./tb top.sv +acc
vsim work.top -assertdebug +UVM_VERBOSITY=UVM_MEDIUM -l run.log
#run -all
