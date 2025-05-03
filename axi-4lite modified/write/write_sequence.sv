class write_sequence_class extends uvm_sequence #(write_sequence_item_class);

    //factory register
    `uvm_object_utils(write_sequence_class)

    //constructor
    function new(string name = "write_sequence_class");
        super .new(name);
    endfunction

endclass: write_sequence_class


//_________________________________________________//
//|                   write_sequence              |//
//|_______________________________________________|//
class write_data_sequence extends write_sequence_class;

    //factory register
    `uvm_object_utils(write_data_sequence)

    //variables
    bit         fix_pre_delay = 0; // 0 = random, 1 = fixed
    bit         fix_post_delay = 0; // 0 = random, 1 = fixed
    logic [31:0]fixed_pre_delay; //fixed value if fix_pre_delay = 1
    logic [31:0]fixed_post_delay; //fixed value if fix_post_delay = 1

    //constructor
    function new(string name = "write_data_sequence");
        super .new(name);
    endfunction

    task body();
        for(int i = 0; i < `NO_OF_SEQ; i++)
            begin
                req = write_sequence_item_class::type_id::create("req");
                `uvm_rand_send_with(req, {req.write_en == 1'b1; req.strobe_in == 4'b1111; if(fix_pre_delay) req.pre_delay == fixed_pre_delay; if(fix_post_delay) req.post_delay == fixed_post_delay;})                
            end
    endtask: body

endclass: write_data_sequence


//_________________________________________________//
//|        write_sequence with fixed delay        |//
//|_______________________________________________|//
class write_data_fixed_sequence extends write_sequence_class;

    //factory register
    `uvm_object_utils(write_data_fixed_sequence)

    //variables
    bit         fix_pre_delay = 0; // 0 = random, 1 = fixed
    bit         fix_post_delay = 0; // 0 = random, 1 = fixed
    logic [31:0]fixed_pre_delay; //fixed value if fix_pre_delay = 1
    logic [31:0]fixed_post_delay; //fixed value if fix_post_delay = 1

    //constructor
    function new(string name = "write_data_fixed_sequence");
        super .new(name);
    endfunction

    task body();
        for(int i = 0; i < `NO_OF_SEQ; i++)
            begin
                req = write_sequence_item_class::type_id::create("req");
                `uvm_rand_send_with(req, {req .write_en == 1'b1;
                                          req .strobe_in == 4'b1111;
                                          if(fix_pre_delay)
                                              req .pre_delay == fixed_pre_delay;
                                          if(fix_post_delay)
                                              req .post_delay == fixed_post_delay;})
            end
    endtask: body

endclass: write_data_fixed_sequence


//_________________________________________________//
//|       write_sequence with invalid addr        |//
//|_______________________________________________|//
class write_error_sequence extends write_sequence_class;

    //factory register
    `uvm_object_utils(write_error_sequence)

    //variables
    bit         fix_pre_delay = 0; // 0 = random, 1 = fixed
    bit         fix_post_delay = 0; // 0 = random, 1 = fixed
    logic [31:0]fixed_pre_delay; //fixed value if fix_pre_delay = 1
    logic [31:0]fixed_post_delay; //fixed value if fix_post_delay = 1

    //constructor
    function new(string name = "write_error_sequence");
        super .new(name);
    endfunction

    task body();
        for(int i = 0; i < `NO_OF_SEQ; i++)
            begin
                req = write_sequence_item_class::type_id::create("req");
                req .addrzero .constraint_mode(0);
                `uvm_rand_send_with(req, {req .write_en == 1'b1;
                                          req .strobe_in == 4'b1111;
                                          if(fix_pre_delay)
                                              req .pre_delay == fixed_pre_delay;
                                          if(fix_post_delay)
                                              req .post_delay == fixed_post_delay;})
            end
    endtask: body

endclass: write_error_sequence


//_________________________________________________//
//|        write_sequence with rand strobe        |//
//|_______________________________________________|//
class strobe_sequence_class extends write_sequence_class;
    
    //factory register
    `uvm_object_utils(strobe_sequence_class)

    //variables
    bit         fix_pre_delay = 0; // 0 = random, 1 = fixed
    bit         fix_post_delay = 0; // 0 = random, 1 = fixed
    logic [31:0]fixed_pre_delay; //fixed value if fix_pre_delay = 1
    logic [31:0]fixed_post_delay; //fixed value if fix_post_delay = 1

    //constructor
    function new(string name = "strobe_sequence_class");
        super .new(name);
    endfunction

    task body();
        for(int i = 0; i < `NO_OF_SEQ; i++)
            begin
                req = write_sequence_item_class::type_id::create("req");
                `uvm_rand_send_with(req, {req .write_en == 1'b1;
                                          if(fix_pre_delay)
                                              req .pre_delay == fixed_pre_delay;
                                          if(fix_post_delay)
                                              req .post_delay == fixed_post_delay;})
            end
    endtask: body

endclass: strobe_sequence_class
