package sequence_pack;
import uvm_pkg::*;
import sequence_item_pack::*;

`include "uvm_macros.svh"
class sequence_class_reset extends uvm_sequence #(seq_item_class);
`uvm_object_utils(sequence_class_reset)
seq_item_class seq_item;
function new(string name= "sequence_class_reset");
    super.new(name); 
    endfunction
    task body;
    seq_item =seq_item_class::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.rst_n=0;
    finish_item(seq_item);
    endtask
endclass
class sequence_class_write_only extends uvm_sequence #(seq_item_class);
`uvm_object_utils(sequence_class_write_only)
seq_item_class seq_item;
function new(string name= "sequence_class_write_only");
    super.new(name); 
    endfunction
    task body;
    repeat (100)
    begin
        seq_item =seq_item_class::type_id::create("seq_item");
         start_item(seq_item);
         seq_item.wr_en=1;
         seq_item.rd_en=0;
         seq_item.rst_n=1;
  seq_item.data_in=$random;
finish_item(seq_item);
    end
    endtask
endclass
class sequence_class_read_only extends uvm_sequence #(seq_item_class);
`uvm_object_utils(sequence_class_read_only)
seq_item_class seq_item;
function new(string name= "sequence_class_read_only");
    super.new(name); 
    endfunction
    task body;
    repeat (100)
    begin
        seq_item =seq_item_class::type_id::create("seq_item");
         start_item(seq_item);
         seq_item.rd_en=1;
         seq_item.wr_en=0;
         seq_item.rst_n=1;
finish_item(seq_item);
    end
    endtask
endclass
class sequence_class_write_and_read extends uvm_sequence #(seq_item_class);
`uvm_object_utils(sequence_class_write_and_read)
seq_item_class seq_item;
function new(string name= "sequence_class_write_and_read");
    super.new(name); 
    endfunction
    task body;
    repeat (1000)
    begin
        seq_item =seq_item_class::type_id::create("seq_item");
         start_item(seq_item);
         seq_item.rd_en=1;
         seq_item.wr_en=1;
         seq_item.rst_n=1;
  seq_item.data_in=$random;
finish_item(seq_item);
    end
    endtask
endclass
    class sequence_class_random extends uvm_sequence #(seq_item_class);
`uvm_object_utils(sequence_class_random)
seq_item_class seq_item;
function new(string name= "sequence_class_random");
    super.new(name); 
    endfunction
    task body;
    repeat (1000)
    begin
        seq_item =seq_item_class::type_id::create("seq_item");
         start_item(seq_item);
        assert(seq_item.randomize());
finish_item(seq_item);
    end
    endtask
    endclass

    
endpackage