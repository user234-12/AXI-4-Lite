class scoreboard_class extends uvm_scoreboard;
    
    //factory register
    `uvm_component_utils(scoreboard_class)

    //tlm connections
    uvm_tlm_analysis_fifo #(read_sequence_item_class) read_monitor_fifo; //analysis fifo from reference_model 
    uvm_tlm_analysis_fifo #(read_sequence_item_class) read_monitor_fifo1; //analysis fifo from monitor;
    read_sequence_item_class monitor_sequence_item, reference_monitor_sequence_item; 
    read_agent_config_class read_agent_config; // agent config

    //variables
    int test_failed = 0;
    int packets_tested = 0;

    //construtor
    function new(string name = "scoreboard_class", uvm_component parent);
        super. new(name, parent);

        read_monitor_fifo1 = new("read_monitor_fifo1", this);
        read_monitor_fifo = new("read_monitor_fifo", this);

        monitor_sequence_item = read_sequence_item_class :: type_id :: create("monitor_sequence_item");
        reference_monitor_sequence_item = read_sequence_item_class :: type_id :: create("reference_monitor_sequence_item");
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);

        //getting agent config_db
        if(!uvm_config_db #(read_agent_config_class) :: get(this,
                                                            " ",
                                                            "read_agent_config_class",
                                                            read_agent_config))
            `uvm_fatal("scoreboard_class", "not able to get the get the agent cofig have you set it")
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        forever verify_data();
    endtask: run_phase

    task verify_data();
        read_monitor_fifo1 .get(monitor_sequence_item);
        `uvm_info("scoreboard_class", "got read monitor transaction item", UVM_NONE)

        read_monitor_fifo .get(reference_monitor_sequence_item);
        `uvm_info("scoreboard_class", "got reference model transaction item", UVM_NONE)

        packets_tested++;

        if(!monitor_sequence_item .compare(reference_monitor_sequence_item))
            begin
                test_failed++;
                `uvm_error("scoreboard_class", "test failed, monitor packet doesn't match with reference packet")
                monitor_sequence_item .print();
                reference_monitor_sequence_item .print();
            end
        else
            begin
                `uvm_info("scoreboard_class", "test passed, monitor packet match with reference packet", UVM_NONE)
                //monitor_sequence_item .print();
                //reference_monitor_sequence_item .print();
            end
    endtask: verify_data
    
    //check_phase
    function void check_phase(uvm_phase phase);
        $display("scoreboard: number of packets test is %d", packets_tested);

        if(test_failed > 0)
            `uvm_info("scoreboard_class", $sformatf("test failed %0d times", test_failed), UVM_NONE)

        if(test_failed == 0 && packets_tested != 0)
            `uvm_info("scoreboard_class", $sformatf("test passed %0d times", packets_tested), UVM_NONE)

        if(packets_tested == 0)
            `uvm_error("scoreboard_class", "didn't recieve single packet from monitor/ reference_model to compare")
    endfunction

endclass: scoreboard_class
