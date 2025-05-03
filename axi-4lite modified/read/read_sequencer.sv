class read_sequencer_class extends uvm_sequencer #(read_sequence_item_class);

    //factory register
    `uvm_component_utils(read_sequencer_class)

    //constructor
    function new(string name = "read_sequencer_class", uvm_component parent);
        super .new(name, parent);
    endfunction

    //build_phase
    function void build_phase(uvm_phase phase);
        super .build_phase(phase);
    endfunction: build_phase

endclass: read_sequencer_class
