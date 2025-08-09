package sequencer_pack;
import uvm_pkg::*;

import sequence_item_pack::*;
`include "uvm_macros.svh"
class sequencer_class extends uvm_sequencer #(seq_item_class);
`uvm_component_utils (sequencer_class)
function new (string name= "sequencer_class",uvm_component parent =null);
super.new(name,parent);
endfunction
endclass
endpackage