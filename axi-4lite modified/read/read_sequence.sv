class read_sequence_class extends uvm_sequence #(read_sequence_item_class);

    //factory register
    `uvm_object_utils(read_sequence_class)

    //constructor
    function new(string name = "read_sequence_class");
        super .new(name);
    endfunction: new

endclass: read_sequence_class


//_________________________________________________//
//|              read_send_sequence               |//
//|_______________________________________________|//
class read_send_sequence extends read_sequence_class;

    //factory register
    `uvm_object_utils(read_send_sequence)

    //variables
    bit         fix_pre_delay = 0; // 0 = random, 1 = fixed
    bit         fix_post_delay = 0; // 0 = random, 1 = fixed
    logic [31:0]fixed_pre_delay; //fixed value if fix_pre_delay = 1
    logic [31:0]fixed_post_delay; //fixed value if fix_post_delay = 1

    //constructor
    function new(string name = "read_send_sequence");
        super .new(name);
    endfunction: new

    task body();
        for(int i = 0; i < `NO_OF_SEQ; i++)
            begin
                req = read_sequence_item_class :: type_id :: create("req");
                `uvm_rand_send_with(req, {req .read_en == 1'b1;
                                          if(fix_pre_delay)
                                              req .pre_delay == fixed_pre_delay;
                                          if(fix_post_delay)
                                              req .post_delay == fixed_post_delay;})                
            end
    endtask: body

endclass: read_send_sequence


//_________________________________________________//
//|        read_sequence with fixed delays        |//
//|_______________________________________________|//
class read_data_fixed_sequence extends read_sequence_class;

    //factory register
    `uvm_object_utils(read_data_fixed_sequence)

    //variables
    bit         fix_pre_delay = 0; // 0 = random, 1 = fixed
    bit         fix_post_delay = 0; // 0 = random, 1 = fixed
    logic [31:0]fixed_pre_delay; //fixed value if fix_pre_delay = 1
    logic [31:0]fixed_post_delay; //fixed value if fix_post_delay = 1

    //constructor
    function new(string name = "read_data_fixed_sequence");
        super .new(name);
    endfunction: new

    task body();
        for(int i = 0; i < `NO_OF_SEQ; i++)
            begin
                req = read_sequence_item_class :: type_id :: create("req");
                `uvm_rand_send_with(req, {req .read_en == 1'b1;
                                          if(fix_pre_delay)
                                              req .pre_delay == fixed_pre_delay;
                                          if(!fix_post_delay)
                                              req .post_delay == 0;})
            end
    endtask: body

endclass: read_data_fixed_sequence
