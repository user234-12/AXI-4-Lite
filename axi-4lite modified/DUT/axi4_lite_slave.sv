module axi4_lite_slave (
    input  logic         ACLK,
    input  logic         ARESETn,
    input  logic         AWVALID,
    output logic         AWREADY,
    input  logic [31:0]  AWADDR,
    input  logic [2:0]   AWPROT,
    input  logic         WVALID,
    output logic         WREADY,
    input  logic [31:0]  WDATA,
    input  logic [3:0]   WSTRB,
    output logic         BVALID,
    input  logic         BREADY,
    output logic [1:0]   BRESP,
    input  logic         ARVALID,
    output logic         ARREADY,
    input  logic [31:0]  ARADDR,
    input  logic [2:0]   ARPROT,
    output logic         RVALID,
    input  logic         RREADY,
    output logic [31:0]  RDATA,
    output logic [1:0]   RRESP
);

    localparam ADDR_WIDTH = 32;
    localparam DATA_WIDTH = 32;
    localparam MEM_DEPTH  = 256;

    logic [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];
    logic [ADDR_WIDTH-1:0] write_addr;
    logic [ADDR_WIDTH-1:0] read_addr_reg; // Register for read address

    typedef enum logic [2:0] {
        W_IDLE  = 3'b000,
        W_ADDR  = 3'b001,
        W_DATA  = 3'b010,
        W_RESP  = 3'b011
    } write_state_t;
    write_state_t w_state;

    typedef enum logic [2:0] {
        R_IDLE  = 3'b000,
        R_ADDR  = 3'b001,
        R_DATA  = 3'b010
    } read_state_t;
    read_state_t r_state;

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            w_state <= W_IDLE;
            r_state <= R_IDLE;
            write_addr <= 0;
            read_addr_reg <= 0;
            for (int i = 0; i < MEM_DEPTH; i++) memory[i] <= 0;
        end else begin
            case (w_state)
                W_IDLE: begin
                    if (AWVALID && AWREADY) begin
                        write_addr <= AWADDR;
                        w_state <= W_ADDR;
                    end
                end
                W_ADDR: begin
                    if (WVALID && WREADY) begin
                        if (write_addr[31:10] == 0) begin
                            for (int i = 0; i < 4; i++) begin
                                if (WSTRB[i]) memory[write_addr[9:2]][i*8 +: 8] <= WDATA[i*8 +: 8];
                            end
                        end
                        w_state <= W_DATA;
                    end
                end
                W_DATA: begin
                    if (BVALID && BREADY) begin
                        w_state <= W_IDLE;
                    end
                end
                W_RESP: begin
                    if (BREADY) begin
                        w_state <= W_IDLE;
                    end
                end
                default: w_state <= W_IDLE;
            endcase

            case (r_state)
                R_IDLE: begin
                    if (ARVALID && ARREADY) begin
                        read_addr_reg <= ARADDR; // Latch read address
                        r_state <= R_ADDR;
                    end
                end
                R_ADDR: begin
                    r_state <= R_DATA;
                end
                R_DATA: begin
                    if (RVALID && RREADY) begin
                        r_state <= R_IDLE;
                    end
                end
                default: r_state <= R_IDLE;
            endcase
        end
    end

    always_comb begin
        AWREADY = (w_state == W_IDLE);
        WREADY = (w_state == W_ADDR);
        BVALID = (w_state == W_DATA || w_state == W_RESP);
        BRESP = (write_addr[31:10] != 0) ? 2'b10 : 2'b00;

        ARREADY = (r_state == R_IDLE);
        RVALID = (r_state == R_DATA);
        RDATA = (read_addr_reg[31:10] == 0) ? memory[read_addr_reg[9:2]] : 32'h0; // Return stored data or 0 for invalid
        RRESP = (read_addr_reg[31:10] != 0) ? 2'b10 : 2'b00;
    end

endmodule

