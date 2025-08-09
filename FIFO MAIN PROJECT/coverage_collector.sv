package coverage_collector_pack;
import sequence_item_pack::*;

import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_coverage_class extends uvm_component;
`uvm_component_utils(fifo_coverage_class)
uvm_analysis_export #(seq_item_class) cov_export;
uvm_tlm_analysis_fifo #(seq_item_class) cov_fifo;
seq_item_class seq_item_cov;
covergroup g1;
        cv1: coverpoint seq_item_cov.wr_en;
        cv2: coverpoint seq_item_cov.rd_en;
        cv3: coverpoint seq_item_cov.overflow;
        cv4: coverpoint seq_item_cov.almostempty;
        cv5: coverpoint seq_item_cov.empty;
        cv6: coverpoint seq_item_cov.almostfull;
        cv7: coverpoint seq_item_cov.underflow;
        cv8: coverpoint seq_item_cov.full;
        cv9: coverpoint seq_item_cov.wr_ack;
        c1:cross cv1,cv2,cv8
        {
            ignore_bins read_full = binsof(cv2) intersect {1} && binsof(cv8) intersect {1};
        }
        c2: cross cv1,cv2,cv6;
        c3:cross cv1,cv2,cv5;
        c4:cross cv1,cv2,cv4;
        c5:cross cv1,cv2,cv3
        {
            ignore_bins wr_en_overflow = binsof(cv1) intersect{0} && binsof(cv3) intersect{1};
        }
        c6:cross cv1,cv2,cv7
        {
            ignore_bins read_underflow = binsof(cv2) intersect{0} && binsof(cv7) intersect{1};
        }
        c7:cross cv1,cv2,cv9
        {
            ignore_bins wr_en_ack = binsof(cv1) intersect{0} && binsof(cv9) intersect{1};
        }
endgroup
    function new(string name="fifo_coverage_class",uvm_component parent =null);
    super.new(name,parent);
    g1=new();
    endfunction //new()
    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export=new("cov_export",this);
    cov_fifo=new("cov_fifo",this);      
    endfunction
    function void connect_phase(uvm_phase phase);
     super.connect_phase(phase) ;
    cov_export.connect(cov_fifo.analysis_export);
     endfunction
     task  run_phase(uvm_phase phase);
     super.run_phase(phase);
     forever begin
        cov_fifo.get(seq_item_cov);
        g1.sample();
     end
        
     endtask //
endclass //fifo_coverage_class extends superClass
    
endpackage