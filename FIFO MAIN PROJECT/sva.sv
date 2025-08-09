module sva (fifo_if.dut fifo_interface);
property full_property;
@(posedge fifo_interface.clk) FIFO.count==fifo_interface.FIFO_DEPTH 
|-> fifo_interface.full==1;
endproperty
property empty_property;
@(posedge fifo_interface.clk) FIFO.count==0
 |-> fifo_interface.empty==1;
endproperty
property almostempty_property;
@(posedge fifo_interface.clk) FIFO.count==1 
|-> fifo_interface.almostempty==1;
endproperty
property almostfull_property;
@(posedge fifo_interface.clk) FIFO.count==fifo_interface.FIFO_DEPTH-1 
|-> fifo_interface.almostfull==1;
endproperty
property underflow_property;
@(posedge fifo_interface.clk) fifo_interface.empty && fifo_interface.rd_en 

 &&(fifo_interface.rst_n) |=>fifo_interface.underflow==1;
endproperty
property overflow_property;
@(posedge fifo_interface.clk) fifo_interface.wr_en && fifo_interface.full 
&&(fifo_interface.rst_n)|=> (fifo_interface.rst_n) |-> fifo_interface.overflow==1;
endproperty
property wr_ack_property;
@(posedge fifo_interface.clk) (fifo_interface.wr_en && fifo_interface.full==0)&&(fifo_interface.rst_n) |=> (fifo_interface.rst_n)|->fifo_interface.wr_ack==1;
endproperty
property wr_pointer;
@(posedge fifo_interface.clk) disable iff(!(fifo_interface.rst_n)) (fifo_interface.wr_en && FIFO.count < fifo_interface.FIFO_DEPTH) |=> (fifo_interface.rst_n)
|-> FIFO.wr_ptr==($past(FIFO.wr_ptr)+1)%8;
endproperty
property rd_pointer;
@(posedge fifo_interface.clk) disable iff(!(fifo_interface.rst_n)) fifo_interface.rd_en && FIFO.count != 0 |=> (fifo_interface.rst_n)
|-> FIFO.rd_ptr==($past(FIFO.rd_ptr)+1)%8;
endproperty

assert property (full_property);
cover property (full_property);
assert property (empty_property);
cover property (empty_property);
assert property (almostempty_property);
cover property (almostempty_property);
assert property (almostfull_property);
cover property (almostfull_property);
assert property (underflow_property);
cover property (underflow_property);
assert property (overflow_property);
cover property (overflow_property);
assert property (wr_ack_property);
cover property (wr_ack_property);
    
endmodule