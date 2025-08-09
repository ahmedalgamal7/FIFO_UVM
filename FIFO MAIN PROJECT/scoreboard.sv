package scoreboard_pack;
import uvm_pkg::*;
import sequence_item_pack::*;
`include "uvm_macros.svh"
class scoreboard_class extends uvm_scoreboard;
`uvm_component_utils(scoreboard_class)
uvm_analysis_export #(seq_item_class) sb_export;
uvm_tlm_analysis_fifo#(seq_item_class) sb_fifo;
seq_item_class seq_item_sb;

logic [16-1:0] data_out_ref;
int error=0;
logic [16-1:0] gold [$];
int correct=0;
function new(string name= "scoreboard_class",uvm_component parent =null);
    super.new(name,parent);
    endfunction //new()
     function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    sb_export= new("sb_export",this);
    sb_fifo=new("sb_fifo",this);
     endfunction
     function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     sb_export.connect(sb_fifo.analysis_export);        
     endfunction
     task  run_phase(uvm_phase phase);
     super.run_phase(phase);
     forever begin
        sb_fifo.get(seq_item_sb);
        ref_model(seq_item_sb);
        if (seq_item_sb.data_out!=data_out_ref ) begin
            `uvm_error("run_phase",$sformatf("comparison failed, DUT:%s while ref_out:%h",seq_item_sb.convert2string(),data_out_ref));
            error++;
        end
        else begin
            `uvm_info("run_phase",$sformatf("correct ",seq_item_sb.convert2string()),UVM_HIGH);
            correct++;

        end
     end
        
     endtask //

     task  ref_model(seq_item_class seq_item_chk);
     if (!seq_item_chk.rst_n)
gold.delete();
else if (seq_item_chk.rd_en &&seq_item_chk.wr_en &&gold.size()!=0 &&gold.size()!=8)
begin
  data_out_ref=gold.pop_front();
  gold.push_back(seq_item_chk.data_in);
end
else if (seq_item_chk.rd_en &&seq_item_chk.wr_en &&gold.size()==0)
gold.push_back(seq_item_chk.data_in);
else if(seq_item_chk.rd_en &&seq_item_chk.wr_en &&gold.size()==8)
data_out_ref=gold.pop_front();
else if (seq_item_chk.rd_en && gold.size()!=0)
data_out_ref=gold.pop_front();
else if ( gold.size()<8 &&seq_item_chk.wr_en)
gold.push_back(seq_item_chk.data_in);
        
     endtask //
     function void report_phase(uvm_phase phase);
     super.report_phase(phase);
     `uvm_info("report_phase",$sformatf("TOTAL SUCCESSFUL TRANSACTIONS:%d",correct),UVM_MEDIUM);
     `uvm_info("report_phase",$sformatf("TOTAL FAILED TRANSACTIONS:%d",error),UVM_MEDIUM);
        
     endfunction
endclass   
endpackage