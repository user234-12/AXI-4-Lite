`include "top_define.svh"
interface write_interface_class(input bit clk, bit reset_n);
    
    logic                        write_en;
    logic [`WIDTH_ADDR - 1 : 0]  write_addr_in;
    logic [`WIDTH_DATA - 1 : 0]  write_data_in;
    logic [3:0]                  strobe_in; 
    logic                        write_done;

    clocking drive_cb @(posedge clk);
        output write_en;
        output write_addr_in;
        output write_data_in;
        output strobe_in;
        input  write_done;
    endclocking: drive_cb

    clocking monitor_cb @(posedge clk);
        input write_en;
        input write_addr_in; 
        input write_data_in;
        input strobe_in;
        input write_done;
    endclocking: monitor_cb

    modport drive_mod(clocking drive_cb, input reset_n);
    modport monitor_mod(clocking monitor_cb, input reset_n);

endinterface: write_interface_class
