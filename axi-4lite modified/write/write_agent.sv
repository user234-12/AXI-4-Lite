class write_agent_class extends uvm_agent;
    
    //factory register
    `uvm_component_utils(write_agent_class)

    //lower class component instnace
    write_driver_class    write_driver;
    write_monitor_class   write_monitor;
    write_sequencer_class write_sequencer;

    write_agent_config_class write_agent_config;

    //constructor
    function new(string name = "write_agent_class", uvm_component parent);
        super .new(name, parent);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);

        //getting agent_config from config_db
        if(!uvm_config_db #(write_agent_config_class) :: get(this,
                                                             " ",
                                                             "write_agent_config_class",
                                                             write_agent_config))
            `uvm_fatal("write_agent_class", "Not able to get agent config, have you set it?")

        write_monitor = write_monitor_class :: type_id :: create("write_monitor", this);

        if(write_agent_config .is_active == UVM_ACTIVE)
            begin
                write_driver = write_driver_class :: type_id :: create("write_driver", this);
                write_sequencer = write_sequencer_class :: type_id :: create("write_sequncer", this);
                `uvm_info("write_agent_class", "agent is UVM_ACTIVE", UVM_NONE)
            end
        else
            `uvm_info("write_agent_class", "agent is UVM_PASSIVE", UVM_NONE)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        if(write_agent_config .is_active == UVM_ACTIVE)
            write_driver .seq_item_port .connect(write_sequencer .seq_item_export);
    endfunction: connect_phase

endclass: write_agent_class
