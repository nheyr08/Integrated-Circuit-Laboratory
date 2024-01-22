

//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Si2 LAB @NYCU ED430
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab10            :     bridge.sv  
//   Author           :     Betsaleel Henry(henrybesaleelATgmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module bridge(input clk, INF.bridge_inf inf);
//================================================================
//  integer / genvar / parameter
//================================================================
//  MODE
parameter MODE_READ  = 1'b1, MODE_WRITE = 1'b0, IDLE      = 3'd0 , R_READDY  = 3'd1 , R_WEADDY  = 3'd2 , W_WEADDY  = 3'd3 , WS_WEADDY = 3'd4 , WR_OUT    = 3'd5 ;
logic [2:0] c_state, next_state;
logic [7:0] addr;
logic [63:0] VALUES;
//================================================================
//  FSM
//================================================================
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if (!inf.rst_n) 	c_state <= IDLE ;
	else 				c_state <= next_state ;
end
always_comb begin
	next_state = c_state ;
	case(c_state)
		IDLE: begin
			if (inf.C_in_valid==1) begin
				if (inf.C_r_wb==MODE_READ)	next_state = R_READDY ;
				else 						next_state = W_WEADDY ;
			end
		end
		R_READDY:  if (inf.AR_READY==1)	    next_state = R_WEADDY ;
		R_WEADDY:  if (inf.R_VALID==1)		next_state = WR_OUT ;
		W_WEADDY:  if (inf.AW_READY==1)	    next_state = WS_WEADDY ;
		WS_WEADDY: if (inf.B_VALID==1)		next_state = WR_OUT ;
		WR_OUT:            	                next_state = IDLE ;
	endcase 
end
//================================================================
//   AXI Lite Signals
//================================================================
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if(!inf.rst_n)	inf.B_READY <= 0 ;
	else 			inf.B_READY <= 1 ;
end	
// MODE_READ
assign inf.AR_VALID = (c_state==R_READDY) ;
assign inf.AR_ADDR  = (c_state==R_READDY) ? { 1'b1 , 5'b0 , addr , 3'b0 } : 0 ;	
assign inf.R_READY  = (c_state==R_WEADDY) ;
// MODE_WRITE
assign inf.AW_VALID = (c_state==W_WEADDY) ;
assign inf.AW_ADDR  = (c_state==W_WEADDY) ? { 1'b1 , 5'b0 , addr , 3'b0 } : 0 ;	
assign inf.W_DATA   = VALUES ;
assign inf.W_VALID  = (c_state==WS_WEADDY) ;
//================================================================
//   INPUT
//================================================================
always_ff @(posedge clk or  negedge inf.rst_n) begin
	if (!inf.rst_n) 	addr <= 0 ;
	else begin
		if (inf.C_in_valid==1)	addr <= inf.C_addr ;
	end
end
always_ff @(posedge clk or  negedge inf.rst_n) begin
	if (!inf.rst_n) 	VALUES <= 0 ;
	else begin
		if (inf.C_in_valid==1 && inf.C_r_wb==MODE_WRITE)	VALUES <= inf.C_data_w ;
	end
end
//================================================================
//   OUTPUT
//================================================================
always_ff @(posedge clk or negedge inf.rst_n) begin 
	if (!inf.rst_n) 	inf.C_out_valid <= 0 ;
	else begin
		if (next_state==WR_OUT)	inf.C_out_valid <= 1 ;
		else 							inf.C_out_valid <= 0 ;
	end
end
always_ff @(posedge clk or negedge inf.rst_n) begin
	if (!inf.rst_n) 	inf.C_data_r <= 0 ;
	else begin
		if (inf.R_VALID==1) 	inf.C_data_r <= inf.R_DATA ;
		else 					inf.C_data_r <= 0 ;
	end
end

endmodule