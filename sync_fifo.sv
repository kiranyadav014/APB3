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
endmodule