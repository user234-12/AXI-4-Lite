class read_agent_class extends uvm_agent;
    
    //factory register
    `uvm_component_utils(read_agent_class)

    //lower class component instance
    read_driver_class    read_driver;
    read_monitor_class   read_monitor;
    read_sequencer_class read_sequencer;

    read_agent_config_class read_agent_config;

    //constructor
    function new(string name = "read_agent_class", uvm_component parent);
        super .new(name, parent);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super . build_phase(phase);

        //getting agent_config from config_db
        if(!uvm_config_db #(read_agent_config_class) :: get(this,
                                                            " ",
                                                            "read_agent_config_class",
                                                            read_agent_config))
            `uvm_fatal("read_agent_class", "Not able to get agent config, have you set it?")

        read_monitor = read_monitor_class :: type_id :: create("read_monitor", this);

        if(read_agent_config .is_active == UVM_ACTIVE)
            begin
                read_driver = read_driver_class :: type_id :: create("read_driver", this);
                read_sequencer = read_sequencer_class :: type_id :: create("read_sequencer", this);
                `uvm_info("read_agent_class", "agent is UVM_ACTIVE", UVM_NONE)
            end
        else
            `uvm_info("read_agent_class", "agent is UVM_PASSIVE", UVM_NONE)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        if(read_agent_config .is_active == UVM_ACTIVE)
            read_driver .seq_item_port .connect(read_sequencer .seq_item_export);
    endfunction: connect_phase

endclass: read_agent_class
