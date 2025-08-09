package sequence_item_pack;

import uvm_pkg::*;
`include "uvm_macros.svh"
class seq_item_class extends uvm_sequence_item;
`uvm_object_utils(seq_item_class)
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
integer RD_EN_ON_DIST=0,WR_EN_ON_DIST=0;


function new(string name= "seq_item_class");
    super.new(name);
    RD_EN_ON_DIST=30;
     WR_EN_ON_DIST=70;
    endfunction
    function string convert2string();
    return $sformatf ("%s reset =%b ,data in=%d ,write enable=%d , read enable=%d,data_out=%h ,wr_ack=%d,overflow=%d,full=%s,empty=%d ,almost full=%b,almost empty=%d,underflow=%h  ",
     super.convert2string(), rst_n,data_in,wr_en,rd_en, data_out,wr_ack,overflow,full,empty ,almostfull,almostempty,underflow ) ;
    endfunction

    function string convert2string_stim();
    return $sformatf ("%s reset =%b ,data in=%d ,write enable=%d , read enable=%d ",
     super.convert2string(), rst_n,data_in,wr_en,rd_en) ;
    endfunction
 

constraint trans {
rst_n dist {1:=99,0:=1};
wr_en dist {1:=WR_EN_ON_DIST,0:=100-WR_EN_ON_DIST};
rd_en dist {1:=RD_EN_ON_DIST,0:=100-RD_EN_ON_DIST};
}
endclass


    
endpackage

