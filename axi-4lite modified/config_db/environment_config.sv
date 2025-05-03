class environment_config_class extends uvm_object;

    //factory resgister
    `uvm_object_utils(environment_config_class)

    //declare agentconfig's and handles
    write_agent_config_class write_agent_config;
    read_agent_config_class  read_agent_config;

    //constructor
    function new(string name = "environment_config_class");
        super .new(name);

        write_agent_config = write_agent_config_class :: type_id :: create("write_agent_config");
        read_agent_config = read_agent_config_class :: type_id :: create("read_agent_config");
    endfunction: new

endclass: environment_config_class
