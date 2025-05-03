class write_driver_class extends uvm_driver #(write_sequence_item_class);
    
    //factory register
    `uvm_component_utils(write_driver_class)

    //virtual interface
    virtual write_interface_class write_interface;
    virtual write_interface_class .drive_mod vif;
    uvm_event write_done_event;

    //constructor
    function new(string name = "write_driver_class", uvm_component parent);
        super .new(name, parent);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);

        //getting interface using config_db
        if(!uvm_config_db #(virtual write_interface_class) :: get(uvm_root :: get(),
                                                                  "*",
                                                                  "write_interface_class",
                                                                  write_interface))
            `uvm_fatal("write_driver_class", "Not able to get write interface, have you set it??")
    endfunction: build_phase
    
    //connect_phase
    function void connect_phase(uvm_phase phase);
        vif = write_interface;
    endfunction: connect_phase

    //run_phase
    task run_phase(uvm_phase phase);
        wait(vif .reset_n);
        @(vif .drive_cb)

        wait(!vif .reset_n);
        vif .drive_cb .write_en <= 0;
        vif .drive_cb .write_addr_in <= 0;
        vif .drive_cb .write_data_in <= 0;
        vif .drive_cb .strobe_in <= 0;

        wait(vif .reset_n);

        forever begin
            //get sequence_item
            seq_item_port .get_next_item(req);
            
                //send to dut
                send_to_dut(req);

            //end
            seq_item_port .item_done();
        end
    endtask: run_phase

    task send_to_dut(write_sequence_item_class sequence_item);
        //driver logic
        @(vif .drive_cb)
        //@(vif .drive_cb)
        repeat(sequence_item .pre_delay);
        //@(vif .drive_cb)

        $display("in write driver value of pre delay is %d", sequence_item .pre_delay);
        $display("in write driver value of post delay is %d", sequence_item .post_delay);

        vif .drive_cb .write_en <= 1'b1;
        vif .drive_cb .write_addr_in <= sequence_item .write_addr_in;
        vif .drive_cb .write_data_in <= sequence_item .write_data_in;
        vif .drive_cb .strobe_in <= sequence_item .strobe_in;
        
        @(vif .drive_cb)
        vif .drive_cb .write_en <= 1'b0;

        wait(vif .drive_cb. write_done);

        repeat(sequence_item .post_delay);
        @(vif .drive_cb)
        shared_container :: shared_addr = sequence_item .write_addr_in;

        $display("WAITING FOR TRIGGER");
        write_done_event .trigger();
        $display("COMPLETED THE TRIGGER");
    endtask: send_to_dut

endclass: write_driver_class
