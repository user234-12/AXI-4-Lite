`include "top_define.svh"
interface read_interface_class(input bit clk, bit reset_n);
    
    logic                      read_en;
    logic [`WIDTH_ADDR - 1 : 0]read_addr_in;
    logic [`WIDTH_DATA - 1 : 0]read_data_out;
    logic [1:0]                write_response_out;
    logic [1:0]                read_response_out;
    logic                      read_done;

    clocking drive_cb @(posedge clk);
        output read_en;
        output read_addr_in;
        input  read_data_out;
        input  write_response_out;
        input  read_response_out;
        input  read_done;
    endclocking: drive_cb

    clocking monitor_cb @(posedge clk);
        input read_en;
        input read_addr_in; 
        input read_data_out;
        input read_response_out;
        input write_response_out;
        input read_done;
    endclocking: monitor_cb

    modport drive_mod(clocking drive_cb, input reset_n);
    modport monitor_mod(clocking monitor_cb, input reset_n);

endinterface: read_interface_class
