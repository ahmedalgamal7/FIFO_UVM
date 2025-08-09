package fifo_driver_pack;
import fifo_config_pack::*;
import sequence_item_pack::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_driver extends uvm_driver#(seq_item_class);
`uvm_component_utils(fifo_driver)
virtual fifo_if fifo_vif;
seq_item_class stim_seq_item;

    function new(string name="fifo_driver",uvm_component parent=null);
    super.new(name,parent);
    endfunction //new()
  
     task run_phase(uvm_phase phase);
     super.run_phase(phase) ;
     forever begin
        stim_seq_item=seq_item_class::type_id::create("stim_seq_item");
        seq_item_port.get_next_item(stim_seq_item);
     fifo_vif.rst_n=stim_seq_item.rst_n; fifo_vif.wr_en=stim_seq_item.wr_en; fifo_vif.rd_en= stim_seq_item.rd_en;
      fifo_vif.data_in=stim_seq_item.data_in; 
     @ (negedge fifo_vif.clk);
     seq_item_port.item_done();
     `uvm_info("run_phase",stim_seq_item.convert2string_stim(),UVM_HIGH)
     end
     endtask

endclass //fifo_driver extends uvm_driver
    
endpackage