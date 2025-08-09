package fifo_env_pack;
import uvm_pkg::*;
import coverage_collector_pack::*;
import scoreboard_pack::*;
import agent_pack::*;
`include "uvm_macros.svh"
class fifo_env extends uvm_env;
`uvm_component_utils(fifo_env)
agent_class agt;
scoreboard_class sb;
fifo_coverage_class cov;
    function new(string name="fifo_env",uvm_component parent = null);
    super.new(name,parent);
    endfunction //new()
    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt=agent_class::type_id::create("agt",this);
    sb=scoreboard_class::type_id::create("sb",this);
    cov=fifo_coverage_class::type_id::create("cov",this);
    endfunction
    function void connect_phase(uvm_phase phase);
    agt.agt_ap.connect(sb.sb_export);
    agt.agt_ap.connect(cov.cov_export);       
    endfunction
endclass //fifo_env extends superClass
    
endpackage