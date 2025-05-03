class environment_class extends uvm_env;
    
    //factory register
    `uvm_component_utils(environment_class)

    //declare component and create handles
    write_agent_class write_agent;
    read_agent_class  read_agent;
    uvm_event         write_done_event;
    
    scoreboard_class         scoreboard;

    //coverage_class           cvg;
    //write_coverage_class     write_cg;
    //read_coverage_class      read_cg;

    reference_model_class    reference_model;
                             
    environment_config_class environment_config;

    //constructor
    function new(string name = "environment_class", uvm_component parent);
        super .new(name, parent);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);

        if(!uvm_config_db #(environment_config_class) :: get(this,
                                                             " ",
                                                             "environment_config_class",
                                                             environment_config))
            `uvm_fatal("environment_class", "Not able to get the env_config have you set it?")
        //write_cg = write_coverage_class :: type_id :: create("write_cg", this);
        //read_cg = read_coverage_class :: type_id :: create("read_cg", this);
        
        //setting agent config
        uvm_config_db #(write_agent_config_class) :: set(this,
                                                         "*",
                                                         "write_agent_config_class",
                                                         environment_config .write_agent_config);
        write_agent = write_agent_class :: type_id :: create("write_agent", this);

        uvm_config_db #(read_agent_config_class) :: set(this,
                                                        "*",
                                                        "read_agent_config_class",
                                                        environment_config .read_agent_config);
        read_agent = read_agent_class :: type_id :: create("read_agent", this);

        write_done_event = new("write_done_event");

        //cvg = coverage_class :: type_id :: create("cvg", this);

        reference_model = reference_model_class :: type_id :: create("reference_model", this);
        scoreboard = scoreboard_class :: type_id :: create("scoreboard", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        //tlm ports
        write_agent .write_monitor .write_monitor_analysis_port .connect(reference_model .write_monitor_fifo .analysis_export); //monitor to reference model

        read_agent .read_monitor .read_monitor_analysis_port .connect(reference_model .read_monitor_fifo .analysis_export); //moniotor rd_en to reference model

        reference_model .reference_analysis_port .connect(scoreboard .read_monitor_fifo .analysis_export); //reference model to scoreboard in future

        read_agent .read_monitor .read_monitor_analysis_port .connect(scoreboard .read_monitor_fifo1 .analysis_export); //monitor to scoreboard
        
        //coverages
        //write_agent .write_monitor .write_monitor_analysis_port .connect(cvg .analysis_export);
        //write_agent .write_monitor .write_monitor_analysis_port .connect(write_cg .analysis_export);
        //read_agent .read_monitor .read_monitor_analysis_port .connect(read_cg .analysis_export);

        //connecting the triggers
        write_agent .write_driver .write_done_event = write_done_event;
        read_agent .read_driver .write_done_event = write_done_event;

    endfunction: connect_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top .print_topology();
    endfunction: end_of_elaboration_phase

endclass: environment_class
