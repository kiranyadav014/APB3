module sync_fifo(clk,rst,read_en,write_en,data_in,data_out,fifo_full,fifo_empty);
	parameter WIDTH=8,
			  DEPTH=4,
			  WR_PTR_WR=8,
			  RD_PTR_RD=8;
	
	input clk,rst,write_en,read_en;
	input [WIDTH-1:0] data_in;
	output reg fifo_full,fifo_empty;
	output reg [WIDTH-1:0] data_out;
	
	reg[WIDTH-1:0]mem[DEPTH-1:0];
	reg[WR_PTR_WR-1:0] wr_ptr;
	reg[RD_PTR_RD-1:0] rd_ptr;
	
	always@(posedge clk)
	  begin
		if(rst)
		  begin
		    fifo_empty<=1;
			fifo_full<=0;
			data_out<=0;
			wr_ptr<=0;
			rd_ptr<=0;
			
			for(int i=0;i<DEPTH;i=i+1)
				mem[i]<=0;
		  end
		
		else if(write_en && !fifo_full)
		  begin
			mem[wr_ptr]<=data_in;
			fifo_empty<=0;
			fifo_full<=(wr_ptr-rd_ptr == DEPTH-1)?1:0;
			wr_ptr<wr_ptr+1;
		  end
		
		else if(read_en && !fifo_empty)
		  begin
		     data_out<=mem[rd_ptr];
			 fifo_full<=0;
			 fifo_empty<=(rd_ptr == wr_ptr-1)?1:0;
			 rd_ptr<=rd_ptr+1;
		  end
	  end

	// Assertions
	
	// Property: FIFO cannot be both full and empty
	property fifo_not_full_and_empty;
		@(posedge clk) disable iff (rst)
		!(fifo_full && fifo_empty);
	endproperty
	assert_fifo_not_full_and_empty: assert property (fifo_not_full_and_empty)
		else $error("FIFO RTL: FIFO is both full and empty");
	
	// Property: Write pointer should not exceed DEPTH
	property wr_ptr_bounds;
		@(posedge clk) disable iff (rst)
		wr_ptr < DEPTH;
	endproperty
	assert_wr_ptr_bounds: assert property (wr_ptr_bounds)
		else $error("FIFO RTL: Write pointer out of bounds");
	
	// Property: Read pointer should not exceed DEPTH
	property rd_ptr_bounds;
		@(posedge clk) disable iff (rst)
		rd_ptr < DEPTH;
	endproperty
	assert_rd_ptr_bounds: assert property (rd_ptr_bounds)
		else $error("FIFO RTL: Read pointer out of bounds");
	
	// Property: Reset sets pointers to 0
	property reset_ptrs;
		@(posedge clk)
		rst |=> (wr_ptr == 0 && rd_ptr == 0);
	endproperty
	assert_reset_ptrs: assert property (reset_ptrs)
		else $error("FIFO RTL: Reset did not clear pointers");
	
	// Property: Reset sets flags correctly
	property reset_flags;
		@(posedge clk)
		rst |=> (fifo_empty && !fifo_full);
	endproperty
	assert_reset_flags: assert property (reset_flags)
		else $error("FIFO RTL: Reset did not set flags correctly");
	
	// Property: Write operation increments write pointer
	property write_incr_wr_ptr;
		@(posedge clk) disable iff (rst)
		(write_en && !fifo_full) |=> (wr_ptr == $past(wr_ptr) + 1);
	endproperty
	assert_write_incr_wr_ptr: assert property (write_incr_wr_ptr)
		else $error("FIFO RTL: Write did not increment write pointer");
	
	// Property: Read operation increments read pointer
	property read_incr_rd_ptr;
		@(posedge clk) disable iff (rst)
		(read_en && !fifo_empty) |=> (rd_ptr == $past(rd_ptr) + 1);
	endproperty
	assert_read_incr_rd_ptr: assert property (read_incr_rd_ptr)
		else $error("FIFO RTL: Read did not increment read pointer");
	
endmodule