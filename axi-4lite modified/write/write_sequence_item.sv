class write_sequence_item_class extends uvm_sequence_item;

    //randomize variables
    rand logic                        write_en;
    rand logic [`WIDTH_ADDR - 1 : 0]  write_addr_in;
    rand logic [`WIDTH_DATA - 1 : 0]  write_data_in;
    rand logic [`STROBE_WIDTH - 1 : 0]strobe_in; 
    rand logic [3:0]                  pre_delay;
    rand logic [3:0]                  post_delay;
    
    //factory register
    `uvm_object_utils_begin(write_sequence_item_class)
        `uvm_field_int(write_en, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(write_addr_in, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(write_data_in, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(strobe_in, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(pre_delay, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(post_delay, UVM_DEC | UVM_ALL_ON)
    `uvm_object_utils_end

    //constraints
    constraint addrfix {write_addr_in % 4 == 0;}
    constraint addrzero{write_addr_in [31:10] == 0;}
    
    //constructor
    function new(string name = "write_sequence_item_class");
        super .new(name);
    endfunction: new

endclass: write_sequence_item_class
