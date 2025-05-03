class write_sequencer_class extends uvm_sequencer #(write_sequence_item_class);

    //factory register
    `uvm_component_utils(write_sequencer_class)

    //constructor
    function new(string name = "write_sequencer_class", uvm_component parent);
        super .new(name, parent);
    endfunction

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);
    endfunction: build_phase

endclass: write_sequencer_class
