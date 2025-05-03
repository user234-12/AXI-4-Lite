module axi4_lite_master (
    input  logic         ACLK,
    input  logic         ARESETn,
    output logic         AWVALID,
    input  logic         AWREADY,
    output logic [31:0]  AWADDR,
    output logic [2:0]   AWPROT,
    output logic         WVALID,
    input  logic         WREADY,
    output logic [31:0]  WDATA,
    output logic [3:0]   WSTRB,
    input  logic         BVALID,
    output logic         BREADY,
    input  logic [1:0]   BRESP,
    output logic         ARVALID,
    input  logic         ARREADY,
    output logic [31:0]  ARADDR,
    output logic [2:0]   ARPROT,
    input  logic         RVALID,
    output logic         RREADY,
    input  logic [31:0]  RDATA,
    input  logic [1:0]   RRESP,
    input  logic         write_en,
    input  logic         read_en,
    input  logic [31:0]  write_addr_in,
    input  logic [31:0]  write_data_in,
    input  logic [3:0]   strobe_in,
    input  logic [31:0]  read_addr_in,
    output logic [31:0]  read_data_out,
    output logic [1:0]   write_response_out,
    output logic [1:0]   read_response_out,
    output logic         write_done,
    output logic         read_done
);

    typedef enum logic [2:0] {
        W_IDLE  = 3'b000,
        W_ADDR  = 3'b001,
        W_DATA  = 3'b010,
        W_RESP  = 3'b011,
        W_DONE  = 3'b100
    } write_state_t;
    write_state_t w_state;

    typedef enum logic [2:0] {
        R_IDLE  = 3'b000,
        R_ADDR  = 3'b001,
        R_DATA  = 3'b010,
        R_DONE  = 3'b011
    } read_state_t;
    read_state_t r_state;

    // Clocked State Logic
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            w_state <= W_IDLE;
            r_state <= R_IDLE;
            read_data_out <= 0;
            write_response_out <= 0;
            read_response_out <= 0;
            write_done <= 0;
            read_done <= 0;
        end else begin
            // Write State Machine
            case (w_state)
                W_IDLE: begin
                    write_done <= 0;
                    if (write_en) begin
                        w_state <= W_ADDR;
                    end
                end
                W_ADDR: begin
                    if (AWREADY) begin
                        w_state <= W_DATA;
                    end
                end
                W_DATA: begin
                    if (WREADY) begin
                        w_state <= W_RESP;
                    end
                end
                W_RESP: begin
                    if (BVALID) begin
                        write_response_out <= BRESP;
                        write_done <= 1;
                        w_state <= W_DONE;
                    end
                end
                W_DONE: begin
                    write_done <= 0;
                    w_state <= W_IDLE;
                end
                default: w_state <= W_IDLE;
            endcase

            // Read State Machine
            case (r_state)
                R_IDLE: begin
                    read_done <= 0;
                    if (read_en) begin
                        r_state <= R_ADDR;
                    end
                end
                R_ADDR: begin
                    if (ARREADY) begin
                        r_state <= R_DATA;
                    end
                end
                R_DATA: begin
                    if (RVALID) begin
                        read_data_out <= RDATA;
                        read_response_out <= RRESP;
                        read_done <= 1;
                        r_state <= R_DONE;
                    end
                end
                R_DONE: begin
                    read_done <= 0;
                    r_state <= R_IDLE;
                end
                default: r_state <= R_IDLE;
            endcase
        end
    end

    // Combinational Handshake Logic
    always_comb begin
        // Write Channel
        AWVALID = (w_state == W_ADDR);
        AWADDR = write_addr_in;
        AWPROT = 3'b000;
        WVALID = (w_state == W_DATA);
        WDATA = write_data_in;
        WSTRB = strobe_in;
        BREADY = (w_state == W_RESP);

        // Read Channel
        ARVALID = (r_state == R_ADDR);
        ARADDR = read_addr_in;
        ARPROT = 3'b000;
        RREADY = (r_state == R_DATA);
    end

endmodule
