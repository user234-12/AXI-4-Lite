class read_driver_class extends uvm_driver #(read_sequence_item_class);
    
    //factory register
    `uvm_component_utils(read_driver_class)

    //virtual interface
    virtual read_interface_class read_interface;
    virtual read_interface_class .drive_mod vif;
    uvm_event write_done_event;

    //constructor
    function new(string name = "read_driver_class", uvm_component parent);
        super .new(name, parent);
    endfunction: new

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);

        //getting interface using config_db
        if(!uvm_config_db #(virtual read_interface_class) :: get(uvm_root :: get(),
                                                                 "*",
                                                                 "read_interface_class",
                                                                 read_interface))
            `uvm_fatal("read_driver_class", "Not able to get read interface, have you set it??")
    endfunction: build_phase
    
    //connect_phase
    function void connect_phase(uvm_phase phase);
        vif = read_interface;
    endfunction: connect_phase

    //run_phase
    task run_phase(uvm_phase phase);
        vif .drive_cb .read_en <= 0;
        vif .drive_cb .read_addr_in <= 0;
        wait(vif .reset_n);
        @(vif .drive_cb)

        wait(!vif .reset_n);
        wait(vif .reset_n);

        forever begin
            write_done_event .wait_trigger();
            $display("got the trigger from write agent");

            //get sequence_item
            seq_item_port .get_next_item(req);
            
                //send to dut
                send_to_dut(req);

            //end
            seq_item_port .item_done();
        end
    endtask: run_phase

    task send_to_dut(read_sequence_item_class sequence_item);
        //driver logic
        @(vif .drive_cb)
        repeat(sequence_item .pre_delay); 
        //@(vif .drive_cb)
        $display("in read driver value of pre delay is %d", sequence_item .pre_delay);
        $display("in read driver value of post delay is %d", sequence_item .post_delay);

        vif .drive_cb .read_en <= 1'b1;
        //vif .drive_cb .read_addr_in <= sequence_item .read_addr_in;
        vif .drive_cb .read_addr_in <= shared_container :: shared_addr;
        
        @(vif .drive_cb)
        vif .drive_cb .read_en <= 1'b0;

        wait(vif .drive_cb. read_done);

        repeat(sequence_item .post_delay);
        //@(vif .drive_cb);
    endtask: send_to_dut

endclass: read_driver_class
