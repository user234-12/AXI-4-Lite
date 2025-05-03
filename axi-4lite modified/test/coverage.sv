class write_coverage_class extends uvm_subscriber #(write_sequence_item_class);
    
    //register factory
    `uvm_component_utils(write_coverage_class)

    write_sequence_item_class transaction;
    real coverage_score;

    //covergroup for write transaction
    covergroup write_cg;
        
        //write enable coverage
        WRITE_EN_cp: coverpoint transaction .write_en{bins enabled = {1};
                                                      bins disabled = {0};}
        
        //write address coverage
        WRITE_ADDR_IN_cp: coverpoint transaction .write_addr_in{bins low = {[0:32'h0000_03FF]}; //based on constraint addrzero
                                                                bins mid = {[32'h0000_0400:32'h0000_FFFF]};
                                                                bins high = {[32'h0001_0000:32'hFFFF_FFFF]};}
        
        //write data coverage
        WRITE_DATA_IN_cp: coverpoint transaction .write_data_in{bins zero = {0};
                                                                bins low = {[1:32'h0000_FFFF]};
                                                                bins high = {[32'h0001_0000:32'hFFFF_FFFF]};}
    
        //strobe coverage
        STROBE_IN_cp: coverpoint transaction .strobe_in{bins byte0 = {4'b0001};
                                                        bins byte1 = {4'b0010};
                                                        bins byte2 = {4'b0100};
                                                        bins byte3 = {4'b1000};
                                                        bins full = {4'b1111};}
        
        //pre and post delay coverage
        PRE_DELAY_cp: coverpoint transaction .pre_delay{bins zero = {0};
                                                        bins low = {[1:3]};
                                                        bins high = {[4:15]};}
        
        POST_DELAY_cp: coverpoint transaction .post_delay{bins zero = {0};
                                                          bins low = {[1:3]};
                                                          bins high = {[4:15]};}
    endgroup: write_cg
    
    //constructor
    function new(string name = "write_coverage_class", uvm_component parent);
        super .new(name, parent);

        write_cg = new();
        transaction = new("transaction");
    endfunction: new

    function void write(write_sequence_item_class trans);
        //transaction = trans;
        write_cg .sample();
    endfunction: write

    //final_phase
    function void final_phase(uvm_phase phase);
        coverage_score = write_cg .get_coverage();
        
        `uvm_info("write_coverage_class", $sformat("coverage = %0f%%", coverage_score), UVM_NONE);
    endfunction: final_phase

endclass: write_coverage_class


class read_coverage_class extends uvm_subscriber #(read_sequence_item_class);

    //factory register
    `uvm_component_utils(read_coverage_class)

    read_sequence_item_class transaction;
    real coverage_score;

    //covergroup for read transaction
    covergroup read_cg;
        
        //read enable coverage
        READ_EN_cp: coverpoint transaction .read_en{bins enabled = {1};
                                                    bins disabled = {0};}
        
        //read address coverage
        READ_ADDR_IN_cp: coverpoint transaction .read_addr_in{bins low = {[0:32'h0000_03FF]}; //based on constraint addrzero
                                                              bins mid = {[32'h0000_0400:32'h0000_FFFF]};
                                                              bins high = {[32'h0001_0000:32'hFFFF_FFFF]};}
        
        //read data coverage
        READ_DATA_OUT_cp: coverpoint transaction .read_data_out{bins zero = {0};
                                                                bins low = {[1:32'h0000_FFFF]};
                                                                bins high = {[32'h0001_0000:32'hFFFF_FFFF]};}
    
        //response coverage
        RESPONSE_OUT_cp: coverpoint transaction .read_response_out{bins okay = {2'b00}; //OKAY
                                                                   bins slverr = {2'b10}; //SLVERR
                                                                   bins decerr = {2'b11}; //DECERR
                                                                   }
        
        //pre and post delay coverage
        PRE_DELAY_cp: coverpoint transaction .pre_delay{bins zero = {0};
                                                        bins low = {[1:3]};
                                                        bins high = {[4:15]};}
        
        POST_DELAY_cp: coverpoint transaction .post_delay{bins zero = {0};
                                                          bins low = {[1:3]};
                                                          bins high = {[4:15]};} 
    endgroup: read_cg
    
    //constructor
    function new(string name = "read_coverage_class", uvm_component parent);
        super .new(name, parent);

        read_cg = new();
        transaction = new("transaction");
    endfunction: new

    function void write(read_sequence_item_class trans);
        //transaction = trans;
        read_cg .sample();
    endfunction: write

    //final_phase
    function void final_phase(uvm_phase phase);
        coverage_score = read_cg .get_coverage();
        
        `uvm_info("read_coverage_class", $sformat("coverage = %0f%%", coverage_score), UVM_NONE);
    endfunction: final_phase

