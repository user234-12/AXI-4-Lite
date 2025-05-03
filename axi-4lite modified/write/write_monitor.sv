class write_monitor_class extends uvm_monitor;
    
    //factory register
    `uvm_component_utils(write_monitor_class)

    //seq_item instance
    write_sequence_item_class sequence_item;

    //virtual interface
    virtual write_interface_class write_interface;
    virtual write_interface_class .monitor_mod vif;

    //analysis port
    uvm_analysis_port #(write_sequence_item_class) write_monitor_analysis_port;

    //constructor
    function new(string name = "write_monitor_class", uvm_component parent);
        super .new(name, parent);

        write_monitor_analysis_port = new("write_monitor_analysis_port", this);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);

        //getting interface from config_db
        if(!uvm_config_db #(virtual write_interface_class) :: get(uvm_root :: get(),
                                                                  "*",
                                                                  "write_interface_class",
                                                                  write_interface))
            `uvm_fatal("write_monitor_class", "Not able to get write interface, have you set it??")
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        vif = write_interface;
    endfunction: connect_phase

    task run_phase(uvm_phase phase);
        forever collect_write_data();
    endtask: run_phase

    task collect_write_data();
        @(vif .monitor_cb)
        sequence_item = write_sequence_item_class :: type_id :: create("sequence_item");

        if(vif .monitor_cb .write_en)
            begin
                sequence_item .write_en = vif .monitor_cb .write_en;
                sequence_item .write_addr_in = vif .monitor_cb .write_addr_in;
                sequence_item .write_data_in = vif .monitor_cb .write_data_in;
                sequence_item .strobe_in = vif .monitor_cb .strobe_in;
                write_monitor_analysis_port .write(sequence_item);
            end
    endtask: collect_write_data

endclass: write_monitor_class
