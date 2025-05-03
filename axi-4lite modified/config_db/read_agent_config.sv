class read_agent_config_class extends uvm_object;

    //factory register
    `uvm_object_utils(read_agent_config_class)

    uvm_active_passive_enum is_active = UVM_PASSIVE;

    //constructor
    function new(string name = "read_agent_config_class");
        super .new(name);
    endfunction: new

endclass: read_agent_config_class