endclass: read_coverage_class

/*
class coverage_class extends uvm_subscriber #(write_sequence_item_class);        

    //factory register
    `uvm_component_utils(coverage_class)

    //covergroup
    covergroup cg;
    
        //write transaction coverage
        WRITE_EN_cp: coverpoint trans .write_en{bins enabled = {1};
                                                bins disabled = {0};}
        
        AWADDR_cp: coverpoint trans .awaddr{bins low = {[0 : 32'h0000_FFFF]};
                                             bins high = {[32'h0001_0000 : 32'hFFFF_FFFF]};}
        
        WDATA_cp: coverpoint trans .wdata{bins low = {0};
                                          bins high = {[1 : 32'hFFFF_FFFF]};}
        
        WSTRB_cp: coverpoint trans .wstrb{bins byte0 = {4'b0001};
                                          bins byte1 = {4'b0010};
                                          bins byte2 = {4'b0100};
                                          bins byte3 = {4'b1000};
                                          bins full = {4'b1111};} 
        
        BRESP_cp: coverpoint trans .bresp{bins okay = {2'b00};
                                          bins slverr = {2'b10};
                                          bins decerr = {2'b11};}
        
        //read transaction coverage
        READ_EN_cp: coverpoint trans .read_en{bins enabled = {1};
                                                bins disabled = {0};}
        
        ARADDR_cp: coverpoint trans .araddr{bins low = {[0 : 32'h0000_FFFF]};
                                             bins high = {[32'h0001_0000 : 32'hFFFF_FFFF]};}
        
        RRESP_cp: coverpoint trans .rresp{bins okay = {2'b00};
                                          bins slverr = {2'b10};
                                          bins decerr = {2'b11};}
        
        //handshaking signals
        WRITE_HANDSHAKE_cp : coverpoint {trans .awvalid, trans .awready} {bins valid_ready = {2'b11};
                                                                          bins valid_noready = {2'b10};
                                                                          bins invalid_ready = {2'b01};
                                                                          bins idle = {2'b00};}
        
        DATA_HANDSHAKE_cp : coverpoint {trans .wvalid, trans .wready} {bins valid_ready = {2'b11};
                                                                       bins valid_noready = {2'b10};
                                                                       bins invalid_ready = {2'b01};
                                                                       bins idle = {2'b00};}
        
        RESP_HANDSHAKE_cp : coverpoint {trans .bvalid, trans .bready} {bins valid_ready = {2'b11};
                                                                       bins valid_noready = {2'b10};
                                                                       bins invalid_ready = {2'b01};
                                                                       bins idle = {2'b00};}
    
        READ_ADDR_HANDSHAKE_cp : coverpoint {trans .arvalid, trans .arready} {bins valid_ready = {2'b11};
                                                                              bins valid_noready = {2'b10};
                                                                              bins invalid_ready = {2'b01};
                                                                              bins idle = {2'b00};}
        
        //cross coverage
        //WRITE_TXN_cp: cross WRITE_EN, BRESP, WSTRB{ignore_bins disabled = binsof(WRITE_EN) intersect {0};}
        WRITE_TXN_cp: cross write_en, bresp, wstrb{ignore_bins disabled = binsof(write_en) intersect {0};}

        //READ_TXN_cp: cross READ_EN, RRESP{ignore_bins disabled = binsof(READ_EN) intersect {0};}
        READ_TXN_cp: cross read_en, rresp{ignore_bins disabled = binsof(read_en) intersect {0};}
    endgroup

    write_sequence_item_class wr_seq_item;

    //constructor
    function new(string name, uvm_component parent);
        super .new(name, parent);
        cg =new();
        wr_seq_item = new("wr_seq_item");
    endfunction: new

    //coverage sample
    virtual function void write(write_sequence_item_class sequence_item);
        wr_seq_item = sequence_item;
        cg .sample();
    endfunction: write

    //report_phase
    function void report_phase(uvm_phase phase);
        super .report_phase(phase);
        
        `uvm_info(get_type_name(), $sformatf("Coverage: %0.2f%%", cg. get_coverage()), UVM_LOW)
    endfunction: report_phase

endclass: coverage_class
*/
