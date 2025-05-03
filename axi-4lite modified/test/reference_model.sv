class reference_model_class extends uvm_component;
    
    //factory register
    `uvm_component_utils(reference_model_class)

    //tlm connections
    uvm_tlm_analysis_fifo #(write_sequence_item_class) write_monitor_fifo;
    uvm_tlm_analysis_fifo #(read_sequence_item_class) read_monitor_fifo;
    uvm_analysis_port #(read_sequence_item_class) reference_analysis_port;

    logic [31:0]mem[0:255];
    logic [3:0]local_strob;
    logic [31:0]data_out;

    //construtor
    function new(string name = "reference_model_class", uvm_component parent);
        super .new(name, parent);

        write_monitor_fifo = new("write_monitor_fifo", this);
        read_monitor_fifo = new("read_monitor_fifo", this);

        reference_analysis_port = new("reference_analysis_port", this);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);
    endfunction: build_phase

    //run_phase
    task run_phase(uvm_phase phase);
        write_sequence_item_class wr_tr_write;
        read_sequence_item_class r_tr_write, r_out_tr;

        forever begin
            r_out_tr = read_sequence_item_class :: type_id :: create("r_out_tr");
            fork
                begin
                    write_monitor_fifo .get(wr_tr_write);

                    if(wr_tr_write .write_en)
                        begin
                            local_strob = wr_tr_write .strobe_in;
                            mem[wr_tr_write. write_addr_in[9:2]] = wr_tr_write .write_data_in;
                        end
                end
                
                begin
                    read_monitor_fifo .get(r_tr_write);
                    begin
                        #10;
                        for(int i = 0; i < 4; i++)
                            begin
                                if(local_strob[i])
                                    begin
                                        data_out[i*8 +: 8] = mem[r_tr_write .read_addr_in[9:2]][i*8 +: 8];
                                    end                            
                                else
                                    begin
                                        data_out[i*8 +: 8] = 0; 
                                    end
                            end            
                        r_out_tr .read_data_out = data_out;
                        $display("reference_model value of addr is %h", r_tr_write .read_addr_in[9:2]);

                        if(r_tr_write .read_addr_in[31:10] == 0)
                            begin
                                r_out_tr .read_data_out = data_out;
                                r_out_tr .read_response_out = 0;
                                r_out_tr .write_response_out = 0;
                            end
                        else
                            begin
                                r_out_tr .read_data_out = 0;
                                r_out_tr .read_response_out = 2'd2;
                                r_out_tr .write_response_out = 2'd2;
                            end
                        reference_analysis_port .write(r_out_tr);        
                    end
                end
            join
        end
    endtask: run_phase

endclass: reference_model_class
