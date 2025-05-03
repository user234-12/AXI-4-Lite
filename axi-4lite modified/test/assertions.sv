//`include "write_interface_class.sv"
//`include "read_interface_class.sv"

module assertions(input logic       clock,
                  input logic       reset_n,                  
                  input logic       write_en,
                  input logic       read_en,
                  input logic [31:0]write_data_in,
                  input logic [31:0]write_addr_in,
                  input logic [31:0]read_addr_in,
                  input logic [3:0] strobe_in,
                  input logic [31:0]read_data_out,
                  input logic [1:0] write_response_out,
                  input logic [1:0] read_response_out,
                  input logic       write_done,
                  input logic       read_done,
                  input logic       AWVALID,
                  input logic       AWREADY,
                  input logic       ARVALID,
                  input logic       ARREADY,
                  input logic       RVALID,
                  input logic       RREADY,
                  input logic       WVALID,
                  input logic       WREADY,
                  input logic       BVALID,
                  input logic       BREADY,
                  input logic       AWADDR,
                  input logic       ARADDR,
                  input logic       WDATA,
                  input logic [1:0] BRESP,
                  input logic [1:0] RRESP,
                  input logic [3:0] WSTRB,
                  input logic [31:0]RDATA);

/*    axi4_lite_top dut(.write_en          (write_en),
                      .read_en           (read_en),
                      .write_done        (write_done),
                      .write_addr_in     (write_addr_in),
                      .read_addr_in      (read_addr_in),
                      .write_response_out(write_response_out),
                      .read_response_out (read_response_out),
                      .strobe_in         (strobe_in),
                      .AWVALID           (AWVALID),
                      .WVALID            (WVALID),
                      .RVALID            (RVALID),
                      .BVALID            (BVALID),
                      .AWREADY           (AWREADY),
                      .WREADY            (WREADY),
                      .RREADY            (RREADY),
                      .BREADY            (BREADY),
                      .RRESP             (RRESP),
                      .BRESP             (BRESP));*/
    
    //write address channel handshake
    property write_addr_handshake;
        @(posedge clock) disable iff(!reset_n)
            AWVALID && AWREADY |=> ##1 !AWVALID;
    endproperty
        assert property(write_addr_handshake)
            else
                $error("AWVALID not deasserted after handshake at %t", $time);
    
    //write address stability
    property write_addr_stable;
        @(posedge clock) disable iff(!reset_n)
            AWVALID && !AWREADY |=> $stable(AWADDR); 
    endproperty
        assert property(write_addr_stable)
           else
               $error("AWADDR changed while AWVALID high and AWREADY low at %t", $time);

    //write data channel handshake
    property write_data_handshake;
        @(posedge clock) disable iff(!reset_n)
            WVALID && WREADY |=> ##1 !WVALID;
    endproperty
        assert property(write_data_handshake)
            else
                $error("WVALID not deasserted after handshake at %t", $time);

    //write data stability
    property write_data_stable;
        @(posedge clock) disable iff(!reset_n)
            WVALID && !WREADY |=> $stable(WDATA) && $stable(WSTRB); 
    endproperty
        assert property(write_data_stable)
           else
               $error("WDATA or WSTRB changed while WVALID high and WREADY low at %t", $time);

    //write response channel handshake
    property write_resp_handshake;
        @(posedge clock) disable iff(!reset_n)
            BVALID && BREADY |=> ##1 !BVALID;
    endproperty
        assert property(write_resp_handshake)
            else
                $error("BVALID not deasserted after handshake at %t", $time);

    //write response valid values(No EXOKAY)
    property write_resp_valid;
        @(posedge clock) disable iff(!reset_n)
            BVALID |-> (BRESP == 2'b00 || BRESP == 2'b10 || BRESP == 2'b11);
    endproperty
        assert property(write_resp_valid)
            else
                $error("Invalid BRESP value %b detected at %t", BRESP, $time);

    //read address channel handshake
    property read_addr_handshake;
        @(posedge clock) disable iff(!reset_n)
            ARVALID && ARREADY |=> ##1 !ARVALID;
    endproperty
        assert property(read_addr_handshake)
            else
                $error("ARVALID not deasserted after handshake at %t", $time);

    //read address stability
    property read_addr_stable;
        @(posedge clock) disable iff(!reset_n)
            ARVALID && !ARREADY |=> $stable(ARADDR); 
    endproperty
        assert property(read_addr_stable)
           else
               $error("ARADDR changed while ARVALID high and ARREADY low at %t", $time);

    //read data channel handshake
    property read_data_handshake;
        @(posedge clock) disable iff(!reset_n)
            RVALID && RREADY |=> ##1 !RVALID;
    endproperty
        assert property(read_data_handshake)
            else
                $error("RVALID not deasserted after handshake at %t", $time);

    //read data stability
    property read_data_stable;
        @(posedge clock) disable iff(!reset_n)
            RVALID && !RREADY |=> $stable(RDATA) && $stable(RRESP); 
    endproperty
        assert property(read_data_stable)
           else
               $error("RDATA or RRESP changed while RVALID high and RREADY low at %t", $time);
    
    //read response valid values(No EXOKAY)
    property read_resp_valid;
        @(posedge clock) disable iff(!reset_n)
            RVALID |-> (RRESP == 2'b00 || RRESP == 2'b10 || RRESP == 2'b11);
    endproperty
        assert property(read_resp_valid)
            else
                $error("Invalid RRESP value %b detected at %t", RRESP, $time);

    //strobe validity
    property strobe_validity;
        @(posedge clock) disable iff(!reset_n)
            write_en |-> (strobe_in != 4'b000);
    endproperty
        assert property(strobe_validity)
            else
                $error("No data byte is valid");

    //read enable triggers ARVALID
    property read_en_trigger;
        $rose(read_en) |=> ARVALID;
    endproperty
        assert property(read_en_trigger)
            else
                $error("ARVALID not asserted after read_en");

    //write enable triggers AWVALID
    property write_en_trigger;
        $rose(write_en) |=> AWVALID;
    endproperty
        assert property(write_en_trigger)
            else
                $error("AWVALID not asserted after write_en");

    //read completion: read_done should assert after RVALID && RREADY
    property read_done_completion;
        (RVALID && RREADY) |=> read_done && (read_response_out == RRESP);
    endproperty
        assert property(read_done_completion)
            else
                $error("read_done or read_response_out incorrect after read completion");

    //write completion: write_done should assert after BVALID && BREADY
    property write_done_completion;
        (BVALID && BREADY) |=> write_done && (write_response_out == BRESP);
    endproperty
        assert property(write_done_completion)
            else
                $error("write_done or write_response_out incorrect after write completion");

    //reset behavior
    property reset_asserted;
        @(posedge clock)
        !reset_n |=> (!write_en && !read_en && !write_data_in && !write_addr_in && !read_addr_in && !strobe_in);
    endproperty
        assert property(reset_asserted)
            else
                $error("AXI signals not reset properly at %t", $time);

endmodule
