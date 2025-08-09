package agent_pack;
import sequencer_pack::*;
import fifo_driver_pack::*;
import fifo_monitor::*;
import fifo_config_pack::*;
import sequence_item_pack::*;
import uvm_pkg::*;

`include "uvm_macros.svh"
class agent_class extends uvm_agent;
`uvm_component_utils(agent_class);
sequencer_class sqr;
fifo_driver driv;
fifo_monitor mon;
fifo_config cfg;
uvm_analysis_port #(seq_item_class) agt_ap;
    function new (string name= "agent_class",uvm_component parent =null);
super.new(name,parent);
endfunction
 function void build_phase(uvm_phase phase);
    super.build_phase(phase);
         if (!uvm_config_db #(fifo_config)::get(this,"","KEY",cfg))
    `uvm_fatal("build_phase","yallahwayyyyyyyy");
     sqr=sequencer_class::type_id::create("sqr",this);
     driv=fifo_driver::type_id::create("driv",this);
     mon=fifo_monitor::type_id::create("mon",this);
     agt_ap=new("agt_ap",this);
     endfunction
     function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
     driv.fifo_vif=cfg.fifo_vif;
     mon.fifo_vif=cfg.fifo_vif;
    driv.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(agt_ap);
    endfunction
    

endclass //agent_class extends superClass

    
endpackage