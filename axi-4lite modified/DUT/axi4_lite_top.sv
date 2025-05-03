`include "axi4_lite_master.sv"
`include "axi4_lite_slave.sv"
module axi4_lite_top #(parameter ADDR_WIDTH = 32,
                       parameter DATA_WIDTH = 32,
                       parameter STROB_WIDTH = 4) (
    input  logic                     clk                ,
    input  logic                     reset_n            ,
    input  logic                     write_en           ,
    input  logic                     read_en            ,
    input  logic [DATA_WIDTH - 1:0]  write_data_in      ,
    input  logic [ADDR_WIDTH - 1:0]  write_addr_in      ,
    input  logic [ADDR_WIDTH - 1:0]  read_addr_in       ,
    input  logic [3:0]               strobe_in          ,
    output logic [DATA_WIDTH - 1:0]  read_data_out      ,
    output logic [1:0]               write_response_out ,
    output logic [1:0]               read_response_out  ,
    output logic                     write_done         ,
    output logic                     read_done
);

    logic        AWVALID;
    logic        AWREADY;
    logic [31:0] AWADDR;
    logic [2:0]  AWPROT;
    logic        WVALID;
    logic        WREADY;
    logic [31:0] WDATA;
    logic [3:0]  WSTRB;
    logic        BVALID;
    logic        BREADY;
    logic [1:0]  BRESP;
    logic        ARVALID;
    logic        ARREADY;
    logic [31:0] ARADDR;
    logic [2:0]  ARPROT;
    logic        RVALID;
    logic        RREADY;
    logic [31:0] RDATA;
    logic [1:0]  RRESP;

    axi4_lite_master master (
        .ACLK            (clk),
        .ARESETn         (reset_n),
        .AWVALID         (AWVALID),
        .AWREADY         (AWREADY),
        .AWADDR          (AWADDR),
        .AWPROT          (AWPROT),
        .WVALID          (WVALID),
        .WREADY          (WREADY),
        .WDATA           (WDATA),
        .WSTRB           (WSTRB),
        .BVALID          (BVALID),
        .BREADY          (BREADY),
        .BRESP           (BRESP),
        .ARVALID         (ARVALID),
        .ARREADY         (ARREADY),
        .ARADDR          (ARADDR),
        .ARPROT          (ARPROT),
        .RVALID          (RVALID),
        .RREADY          (RREADY),
        .RDATA           (RDATA),
        .RRESP           (RRESP),
        .write_en        (write_en),
        .read_en         (read_en),
        .write_addr_in   (write_addr_in),
        .write_data_in   (write_data_in),
        .strobe_in       (strobe_in),
        .read_addr_in    (read_addr_in),
        .read_data_out   (read_data_out),
        .write_response_out(write_response_out),
        .read_response_out(read_response_out),
        .write_done      (write_done),
        .read_done       (read_done)
    );

    axi4_lite_slave slave (
        .ACLK     (clk),
        .ARESETn  (reset_n),
        .AWVALID  (AWVALID),
        .AWREADY  (AWREADY),
        .AWADDR   (AWADDR),
        .AWPROT   (AWPROT),
        .WVALID   (WVALID),
        .WREADY   (WREADY),
        .WDATA    (WDATA),
        .WSTRB    (WSTRB),
        .BVALID   (BVALID),
        .BREADY   (BREADY),
        .BRESP    (BRESP),
        .ARVALID  (ARVALID),
        .ARREADY  (ARREADY),
        .ARADDR   (ARADDR),
        .ARPROT   (ARPROT),
        .RVALID   (RVALID),
        .RREADY   (RREADY),
        .RDATA    (RDATA),
        .RRESP    (RRESP)
    );

endmodule
