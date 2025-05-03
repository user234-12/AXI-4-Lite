class read_monitor_class extends uvm_monitor;

    //factory register
    `uvm_component_utils(read_monitor_class)

    //sequence_item instance
    read_sequence_item_class sequence_item, seq_item;

    //virtual interface
    virtual read_interface_class read_interface;
    virtual read_interface_class .monitor_mod vif;

    //analysis port
    uvm_analysis_port #(read_sequence_item_class) read_monitor_analysis_port;
    uvm_analysis_port #(read_sequence_item_class) read_monitor_act_analysis_port;

    //constructor
    function new(string name = "read_monitor_class", uvm_component parent);
        super .new(name, parent);

        read_monitor_analysis_port = new("read_monitor_analysis_port", this);
        read_monitor_act_analysis_port = new("read_monitor_act_analysis_port", this);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);

        //getting interface from config_db
        if(!uvm_config_db #(virtual read_interface_class) :: get(uvm_root :: get(),
                                                                 "*",
                                                                 "read_interface_class",
                                                                 read_interface))
            `uvm_fatal("read_monitor_class", "Not able to get read interface, have you set it??")
    endfunction: build_phase

    //connect_phase
    function void connect_phase(uvm_phase phase);
        vif = read_interface;
    endfunction: connect_phase
    
    //run_phase
    task run_phase(uvm_phase phase);
        forever collect_read_data();
    endtask: run_phase

    task collect_read_data();
        @(vif .monitor_cb)
        sequence_item = read_sequence_item_class :: type_id :: create("sequence_item"); 
        seq_item = read_sequence_item_class :: type_id :: create("seq_item");

        if(vif .monitor_cb .read_en)
            begin
                seq_item .read_en = vif .monitor_cb .read_en;
                seq_item .read_addr_in = vif .monitor_cb .read_addr_in;
                read_monitor_analysis_port .write(seq_item);

                @(vif .monitor_cb)
                //@(vif .monitor_cb)
                //@(vif .monitor_cb)
                //@(vif .monitor_cb)
                sequence_item .read_data_out = vif .monitor_cb .read_data_out;
                sequence_item .read_response_out = vif .monitor_cb .read_response_out;
                sequence_item .write_response_out = vif .monitor_cb .write_response_out;
                read_monitor_act_analysis_port .write(sequence_item);
            end
    endtask: collect_read_data

endclass: read_monitor_class
