module FIFO(fifo_if.dut fifo_interface);
localparam max_fifo_addr = $clog2(fifo_interface.FIFO_DEPTH);
reg [fifo_interface.FIFO_WIDTH-1:0] mem [fifo_interface.FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;
always @(posedge fifo_interface.clk or negedge fifo_interface.rst_n) begin /// always block in order to read
	if (!fifo_interface.rst_n) begin
		rd_ptr <= 0;
	end
	else if (fifo_interface.rd_en && count != 0) begin
		fifo_interface.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
    else begin
	 if (fifo_interface.empty && fifo_interface.rd_en ) begin
	fifo_interface.underflow<=1;                                     // edited as it was combinational and it must be sequential according to the specifications
	 end
	else fifo_interface.underflow<=0;
	end
end
always @(posedge fifo_interface.clk or negedge fifo_interface.rst_n) begin      /// always block in order to write
	if (!fifo_interface.rst_n) begin
		wr_ptr <= 0;
	end
	else if (fifo_interface.wr_en && count < fifo_interface.FIFO_DEPTH ) begin
		mem[wr_ptr] <= fifo_interface.data_in;
		fifo_interface.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	
	end
always @(posedge fifo_interface.clk or negedge fifo_interface.rst_n) begin
	if (!fifo_interface.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_interface.wr_en, fifo_interface.rd_en} == 2'b10) && !fifo_interface.full) 
			count <= count + 1;
		else if ( ({fifo_interface.wr_en, fifo_interface.rd_en} == 2'b01) && !fifo_interface.empty)
			count <= count - 1;
			else if (({fifo_interface.wr_en, fifo_interface.rd_en} == 2'b11)  && fifo_interface.empty) /// was missing to react on wr_en and rd_en are high together and the fifo is empty to write only
			count <= count + 1;
			else if (({fifo_interface.wr_en, fifo_interface.rd_en} == 2'b11)  && fifo_interface.full)   /// was missing to react on wr_en and rd_en are high together and the fifo is full to read only
			count <= count - 1;
	end
end

always @(posedge fifo_interface.clk or negedge fifo_interface.rst_n) begin /// always block for overflow and wr_ack flags
	if (!fifo_interface.rst_n) begin
		fifo_interface.overflow <= 0;                             // added inorder to the flag down
        fifo_interface.wr_ack<=0;
		fifo_interface.underflow<=0;                                 // added inorder to the flag down
	end
	else if (fifo_interface.wr_en && count==8 ) begin
		fifo_interface.wr_ack<=0;
		fifo_interface.overflow<=1;
	end
else if (fifo_interface.wr_en && !fifo_interface.full) begin
        fifo_interface.overflow<=0;
        fifo_interface.wr_ack<=1;
end
        else begin
        fifo_interface.overflow<=0;
fifo_interface.wr_ack<=0;
		end
end
assign fifo_interface.full = (count == fifo_interface.FIFO_DEPTH)? 1 : 0;
assign fifo_interface.empty = (count == 0)? 1 : 0;
assign fifo_interface.almostfull = (count == fifo_interface.FIFO_DEPTH-1)? 1 : 0; 
assign fifo_interface.almostempty = (count == 1)? 1 : 0;


endmodule