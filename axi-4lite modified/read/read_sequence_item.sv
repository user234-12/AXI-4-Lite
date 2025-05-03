class read_sequence_item_class extends uvm_sequence_item;
    
    //randomize variables
    rand logic                      read_en;
    rand logic [`WIDTH_ADDR - 1 : 0]read_addr_in;
         logic [`WIDTH_DATA - 1 : 0]read_data_out;
         logic [1:0]                write_response_out;
         logic [1:0]                read_response_out;
    rand logic [3:0]                pre_delay;
    rand logic [3:0]                post_delay;

    `uvm_object_utils_begin(read_sequence_item_class)
        `uvm_field_int(read_en, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(read_addr_in, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(read_data_out, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(write_response_out, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(read_response_out, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(pre_delay, UVM_DEC | UVM_ALL_ON)
        `uvm_field_int(post_delay, UVM_DEC | UVM_ALL_ON)
    `uvm_object_utils_end
    
    //constraint
    constraint raddrfix {read_addr_in % 4 == 0;}
    
    //constructor
    function new(string name = "read_sequence_item_class");
        super .new(name);
    endfunction: new

endclass: read_sequence_item_class
