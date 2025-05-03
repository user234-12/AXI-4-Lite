`include "tb_files.svh"

module top();
    
    bit clk;
    bit reset_n;

    initial forever #(100)clk = ~clk;

    write_interface_class write_interface( .clk(clk), .reset_n(reset_n));
    read_interface_class  read_interface( .clk(clk), .reset_n(reset_n));

    axi4_lite_top #( .DATA_WIDTH           (`WIDTH_DATA),
                     .ADDR_WIDTH           (`WIDTH_ADDR),
                     .STROB_WIDTH          (`STROBE_WIDTH))
                   dut( .clk               (clk),
                        .reset_n           (reset_n),
                        .write_en          (write_interface .write_en),
                        .read_en           (read_interface  .read_en),
                        .write_data_in     (write_interface .write_data_in),
                        .write_addr_in     (write_interface .write_addr_in),
                        .read_addr_in      (read_interface  .read_addr_in),
                        .strobe_in         (write_interface .strobe_in),
                        .read_data_out     (read_interface  .read_data_out),
                        .write_response_out(read_interface  .write_response_out),
                        .read_response_out (read_interface  .read_response_out),
                        .write_done        (write_interface .write_done),
                        .read_done         (read_interface  .read_done));

    initial begin
        @(posedge clk)
        reset_n = 1'b1;

        @(posedge clk)
        reset_n = 1'b0;

        @(posedge clk)
        reset_n = 1'b1;
    end

    initial begin
        uvm_config_db #(virtual write_interface_class) :: set(uvm_root :: get(),
                                                              "*",
                                                              "write_interface_class",
                                                              write_interface);

        uvm_config_db #(virtual read_interface_class) :: set(uvm_root :: get(),
                                                             "*",
                                                             "read_interface_class",
                                                             read_interface);

        run_test();
    end 

    //binding assertions with axi4_lite_top.v
    //bind axi4_lite_top assertions dut_assert(clock, reset_n, intf);
    /*bind axi4_lite_top assertions dut_assert( .clk(clock),
                                              .reset_n(reset_n),                  
                                              .write_en(write_en),
                                              .read_en(read_en),
                                              .write_data_in(write_data_in),
                                              .write_addr_in(write_addr_in),
                                              .read_addr_in(read_addr_in),
                                              .strobe_in(strobe_in),
                                              .read_data_out(read_data_out),
                                              .write_response_out(write_response_out),
                                              .read_response_out(read_response_out),
                                              .write_done(write_done),
                                              .read_done(read_done),
                                              .AWVALID(dut_assert .AWVALID),
                                              .AWREADY(dut_assert .AWREADY),
                                              .ARVALID(dut_assert .ARVALID),
                                              .ARREADY(dut_assert .ARREADY),
                                              .RVALID(dut_assert  .RVALID),
                                              .RREADY(dut_assert  .RREADY),
                                              .WVALID(dut_assert  .WVALID),
                                              .WREADY(dut_assert  .WREADY),
                                              .BVALID(dut_assert  .BVALID),
                                              .BREADY(dut_assert  .BREADY),
                                              .AWADDR(dut_assert  .AWADDR),
                                              .ARADDR(dut_assert  .ARADDR),
                                              .WDATA(dut_assert   .WDATA),
                                              .BRESP(dut_assert   .BRESP),
                                              .RRESP(dut_assert   .RRESP),
                                              .WSTRB(dut_assert    .WSTRB),
                                              .RDATA(dut_assert   .RDATA));*/

endmodule: top
