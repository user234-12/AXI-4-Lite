`include "uvm_macros.svh"
import uvm_pkg :: *;

`include "top_define.svh"

`include "../test/container.sv"

`include "../interfaces/write_interface.sv"
`include "../interfaces/read_interface.sv"

`include "../config_db/write_agent_config.sv"
`include "../config_db/read_agent_config.sv"
`include "../config_db/environment_config.sv"

`include "../write/write_sequence_item.sv"
`include "../write/write_sequence.sv"
`include "../write/write_sequencer.sv"
`include "../write/write_driver.sv"
`include "../write/write_monitor.sv"

`include "../read/read_sequence_item.sv"
`include "../read/read_sequence.sv"
`include "../read/read_sequencer.sv"
`include "../read/read_driver.sv"
`include "../read/read_monitor.sv"

`include "../write/write_agent.sv"

`include "../read/read_agent.sv"

`include "../test/reference_model.sv"
`include "../test/scoreboard.sv"
//`include "../test/coverage.sv"
`include "../test/environment.sv"
`include "../test/write_test.sv"

`include "../DUT/axi4_lite_top.sv"

//`include "../test/assertions.sv" 
