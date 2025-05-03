class write_test_class extends uvm_test;
    
    //factory register
    `uvm_component_utils(write_test_class)

    //declare component and create handles
    environment_class        environment;
    environment_config_class environment_config;

    write_data_sequence write_data_seq;
    read_send_sequence  read_send_seq;

    //constructor
    function new(string name = "write_test_class", uvm_component parent);
        super .new(name, parent);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);

        environment_config = environment_config_class :: type_id :: create("environment_config");
        environment_config .write_agent_config .is_active = UVM_ACTIVE;
        environment_config .read_agent_config .is_active = UVM_ACTIVE;

        uvm_config_db #(environment_config_class) :: set(this,
                                                         "*",
                                                         "environment_config_class",
                                                         environment_config);

        environment = environment_class :: type_id :: create("environment", this);
    endfunction: build_phase

    //run_phase
    task run_phase(uvm_phase phase);
        phase .raise_objection(this);
            fork
                begin
                    write_data_seq = write_data_sequence :: type_id :: create("write_data_seq");
                    write_data_seq .fix_pre_delay = 1;
                    write_data_seq .fix_post_delay = 1;
                    write_data_seq .fixed_pre_delay = 0;
                    write_data_seq .fixed_post_delay = 0;

                    write_data_seq .start(environment .write_agent .write_sequencer);
                end
                begin
                    read_send_seq = read_send_sequence :: type_id :: create("read_send_seq");
                    read_send_seq .fix_pre_delay = 1;
                    read_send_seq .fix_post_delay = 1;
                    read_send_seq .fixed_pre_delay = 0;
                    read_send_seq .fixed_post_delay = 0;

                    read_send_seq .start(environment .read_agent .read_sequencer);
                end
            join

            `uvm_info("write_test_class", "waiting for drop objection", UVM_NONE)
        phase .drop_objection(this);
        `uvm_info("write_test_class", "drop objection completed", UVM_NONE)
    endtask: run_phase

    function void report_phase(uvm_phase phase);
        uvm_report_server svr;
        super .report_phase(phase);

        svr = uvm_report_server :: get_server();

        if(svr .get_severity_count(UVM_FATAL) + svr .get_severity_count(UVM_ERROR) > 0)
            begin
                $display("------------------");
                $display(" TEST CASE FAILED ");
                $display("------------------");
            end
        else
            begin
                $display("------------------");
                $display(" TEST CASE PASSED ");
                $display("------------------");
            end
    endfunction: report_phase    

endclass: write_test_class
