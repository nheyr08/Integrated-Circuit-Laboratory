//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Si2 LAB @NYCU ED430
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Midterm Proejct            : MRA  
//   Author                     : Lin-Hung, Lai
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : MRA.v
//   Module Name : MRA
//   Release version : V2.0 (Release Date: 2023-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module MRA(
	clk            	,	
	rst_n          	,	
	in_valid       	,	
	frame_id        ,	
	net_id         	,	  
	loc_x          	,	  
    loc_y         	,
	cost	 		,		
	busy         	,

	     arid_m_inf,
	   araddr_m_inf,
	    arlen_m_inf,
	   arsize_m_inf,
	  arburst_m_inf,
	  arvalid_m_inf,
	  arready_m_inf,

	      rid_m_inf,
	    rdata_m_inf,
	    rresp_m_inf,
	    rlast_m_inf,
	   rvalid_m_inf,
	   rready_m_inf,

	     awid_m_inf,
	   awaddr_m_inf,
	   awsize_m_inf,
	  awburst_m_inf,
	    awlen_m_inf,
	  awvalid_m_inf,
	  awready_m_inf,

	    wdata_m_inf,
	    wlast_m_inf,
	   wvalid_m_inf,
	   wready_m_inf,

	      bid_m_inf,
	    bresp_m_inf,
	   bvalid_m_inf,
	   bready_m_inf 
);

input 			  	clk,rst_n;
input 			   	in_valid;
input  [4:0] 		frame_id;
input  [3:0]       	net_id;     
input  [5:0]       	loc_x; 
input  [5:0]       	loc_y; 
output reg [13:0] 	cost;
output reg          busy;       

parameter ID_WIDTH = 4, DATA_WIDTH = 128, AddrWIDTH = 32;

output wire [ID_WIDTH-1:0]      arid_m_inf;
output wire [1:0]            arburst_m_inf;
output wire [2:0]             arsize_m_inf;
output wire [7:0]              arlen_m_inf;

output reg                  arvalid_m_inf;
input  wire                  arready_m_inf;

output reg [AddrWIDTH-1:0]  araddr_m_inf;

input  wire [ID_WIDTH-1:0]       rid_m_inf;
input  wire                   rvalid_m_inf;

output reg                   rready_m_inf;
input  wire [DATA_WIDTH-1:0]   rdata_m_inf;
input  wire                    rlast_m_inf;
input  wire [1:0]              rresp_m_inf;

output wire [ID_WIDTH-1:0]      awid_m_inf;
output wire [1:0]            awburst_m_inf;
output wire [2:0]             awsize_m_inf;
output wire [7:0]              awlen_m_inf;

output reg                  awvalid_m_inf;
input  wire                  awready_m_inf;

output reg [AddrWIDTH-1:0]  awaddr_m_inf;

output reg                   wvalid_m_inf;
input  wire                   wready_m_inf;

output reg [DATA_WIDTH-1:0]   wdata_m_inf;

output reg                    wlast_m_inf;

input  wire  [ID_WIDTH-1:0]      bid_m_inf;
input  wire                   bvalid_m_inf;

output reg                   bready_m_inf;
input  wire  [1:0]             bresp_m_inf;

parameter IDLE =0;
parameter FETCH_D =1;
parameter WRITE_S =2;
parameter WRITE_D =3;
parameter FIN_D =4;
parameter END_S =5;
parameter PLT =1;
parameter LEE =2;
parameter RETRACT =3;
reg [3:0] input_cnt;
reg [3:0] lood;
reg [3:0] net_id_save [0:14];
reg [5:0] start_x [0:14];
reg [5:0] start_y [0:14];
reg [5:0] end_x [0:14];
reg [2:0] c_state, n_state;
reg [3:0] c_state_, n_state_;
reg pouble;
reg [4:0] frame_id_save;
wire [3:0] lood_1;
reg [5:0] RETRACT_x_next, RETRACT_y_next;
reg [6:0] ctr_t;
reg RETRACT_path;
reg [1:0] LEE_cnt;
reg [127:0] temp_write;
integer ii, jj;
reg [6:0] val_tx;
reg S_INPUT;
reg [3:0] Cr_W;
wire [6:0] RETRACT_addr;
reg [127:0] RETRACT_di;
reg [5:0] end_y [0:14];
reg [1:0] LEE_map_current [0:63][0:63];  
reg [1:0] LEE_map_next [0:63][0:63];  
reg [5:0] RETRACT_x, RETRACT_y;
wire RETRACT_done;
wire [3:0] net_id_now;
wire LEE_end;
reg [6:0] AddrL, AddrW;
wire [127:0] L_in, W_in;
wire [127:0] Loc_val, W_val;
reg _Wel, _Wew;
reg begin_;
integer ctr_i;
genvar idx,jdx;
wire [5:0] sourcex_, sourcey_, destx_, desty_;
wire FETCH_D_flag = (c_state_ == FETCH_D);
wire WRITE_S_flag = (c_state_ == WRITE_S);
wire WRITE_D_flag = (c_state_ == WRITE_D);
wire FIN_D_flag = (c_state_ == FIN_D);
wire CS_PLT = (c_state == PLT);
wire CS_LEE = (c_state == LEE);
wire CS_RETRACT = (c_state == RETRACT);
wire END_S_flag = (c_state_ == END_S);
assign net_id_now = net_id_save[0];
assign sourcex_ = start_x[0];
assign sourcey_ = start_y[0];
assign destx_ = end_x[0];
assign desty_ = end_y[0];
assign LEE_end = LEE_map_next[desty_][destx_][1];
assign RETRACT_done = (RETRACT_y == sourcey_ && RETRACT_x == sourcex_);
assign AddrL = CS_RETRACT ? RETRACT_addr : (wready_m_inf) ? val_tx : ctr_t;
assign L_in = S_INPUT ? RETRACT_di : rdata_m_inf;
assign AddrW = CS_RETRACT ? RETRACT_addr : ctr_t;
assign W_in = (!pouble) ? rdata_m_inf : 0;
assign RETRACT_addr = {RETRACT_y, RETRACT_x[5]};
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>TA defined<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
assign arid_m_inf    = 4'd0;
assign arburst_m_inf = 2'b01;
assign arsize_m_inf  = 3'b100;
assign arlen_m_inf   = 8'd127;
assign awid_m_inf    = 4'd0;
assign awburst_m_inf = 2'b01;
assign awsize_m_inf  = 3'b100;
assign awlen_m_inf   = 8'd127;
assign lood_1        = lood + 'd1;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM1<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
always @(*) begin
	case(c_state_)
		IDLE: begin
			if(in_valid) begin
				n_state_ = FETCH_D;
			end
			else if(RETRACT_done && S_INPUT && lood == input_cnt - 1) begin
				n_state_ = WRITE_D;
			end
			else begin
				n_state_ = c_state_;
			end
		end
		FETCH_D: begin
			if(arready_m_inf) begin
				n_state_ = WRITE_S;
			end
			else begin
				n_state_ = c_state_;
			end
		end
		WRITE_S: begin
			if(rlast_m_inf) begin
				if (pouble) begin
					n_state_ = FETCH_D;
				end
				else begin
					n_state_ = IDLE;
				end
			end
			else begin
				n_state_ = c_state_;
			end
		end
		WRITE_D: begin
			if(awready_m_inf)  begin
				n_state_ = FIN_D;
			end
			else begin
				n_state_ = c_state_;
			end
		end
		FIN_D: begin
			if(wlast_m_inf && wready_m_inf)  begin
				n_state_ = END_S;
			end
			else begin
				n_state_ = c_state_;
			end
		end
		END_S: begin
			if(bvalid_m_inf)  begin
				n_state_ = IDLE;
			end
			else begin
				n_state_ = c_state_;
			end
		end
		default: begin
			n_state_ = c_state_;
		end
	endcase
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		c_state <= IDLE;
	end
	else begin
		c_state <= n_state;
	end
end
always @(*) begin
	case(c_state)
		IDLE: begin
			if(rlast_m_inf && pouble) begin
				n_state = PLT;
			end
			else if (c_state_ == WRITE_S && n_state_ == IDLE) begin
				n_state = RETRACT;
			end
			else begin
				n_state = c_state;
			end
		end
		PLT: begin
			n_state = LEE;
		end
		LEE: begin
			if(LEE_end) begin
				if (n_state_ == WRITE_S) begin
					n_state = IDLE;
				end
				else begin
					n_state = RETRACT;
				end
			end
			else begin
				n_state = c_state;
			end
		end
		RETRACT: begin
			if(S_INPUT&&RETRACT_done) begin
				if(lood != input_cnt - 1) begin //check
					n_state = PLT;
				end
				else begin
					n_state = IDLE;
				end
			end
			else begin
				n_state = c_state;
			end
		end
		default: begin
			n_state = c_state;
		end
	endcase
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		c_state_ <= IDLE;
	end else begin
		c_state_ <= n_state_;
	end
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		pouble <= 1;
	end else if (rlast_m_inf) begin
		pouble <= ~pouble;
	end
end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SRAM driver<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Lele LOC_MAP(.A0(AddrL[0]),.A1(AddrL[1]),.A2(AddrL[2]),.A3(AddrL[3]),.A4(AddrL[4]),.A5(AddrL[5]),.A6(AddrL[6]),
				.DO0(Loc_val[0]),.DO1(Loc_val[1]),.DO2(Loc_val[2]),.DO3(Loc_val[3]),.DO4(Loc_val[4]),.DO5(Loc_val[5]),.DO6(Loc_val[6]),.DO23(Loc_val[23]),
				.DO7(Loc_val[7]),.DO8(Loc_val[8]),.DO9(Loc_val[9]),.DO10(Loc_val[10]),.DO11(Loc_val[11]),.DO12(Loc_val[12]),.DO13(Loc_val[13]),.DO22(Loc_val[22]),
				.DO14(Loc_val[14]),.DO15(Loc_val[15]),.DO16(Loc_val[16]),.DO17(Loc_val[17]),.DO18(Loc_val[18]),.DO19(Loc_val[19]),.DO20(Loc_val[20]),.DO21(Loc_val[21]),
				.DO24(Loc_val[24]),.DO25(Loc_val[25]),.DO26(Loc_val[26]),.DO27(Loc_val[27]),.DO28(Loc_val[28]),.DO29(Loc_val[29]),.DO30(Loc_val[30]),.DO31(Loc_val[31]),
				.DO32(Loc_val[32]),.DO33(Loc_val[33]),.DO34(Loc_val[34]),.DO35(Loc_val[35]),.DO36(Loc_val[36]),.DO37(Loc_val[37]),.DO38(Loc_val[38]),.DO39(Loc_val[39]),
				.DO40(Loc_val[40]),.DO41(Loc_val[41]),.DO42(Loc_val[42]),.DO43(Loc_val[43]),.DO44(Loc_val[44]),.DO45(Loc_val[45]),.DO46(Loc_val[46]),.DO47(Loc_val[47]),
				.DO48(Loc_val[48]),.DO49(Loc_val[49]),.DO50(Loc_val[50]),.DO51(Loc_val[51]),.DO52(Loc_val[52]),.DO53(Loc_val[53]),.DO54(Loc_val[54]),.DO55(Loc_val[55]),
				.DO56(Loc_val[56]),.DO57(Loc_val[57]),.DO58(Loc_val[58]),.DO59(Loc_val[59]),.DO60(Loc_val[60]),.DO61(Loc_val[61]),.DO62(Loc_val[62]),.DO63(Loc_val[63]),
				.DO64(Loc_val[64]),.DO65(Loc_val[65]),.DO66(Loc_val[66]),.DO67(Loc_val[67]),.DO68(Loc_val[68]),.DO69(Loc_val[69]),.DO70(Loc_val[70]),.DO71(Loc_val[71]),
				.DO72(Loc_val[72]),.DO73(Loc_val[73]),.DO74(Loc_val[74]),.DO75(Loc_val[75]),.DO76(Loc_val[76]),.DO77(Loc_val[77]),.DO78(Loc_val[78]),.DO79(Loc_val[79]),
				.DO80(Loc_val[80]),.DO81(Loc_val[81]),.DO82(Loc_val[82]),.DO83(Loc_val[83]),.DO84(Loc_val[84]),.DO85(Loc_val[85]),.DO86(Loc_val[86]),.DO87(Loc_val[87]),
				.DO88(Loc_val[88]),.DO89(Loc_val[89]),.DO90(Loc_val[90]),.DO91(Loc_val[91]),.DO92(Loc_val[92]),.DO93(Loc_val[93]),.DO94(Loc_val[94]),.DO95(Loc_val[95]),
				.DO96(Loc_val[96]),.DO97(Loc_val[97]),.DO98(Loc_val[98]),.DO99(Loc_val[99]),.DO100(Loc_val[100]),.DO101(Loc_val[101]),.DO102(Loc_val[102]),.DO103(Loc_val[103]),
				.DO104(Loc_val[104]),.DO105(Loc_val[105]),.DO106(Loc_val[106]),.DO107(Loc_val[107]),.DO108(Loc_val[108]),.DO109(Loc_val[109]),.DO110(Loc_val[110]),
				.DO111(Loc_val[111]),.DO112(Loc_val[112]),.DO113(Loc_val[113]),.DO114(Loc_val[114]),.DO115(Loc_val[115]),.DO116(Loc_val[116]),.DO117(Loc_val[117]),
				.DO118(Loc_val[118]),.DO119(Loc_val[119]),.DO120(Loc_val[120]),.DO121(Loc_val[121]),.DO122(Loc_val[122]),.DO123(Loc_val[123]),.DO124(Loc_val[124]),
				.DO125(Loc_val[125]),.DO126(Loc_val[126]),.DO127(Loc_val[127]),.DI0(L_in[0]),.DI1(L_in[1]),.DI2(L_in[2]),.DI3(L_in[3]),.DI4(L_in[4]),
				.DI5(L_in[5]),.DI6(L_in[6]),.DI7(L_in[7]),.DI8(L_in[8]),.DI9(L_in[9]),.DI10(L_in[10]),.DI11(L_in[11]),.DI12(L_in[12]),.DI13(L_in[13]),.DI14(L_in[14]),
				.DI15(L_in[15]),.DI16(L_in[16]),.DI17(L_in[17]),.DI18(L_in[18]),.DI19(L_in[19]),.DI20(L_in[20]),.DI21(L_in[21]),.DI22(L_in[22]),
				.DI23(L_in[23]),.DI24(L_in[24]),.DI25(L_in[25]),.DI26(L_in[26]),.DI27(L_in[27]),.DI28(L_in[28]),.DI29(L_in[29]),.DI30(L_in[30]),
				.DI31(L_in[31]),.DI32(L_in[32]),.DI33(L_in[33]),.DI34(L_in[34]),.DI35(L_in[35]),.DI36(L_in[36]),.DI37(L_in[37]),.DI38(L_in[38]),
				.DI39(L_in[39]),.DI40(L_in[40]),.DI41(L_in[41]),.DI42(L_in[42]),.DI43(L_in[43]),.DI44(L_in[44]),.DI45(L_in[45]),.DI46(L_in[46]),
				.DI47(L_in[47]),.DI48(L_in[48]),.DI49(L_in[49]),.DI50(L_in[50]),.DI51(L_in[51]),.DI52(L_in[52]),.DI53(L_in[53]),.DI54(L_in[54]),
				.DI55(L_in[55]),.DI56(L_in[56]),.DI57(L_in[57]),.DI58(L_in[58]),.DI59(L_in[59]),.DI60(L_in[60]),.DI61(L_in[61]),.DI62(L_in[62]),
				.DI63(L_in[63]),.DI64(L_in[64]),.DI65(L_in[65]),.DI66(L_in[66]),.DI67(L_in[67]),.DI68(L_in[68]),.DI69(L_in[69]),.DI70(L_in[70]),
				.DI71(L_in[71]),.DI72(L_in[72]),.DI73(L_in[73]),.DI74(L_in[74]),.DI75(L_in[75]),.DI76(L_in[76]),.DI77(L_in[77]),.DI78(L_in[78]),
				.DI79(L_in[79]),.DI80(L_in[80]),.DI81(L_in[81]),.DI82(L_in[82]),.DI83(L_in[83]),.DI84(L_in[84]),.DI85(L_in[85]),.DI86(L_in[86]),
				.DI87(L_in[87]),.DI88(L_in[88]),.DI89(L_in[89]),.DI90(L_in[90]),.DI91(L_in[91]),.DI92(L_in[92]),.DI93(L_in[93]),.DI94(L_in[94]),
				.DI95(L_in[95]),.DI96(L_in[96]),.DI97(L_in[97]),.DI98(L_in[98]),.DI99(L_in[99]),.DI100(L_in[100]),.DI101(L_in[101]),.DI102(L_in[102]),
				.DI103(L_in[103]),.DI104(L_in[104]),.DI105(L_in[105]),.DI106(L_in[106]),.DI107(L_in[107]),.DI108(L_in[108]),.DI109(L_in[109]),
				.DI110(L_in[110]),.DI111(L_in[111]),.DI112(L_in[112]),.DI113(L_in[113]),.DI114(L_in[114]),.DI115(L_in[115]),.DI116(L_in[116]),
				.DI117(L_in[117]),.DI118(L_in[118]),.DI119(L_in[119]),.DI120(L_in[120]),.DI121(L_in[121]),.DI122(L_in[122]),.DI123(L_in[123]),
				.DI124(L_in[124]),.DI125(L_in[125]),.DI126(L_in[126]),.DI127(L_in[127]),
				.CK(clk),.WEB(_Wel),.OE(1'b1),.CS(1'b1));
Lele W_MAP(.A0(AddrW[0]),.A1(AddrW[1]),.A2(AddrW[2]),.A3(AddrW[3]),.A4(AddrW[4]),.A5(AddrW[5]),.A6(AddrW[6]),.DI14(W_in[14]),
				.DO0(W_val[0]),.DO1(W_val[1]),.DO2(W_val[2]),.DO3(W_val[3]),.DO4(W_val[4]),.DO5(W_val[5]),.DO6(W_val[6]),.DO15(W_val[15]),
				.DO7(W_val[7]),.DO8(W_val[8]),.DO9(W_val[9]),.DO10(W_val[10]),.DO11(W_val[11]),.DO12(W_val[12]),.DO13(W_val[13]),.DO14(W_val[14]),
				.DO16(W_val[16]),.DO17(W_val[17]),.DO18(W_val[18]),.DO19(W_val[19]),.DO20(W_val[20]),.DO21(W_val[21]),.DO22(W_val[22]),.DO23(W_val[23]),
				.DO24(W_val[24]),.DO25(W_val[25]),.DO26(W_val[26]),.DO27(W_val[27]),.DO28(W_val[28]),.DO29(W_val[29]),.DO30(W_val[30]),.DO31(W_val[31]),
				.DO32(W_val[32]),.DO33(W_val[33]),.DO34(W_val[34]),.DO35(W_val[35]),.DO36(W_val[36]),.DO37(W_val[37]),.DO38(W_val[38]),.DO39(W_val[39]),
				.DO40(W_val[40]),.DO41(W_val[41]),.DO42(W_val[42]),.DO43(W_val[43]),.DO44(W_val[44]),.DO45(W_val[45]),.DO46(W_val[46]),.DO47(W_val[47]),
				.DO48(W_val[48]),.DO49(W_val[49]),.DO50(W_val[50]),.DO51(W_val[51]),.DO52(W_val[52]),.DO53(W_val[53]),.DO54(W_val[54]),.DO55(W_val[55]),
				.DO56(W_val[56]),.DO57(W_val[57]),.DO58(W_val[58]),.DO59(W_val[59]),.DO60(W_val[60]),.DO61(W_val[61]),.DO62(W_val[62]),.DO63(W_val[63]),
				.DO64(W_val[64]),.DO65(W_val[65]),.DO66(W_val[66]),.DO67(W_val[67]),.DO68(W_val[68]),.DO69(W_val[69]),.DO70(W_val[70]),.DO71(W_val[71]),
				.DO72(W_val[72]),.DO73(W_val[73]),.DO74(W_val[74]),.DO75(W_val[75]),.DO76(W_val[76]),.DO77(W_val[77]),.DO78(W_val[78]),.DO79(W_val[79]),
				.DO80(W_val[80]),.DO81(W_val[81]),.DO82(W_val[82]),.DO83(W_val[83]),.DO84(W_val[84]),.DO85(W_val[85]),.DO86(W_val[86]),.DO87(W_val[87]),
				.DO88(W_val[88]),.DO89(W_val[89]),.DO90(W_val[90]),.DO91(W_val[91]),.DO92(W_val[92]),.DO93(W_val[93]),.DO94(W_val[94]),.DO95(W_val[95]),
				.DO96(W_val[96]),.DO97(W_val[97]),.DO98(W_val[98]),.DO99(W_val[99]),.DO100(W_val[100]),.DO101(W_val[101]),.DO102(W_val[102]),.DO103(W_val[103]),
				.DO104(W_val[104]),.DO105(W_val[105]),.DO106(W_val[106]),.DO107(W_val[107]),.DO108(W_val[108]),.DO109(W_val[109]),.DO110(W_val[110]),
				.DO111(W_val[111]),.DO112(W_val[112]),.DO113(W_val[113]),.DO114(W_val[114]),.DO115(W_val[115]),.DO116(W_val[116]),.DO117(W_val[117]),
				.DO118(W_val[118]),.DO119(W_val[119]),.DO120(W_val[120]),.DO121(W_val[121]),.DO122(W_val[122]),.DO123(W_val[123]),.DO124(W_val[124]),
				.DO125(W_val[125]),.DO126(W_val[126]),.DO127(W_val[127]),.DI0(W_in[0]),.DI1(W_in[1]),.DI2(W_in[2]),.DI3(W_in[3]),.DI4(W_in[4]),
				.DI5(W_in[5]),.DI6(W_in[6]),.DI7(W_in[7]),.DI8(W_in[8]),.DI9(W_in[9]),.DI10(W_in[10]),.DI11(W_in[11]),.DI12(W_in[12]),.DI13(W_in[13]),
				.DI15(W_in[15]),.DI16(W_in[16]),.DI17(W_in[17]),.DI18(W_in[18]),.DI19(W_in[19]),.DI20(W_in[20]),.DI21(W_in[21]),.DI22(W_in[22]),
				.DI23(W_in[23]),.DI24(W_in[24]),.DI25(W_in[25]),.DI26(W_in[26]),.DI27(W_in[27]),.DI28(W_in[28]),.DI29(W_in[29]),.DI30(W_in[30]),
				.DI31(W_in[31]),.DI32(W_in[32]),.DI33(W_in[33]),.DI34(W_in[34]),.DI35(W_in[35]),.DI36(W_in[36]),.DI37(W_in[37]),.DI38(W_in[38]),
				.DI39(W_in[39]),.DI40(W_in[40]),.DI41(W_in[41]),.DI42(W_in[42]),.DI43(W_in[43]),.DI44(W_in[44]),.DI45(W_in[45]),.DI46(W_in[46]),
				.DI47(W_in[47]),.DI48(W_in[48]),.DI49(W_in[49]),.DI50(W_in[50]),.DI51(W_in[51]),.DI52(W_in[52]),.DI53(W_in[53]),.DI54(W_in[54]),
				.DI55(W_in[55]),.DI56(W_in[56]),.DI57(W_in[57]),.DI58(W_in[58]),.DI59(W_in[59]),.DI60(W_in[60]),.DI61(W_in[61]),.DI62(W_in[62]),
				.DI63(W_in[63]),.DI64(W_in[64]),.DI65(W_in[65]),.DI66(W_in[66]),.DI67(W_in[67]),.DI68(W_in[68]),.DI69(W_in[69]),.DI70(W_in[70]),
				.DI71(W_in[71]),.DI72(W_in[72]),.DI73(W_in[73]),.DI74(W_in[74]),.DI75(W_in[75]),.DI76(W_in[76]),.DI77(W_in[77]),.DI78(W_in[78]),
				.DI79(W_in[79]),.DI80(W_in[80]),.DI81(W_in[81]),.DI82(W_in[82]),.DI83(W_in[83]),.DI84(W_in[84]),.DI85(W_in[85]),.DI86(W_in[86]),
				.DI87(W_in[87]),.DI88(W_in[88]),.DI89(W_in[89]),.DI90(W_in[90]),.DI91(W_in[91]),.DI92(W_in[92]),.DI93(W_in[93]),.DI94(W_in[94]),
				.DI95(W_in[95]),.DI96(W_in[96]),.DI97(W_in[97]),.DI98(W_in[98]),.DI99(W_in[99]),.DI100(W_in[100]),.DI101(W_in[101]),.DI102(W_in[102]),
				.DI103(W_in[103]),.DI104(W_in[104]),.DI105(W_in[105]),.DI106(W_in[106]),.DI107(W_in[107]),.DI108(W_in[108]),.DI109(W_in[109]),
				.DI110(W_in[110]),.DI111(W_in[111]),.DI112(W_in[112]),.DI113(W_in[113]),.DI114(W_in[114]),.DI115(W_in[115]),.DI116(W_in[116]),
				.DI117(W_in[117]),.DI118(W_in[118]),.DI119(W_in[119]),.DI120(W_in[120]),.DI121(W_in[121]),.DI122(W_in[122]),.DI123(W_in[123]),
				.DI124(W_in[124]),.DI125(W_in[125]),.DI126(W_in[126]),.DI127(W_in[127]),
				.CK(clk),.WEB(_Wew),.OE(1'b1),.CS(1'b1));
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>DRAM drivers<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        // assign arid_m_inf    = 4'd0; 			// fixed id to  0 
        // assign arburst_m_inf = 2'd1;		// fixed mode to INCR mode 
        // assign arsize_m_inf  = 3'b100;		// fixed size to 2^4 = 16 Bytes 
		        // << Burst & ID >>
        // assign awid_m_inf    = 4'd0;
        // assign awburst_m_inf = 2'd1;
        // assign awsize_m_inf  = 3'b100;
        // assign awlen_m_inf   = 8'd127;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		input_cnt <= 0;
		begin_ <= 1;
	end else if (bvalid_m_inf) begin
		input_cnt <= 0;
		begin_ <= 1;
	end else if (in_valid) begin
		net_id_save[input_cnt] <= net_id;

		if (begin_) begin
			start_x[input_cnt] <= loc_x;
			start_y[input_cnt] <= loc_y;
		end
		else begin
			end_x[input_cnt] <= loc_x;
			end_y[input_cnt] <= loc_y;
			input_cnt <= input_cnt + 1;
		end
		begin_ <= ~begin_;
	end
	else if(RETRACT_done && S_INPUT) begin
		for(ctr_i=0; ctr_i<14; ctr_i=ctr_i+1) begin
			net_id_save[ctr_i] <= net_id_save[ctr_i+1];
			start_x[ctr_i] <= start_x[ctr_i+1];
			start_y[ctr_i] <= start_y[ctr_i+1];
			end_x[ctr_i] <= end_x[ctr_i+1];
			end_y[ctr_i] <= end_y[ctr_i+1];
		end
	end
end
always @(*) begin
	if (FETCH_D_flag) begin
		arvalid_m_inf = 1'b1;
		if (pouble) begin
			araddr_m_inf = {16'd1, frame_id_save, 11'b0};
		end else begin
			araddr_m_inf = {16'd2, frame_id_save, 11'b0};
		end
	end else begin
		araddr_m_inf =0;
		arvalid_m_inf =0;
	end
end
always @(*) begin
	val_tx = ctr_t + 1;
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
	    ctr_t <= 0;
	end
	else if(rlast_m_inf || wlast_m_inf) begin
		ctr_t <= 0;
	end
	else if(rvalid_m_inf || wready_m_inf) begin
		ctr_t <= val_tx;
	end
end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
	    S_INPUT <= 0;
	end else if(CS_LEE) begin
		S_INPUT <= 0;
	end else if(CS_RETRACT) begin
		S_INPUT <= ~S_INPUT;
	end
end
always @(*) begin
	if (WRITE_D_flag) begin
		awaddr_m_inf  = {16'd1, frame_id_save, 11'b0};
		awvalid_m_inf = 1;
	end else begin
		awaddr_m_inf  =0;
		awvalid_m_inf =0;
	end
end
always @(*) begin
	if (FIN_D_flag) begin
		wdata_m_inf  = Loc_val;
		wvalid_m_inf = 1;
	end else begin
		wdata_m_inf  = 0;
		wvalid_m_inf = 0;
	end
end
always @(*) begin
	if (FIN_D_flag && ctr_t ==127) begin
		wlast_m_inf = 1;
	end else begin
		wlast_m_inf = 0;
	end
end
always @(*) begin
	if (FIN_D_flag || END_S_flag) begin
		bready_m_inf = 1;
	end else begin
		bready_m_inf = 0;
	end
end
    // always@(posedge clk or negedge rst_n)begin //alreadysentARready
    //     if(!rst_n)begin 
    //         AlreadysentAR<=0;
    //     end else begin
    //         case(curr_state)
    //             READ: begin
    //                 if((arready_m_inf==1)&&(curr_state==READ))
    //                     AlreadysentAR<=1;
    //                     else if(next_state==PREADSD)
    //                         AlreadysentAR<=0;
    //                     else
    //                     AlreadysentAR<=AlreadysentAR;
    //             end
    //             PREADSD: begin
    //                 if((arready_m_inf==1))
    //                     AlreadysentAR<=1;
    //                     else
    //                     AlreadysentAR<=AlreadysentAR;
    //             end
    //             default: AlreadysentAR<=0;
    //         endcase
    //     end
    // end
    // always @(*)begin //ARvalid araddr_m_inf
    //         case(curr_state)            
    //             READ: begin
    //                 if(!AlreadysentAR) begin 
    //                     arvalid_m_inf=1;
    //                     araddr_m_inf=address_dram;
    //                 end else begin
    //                     arvalid_m_inf=0; 
    //                     araddr_m_inf=0;
    //                 end
    //             end  
    //             PREADSD: begin
    //                 if(!AlreadysentAR) begin 
    //                     arvalid_m_inf=1;
    //                     araddr_m_inf=address_dram;
    //                 end else begin
    //                     arvalid_m_inf=0; 
    //                     araddr_m_inf=0;
    //                 end
    //             end
    //             default: begin
    //             arvalid_m_inf=0; 
    //             araddr_m_inf=0;
    //             end 
    //         endcase
    // end

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>DATA registers<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
always @(posedge clk) begin
	if(in_valid) begin
		frame_id_save <= frame_id;
	end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
	    lood <= 0;
	end else if(FETCH_D_flag) begin
		lood <= 0;
	end else if(RETRACT_done && S_INPUT) begin
		lood <= lood_1;
	end
end
always @(*) begin
	RETRACT_di = Loc_val;
	if (RETRACT_x[4:0] == 0) begin
		RETRACT_di[3:0] = net_id_now;
	end else if (RETRACT_x[4:0] == 1) begin
		RETRACT_di[7:4] = net_id_now;
	end else if (RETRACT_x[4:0] == 2) begin
		RETRACT_di[11:8] = net_id_now;
	end else if (RETRACT_x[4:0] == 3) begin
		RETRACT_di[15:12] = net_id_now;
	end else if (RETRACT_x[4:0] == 4) begin
		RETRACT_di[19:16] = net_id_now;
	end else if (RETRACT_x[4:0] == 5) begin
		RETRACT_di[23:20] = net_id_now;
	end else if (RETRACT_x[4:0] == 6) begin
		RETRACT_di[27:24] = net_id_now;
	end else if (RETRACT_x[4:0] == 7) begin
		RETRACT_di[31:28] = net_id_now;
	end else if (RETRACT_x[4:0] == 8) begin
		RETRACT_di[35:32] = net_id_now;
	end else if (RETRACT_x[4:0] == 9) begin
		RETRACT_di[39:36] = net_id_now;
	end else if (RETRACT_x[4:0] == 10) begin
		RETRACT_di[43:40] = net_id_now;
	end else if (RETRACT_x[4:0] == 11) begin
		RETRACT_di[47:44] = net_id_now;
	end else if (RETRACT_x[4:0] == 12) begin
		RETRACT_di[51:48] = net_id_now;
	end else if (RETRACT_x[4:0] == 13) begin
		RETRACT_di[55:52] = net_id_now;
	end else if (RETRACT_x[4:0] == 14) begin
		RETRACT_di[59:56] = net_id_now;
	end else if (RETRACT_x[4:0] == 15) begin
		RETRACT_di[63:60] = net_id_now;
	end else if (RETRACT_x[4:0] == 16) begin
		RETRACT_di[67:64] = net_id_now;
	end else if (RETRACT_x[4:0] == 17) begin
		RETRACT_di[71:68] = net_id_now;
	end else if (RETRACT_x[4:0] == 18) begin
		RETRACT_di[75:72] = net_id_now;
	end else if (RETRACT_x[4:0] == 19) begin
		RETRACT_di[79:76] = net_id_now;
	end else if (RETRACT_x[4:0] == 20) begin
		RETRACT_di[83:80] = net_id_now;
	end else if (RETRACT_x[4:0] == 21) begin
		RETRACT_di[87:84] = net_id_now;
	end else if (RETRACT_x[4:0] == 22) begin
		RETRACT_di[91:88] = net_id_now;
	end else if (RETRACT_x[4:0] == 23) begin
		RETRACT_di[95:92] = net_id_now;
	end else if (RETRACT_x[4:0] == 24) begin
		RETRACT_di[99:96] = net_id_now;
	end else if (RETRACT_x[4:0] == 25) begin
		RETRACT_di[103:100] = net_id_now;
	end else if (RETRACT_x[4:0] == 26) begin
		RETRACT_di[107:104] = net_id_now;
	end else if (RETRACT_x[4:0] == 27) begin
		RETRACT_di[111:108] = net_id_now;
	end else if (RETRACT_x[4:0] == 28) begin
		RETRACT_di[115:112] = net_id_now;
	end else if (RETRACT_x[4:0] == 29) begin
		RETRACT_di[119:116] = net_id_now;
	end else if (RETRACT_x[4:0] == 30) begin
		RETRACT_di[123:120] = net_id_now;
	end else if (RETRACT_x[4:0] == 31) begin
		RETRACT_di[127:124] = net_id_now;
	end
end
always @(*) begin
	if (rvalid_m_inf && pouble) begin
		_Wel = 0;
	end else if (S_INPUT) begin
		_Wel = 0;
	end else begin
		_Wel = 1;
	end
end
always @(*) begin
	if (rvalid_m_inf && !pouble) begin
		_Wew = 0;
	end else begin
		_Wew = 1;
	end
end
always @(*) begin
    if (WRITE_S_flag) begin
		rready_m_inf = 1;
	end else begin
		rready_m_inf = 0;
	end
end
always @(posedge clk) begin
	if (CS_PLT) begin
		LEE_cnt <= 1;
	end else if (CS_LEE && !LEE_end) begin
		if (LEE_cnt == 0) begin
			LEE_cnt <= 1;
		end else if (LEE_cnt ==1) begin
			LEE_cnt <=2;
		end else if (LEE_cnt ==2) begin
			LEE_cnt <= 3;
		end else if (LEE_cnt ==3) begin
			LEE_cnt <=0;
		end
	end else if (S_INPUT) begin
		if (LEE_cnt ==0) begin
			LEE_cnt <= 3;
		end else if (LEE_cnt ==1) begin
			LEE_cnt <=0;
		end else if (LEE_cnt == 2) begin
			LEE_cnt <=1;
		end else if (LEE_cnt ==3) begin
			LEE_cnt <=2;
		end
	end
end
always @(*) begin
	if (RETRACT_x[4:0] == 0) begin
		Cr_W = W_val[3:0];
	end else if (RETRACT_x[4:0] == 1) begin
		Cr_W = W_val[7:4];
	end else if (RETRACT_x[4:0] == 2) begin
		Cr_W = W_val[11:8];
	end else if (RETRACT_x[4:0] == 3) begin
		Cr_W = W_val[15:12];
	end else if (RETRACT_x[4:0] == 4) begin
		Cr_W = W_val[19:16];
	end else if (RETRACT_x[4:0] == 5) begin
		Cr_W = W_val[23:20];
	end else if (RETRACT_x[4:0] == 6) begin
		Cr_W = W_val[27:24];
	end else if (RETRACT_x[4:0] == 7) begin
		Cr_W = W_val[31:28];
	end else if (RETRACT_x[4:0] == 8) begin
		Cr_W = W_val[35:32];
	end else if (RETRACT_x[4:0] == 9) begin
		Cr_W = W_val[39:36];
	end else if (RETRACT_x[4:0] == 10) begin
		Cr_W = W_val[43:40];
	end else if (RETRACT_x[4:0] == 11) begin
		Cr_W = W_val[47:44];
	end else if (RETRACT_x[4:0] == 12) begin
		Cr_W = W_val[51:48];
	end else if (RETRACT_x[4:0] == 13) begin
		Cr_W = W_val[55:52];
	end else if (RETRACT_x[4:0] == 14) begin
		Cr_W = W_val[59:56];
	end else if (RETRACT_x[4:0] == 15) begin
		Cr_W = W_val[63:60];
	end else if (RETRACT_x[4:0] == 16) begin
		Cr_W = W_val[67:64];
	end else if (RETRACT_x[4:0] == 17) begin
		Cr_W = W_val[71:68];
	end else if (RETRACT_x[4:0] == 18) begin
		Cr_W = W_val[75:72];
	end else if (RETRACT_x[4:0] == 19) begin
		Cr_W = W_val[79:76];
	end else if (RETRACT_x[4:0] == 20) begin
		Cr_W = W_val[83:80];
	end else if (RETRACT_x[4:0] == 21) begin
		Cr_W = W_val[87:84];
	end else if (RETRACT_x[4:0] == 22) begin
		Cr_W = W_val[91:88];
	end else if (RETRACT_x[4:0] == 23) begin
		Cr_W = W_val[95:92];
	end else if (RETRACT_x[4:0] == 24) begin
		Cr_W = W_val[99:96];
	end else if (RETRACT_x[4:0] == 25) begin
		Cr_W = W_val[103:100];
	end else if (RETRACT_x[4:0] == 26) begin
		Cr_W = W_val[107:104];
	end else if (RETRACT_x[4:0] == 27) begin
		Cr_W = W_val[111:108];
	end else if (RETRACT_x[4:0] == 28) begin
		Cr_W = W_val[115:112];
	end else if (RETRACT_x[4:0] == 29) begin
		Cr_W = W_val[119:116];
	end else if (RETRACT_x[4:0] == 30) begin
		Cr_W = W_val[123:120];
	end else if (RETRACT_x[4:0] == 31) begin
		Cr_W = W_val[127:124];
	end else begin
		Cr_W = 0;
	end
end

generate
	for(idx=0; idx<64; idx=idx+1) begin
		for(jdx=0; jdx<64; jdx=jdx+1) begin
			always @(posedge clk) begin
					LEE_map_current[idx][jdx] <= LEE_map_next[idx][jdx];
			end
		end
	end
endgenerate
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Retract resutl<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cost <= 0;
	end else if (S_INPUT && (RETRACT_x != destx_ || RETRACT_y != desty_) && !RETRACT_done) begin 
		cost <= cost + Cr_W;
	end  else if (FETCH_D_flag) begin
		cost <= 0;
	end
end
always @(*) begin
	if (LEE_cnt == 0) begin
		RETRACT_path = 1;
	end else if (LEE_cnt == 1) begin
		RETRACT_path = 0;
	end else if (LEE_cnt == 2) begin
		RETRACT_path = 0;
	end else if (LEE_cnt == 3) begin
		RETRACT_path = 1;
	end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
		RETRACT_x <= 0;
	end else if(CS_LEE) begin
		RETRACT_x <= destx_;
	end else if(S_INPUT) begin
		RETRACT_x <= RETRACT_x_next;
	end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
		RETRACT_y <= 0;
	end else if(CS_LEE) begin
		RETRACT_y <= desty_;
	end else if(S_INPUT) begin
		RETRACT_y <= RETRACT_y_next;
	end
end
always @(*) begin
	RETRACT_x_next = RETRACT_x;
	RETRACT_y_next = RETRACT_y;
	if(LEE_map_current[RETRACT_y+1][RETRACT_x] == {1'b1, RETRACT_path} && RETRACT_y != 63) begin
		RETRACT_y_next = RETRACT_y + 1;
	end else if(LEE_map_current[RETRACT_y-1][RETRACT_x] == {1'b1, RETRACT_path} && RETRACT_y != 0) begin
		RETRACT_y_next = RETRACT_y - 1;
	end else if(LEE_map_current[RETRACT_y][RETRACT_x+1] == {1'b1, RETRACT_path} && RETRACT_x != 63) begin
		RETRACT_x_next = RETRACT_x + 1;
	end else begin
		RETRACT_x_next = RETRACT_x - 1;
	end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
		busy <= 0;
	end else if (!in_valid&&(FETCH_D_flag || WRITE_S_flag)) begin
		busy <= 1;
	end else if (bvalid_m_inf) begin
		busy <= 0;
	end
end
always @(*) begin
	if (rvalid_m_inf && pouble) begin 
		for(jj=0;jj<32;jj=jj+1) begin
			LEE_map_next[63][jj+32] = {1'b0,|rdata_m_inf[jj*4 +: 4]};
		end
		for(ii=0;ii<64;ii=ii+1) begin
			for(jj=0;jj<32;jj=jj+1) begin
				LEE_map_next[ii][jj]  = LEE_map_current[ii][jj+32];
			end
		end
		for(ii=0;ii<63;ii=ii+1) begin
			for(jj=32;jj<64;jj=jj+1) begin
				LEE_map_next[ii][jj] = LEE_map_current[ii+1][jj-32];
			end
		end
	end else if (CS_PLT) begin
		for(ii=2; ii<62; ii=ii+1) begin
			for(jj=2; jj<62; jj=jj+1) begin
				if(sourcey_ == ii && sourcex_ == jj) begin
					LEE_map_next[ii][jj] = 2;
				end else if(desty_ == ii && destx_ == jj) begin
					LEE_map_next[ii][jj] = 0;
				end else begin
					LEE_map_next[ii][jj] = {1'b0, {(~LEE_map_current[ii][jj][1]) & LEE_map_current[ii][jj][0]}};
				end
			end
		end
		for(ii=0; ii<2; ii=ii+1) begin
			for(jj=0; jj<64; jj=jj+1) begin
				LEE_map_next[ii][jj] = {1'b0, {(~LEE_map_current[ii][jj][1]) & LEE_map_current[ii][jj][0]}};
			end
		end
		for(ii=62; ii<64; ii=ii+1) begin
			for(jj=0; jj<64; jj=jj+1) begin
				LEE_map_next[ii][jj] = {1'b0, {(~LEE_map_current[ii][jj][1]) & LEE_map_current[ii][jj][0]}};
			end
		end
		for(ii=2; ii<62; ii=ii+1) begin
			for(jj=0; jj<2; jj=jj+1) begin
				LEE_map_next[ii][jj] = {1'b0, {(~LEE_map_current[ii][jj][1]) & LEE_map_current[ii][jj][0]}};
			end
		end
		for(ii=2; ii<62; ii=ii+1) begin
			for(jj=62; jj<64; jj=jj+1) begin
				LEE_map_next[ii][jj] = {1'b0, {(~LEE_map_current[ii][jj][1]) & LEE_map_current[ii][jj][0]}};
			end
		end
	end
	else if (CS_LEE) begin
		for(ii=1; ii<63; ii=ii+1) begin 
			for(jj=1; jj<63; jj=jj+1) begin
				if(LEE_map_current[ii][jj] == 0 && (LEE_map_current[ii-1][jj][1] | LEE_map_current[ii+1][jj][1] | LEE_map_current[ii][jj-1][1] | LEE_map_current[ii][jj+1][1])) begin
					LEE_map_next[ii][jj] = {1'b1,LEE_cnt[1]};
				end
				else begin
					LEE_map_next[ii][jj] = LEE_map_current[ii][jj];
				end
			end
			if(LEE_map_current[ii][0] == 0 && (LEE_map_current[ii-1][0][1] | LEE_map_current[ii+1][0][1] | LEE_map_current[ii][1][1])) begin //center-left
				LEE_map_next[ii][0] = {1'b1,LEE_cnt[1]};
			end else begin
				LEE_map_next[ii][0] = LEE_map_current[ii][0];
			end

			if(LEE_map_current[ii][63] == 0 && (LEE_map_current[ii-1][63][1] | LEE_map_current[ii+1][63][1] | LEE_map_current[ii][62][1])) begin //center-right
				LEE_map_next[ii][63] = {1'b1,LEE_cnt[1]};
			end else begin
				LEE_map_next[ii][63] = LEE_map_current[ii][63];
			end

			if(LEE_map_current[0][ii] == 0 && (LEE_map_current[0][ii-1][1] | LEE_map_current[0][ii+1][1] | LEE_map_current[1][ii][1])) begin //center-up
				LEE_map_next[0][ii] = {1'b1,LEE_cnt[1]};
			end else begin
				LEE_map_next[0][ii] = LEE_map_current[0][ii];
			end

			if(LEE_map_current[63][ii] == 0 && (LEE_map_current[63][ii-1][1] | LEE_map_current[63][ii+1][1] | LEE_map_current[62][ii][1])) begin //center-down
				LEE_map_next[63][ii] = {1'b1,LEE_cnt[1]};
			end else begin
				LEE_map_next[63][ii] = LEE_map_current[63][ii];
			end
		end
		if(LEE_map_current[0][0] == 0 && (LEE_map_current[0][1][1] | LEE_map_current[1][0][1])) begin //left-up
			LEE_map_next[0][0] = {1'b1,LEE_cnt[1]};
		end else begin
			LEE_map_next[0][0] = LEE_map_current[0][0];
		end if(LEE_map_current[0][63] == 0 && (LEE_map_current[0][62][1] | LEE_map_current[1][63][1])) begin //left-down
			LEE_map_next[0][63] = {1'b1,LEE_cnt[1]};
		end else begin
			LEE_map_next[0][63] = LEE_map_current[0][63];
		end

		if(LEE_map_current[63][0] == 0 && (LEE_map_current[62][0][1] | LEE_map_current[63][1][1])) begin //right-up
			LEE_map_next[63][0] = {1'b1,LEE_cnt[1]};
		end else begin
			LEE_map_next[63][0] = LEE_map_current[63][0];
		end

		if(LEE_map_current[63][63] == 0 && (LEE_map_current[62][63][1] | LEE_map_current[63][62][1])) begin //right-down
			LEE_map_next[63][63] = {1'b1,LEE_cnt[1]};
		end else begin
			LEE_map_next[63][63] = LEE_map_current[63][63];
		end
	end else if (S_INPUT) begin
		for(ii=0;ii<64;ii=ii+1) begin
			for(jj=0;jj<64;jj=jj+1) begin
				if (ii == RETRACT_y && jj == RETRACT_x) begin
					LEE_map_next[ii][jj] = 1;
				end else begin
					LEE_map_next[ii][jj] = LEE_map_current[ii][jj];
				end
			end
		end
	end
	else begin
		for(ii=0;ii<64;ii=ii+1) begin
			for(jj=0;jj<64;jj=jj+1) begin
				LEE_map_next[ii][jj] = LEE_map_current[ii][jj];
			end
		end
	end
end
endmodule
// //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>DRAM drivers<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//     always@(posedge clk or negedge rst_n)begin      //address_dram
//         if(!rst_n)begin 
//             address_dram<=0;
//         end else if(in_valid&&ctr==1)begin 
//         case(frame_id_reg)
//                 0: address_dram<=32'h0001_0000;
//                 1: address_dram<=32'h0001_0800;
//                 2: address_dram<=32'h0001_1000;
//                 3: address_dram<=32'h0001_1800;
//                 4: address_dram<=32'h0001_2000;
//                 5: address_dram<=32'h0001_2800;
//                 6: address_dram<=32'h0001_3000;
//                 7: address_dram<=32'h0001_3800;
//                 8: address_dram<=32'h0001_4000;
//                 9: address_dram<=32'h0001_4800;
//                 10: address_dram<=32'h0001_5000;
//                 11: address_dram<=32'h0001_5800;
//                 12: address_dram<=32'h0001_6000;
//                 13: address_dram<=32'h0001_6800;
//                 14: address_dram<=32'h0001_7000;
//                 15: address_dram<=32'h0001_7800;
//                 16: address_dram<=32'h0001_8000;
//                 17: address_dram<=32'h0001_8800;
//                 18: address_dram<=32'h0001_9000;
//                 19: address_dram<=32'h0001_9800;
//                 20: address_dram<=32'h0001_A000;
//                 21: address_dram<=32'h0001_A800;
//                 22: address_dram<=32'h0001_B000;
//                 23: address_dram<=32'h0001_B800;
//                 24: address_dram<=32'h0001_C000;
//                 25: address_dram<=32'h0001_C800;
//                 26: address_dram<=32'h0001_D000;
//                 27: address_dram<=32'h0001_D800;
//                 28: address_dram<=32'h0001_E000;
//                 29: address_dram<=32'h0001_E800;
//                 30: address_dram<=32'h0001_F000;
//                 31: address_dram<=32'h0001_F800; 
//                 default: address_dram<=address_dram;           
//         endcase
//         end else begin 
//             address_dram<=address_dram;      
//         end
//     end
//     always@(posedge clk or negedge rst_n)begin      //address_weight
//         if(!rst_n)begin 
//             address_weight<=0;
//         end else if(in_valid&&ctr==1)begin 
//         case(frame_id_reg)
//                 0: address_weight<=32'h0002_0000;
//                 1: address_weight<=32'h0002_0800;
//                 2: address_weight<=32'h0002_1000;
//                 3: address_weight<=32'h0002_1800;
//                 4: address_weight<=32'h0002_2000;
//                 5: address_weight<=32'h0002_2800;
//                 6: address_weight<=32'h0002_3000;
//                 7: address_weight<=32'h0002_3800;
//                 8: address_weight<=32'h0002_4000;
//                 9: address_weight<=32'h0002_4800;
//                 10: address_weight<=32'h0002_5000;
//                 11: address_weight<=32'h0002_5800;
//                 12: address_weight<=32'h0002_6000;
//                 13: address_weight<=32'h0002_6800;
//                 14: address_weight<=32'h0002_7000;
//                 15: address_weight<=32'h0002_7800;
//                 16: address_weight<=32'h0002_8000;
//                 17: address_weight<=32'h0002_8800;
//                 18: address_weight<=32'h0002_9000;
//                 19: address_weight<=32'h0002_9800;
//                 20: address_weight<=32'h0002_A000;
//                 21: address_weight<=32'h0002_A800;
//                 22: address_weight<=32'h0002_B000;
//                 23: address_weight<=32'h0002_B800;
//                 24: address_weight<=32'h0002_C000;
//                 25: address_weight<=32'h0002_C800;
//                 26: address_weight<=32'h0002_D000;
//                 27: address_weight<=32'h0002_D800;
//                 28: address_weight<=32'h0002_E000;
//                 29: address_weight<=32'h0002_E800;
//                 30: address_weight<=32'h0002_F000;
//                 31: address_weight<=32'h0002_F800; 
//                 default: address_weight<=address_weight;           
//         endcase
//         end else begin 
//             address_weight<=address_weight;      
//         end
//     end
//     //-----------------------------TA defined params----------------------------------------------------------------
//         assign arid_m_inf    = 4'd0; 			// fixed id to  0 
//         assign arburst_m_inf = 1;		// fixed mode to INCR mode 
//         assign arsize_m_inf  = 3'b100;		// fixed size to 2^4 = 16 Bytes 
//         assign arlen_m_inf   = 8'd127;

//         // << Burst & ID >>
//         assign awid_m_inf    = 4'd0;
//         assign awburst_m_inf = 1;
//         assign awsize_m_inf  = 3'b100;
//         assign awlen_m_inf   = 8'd127;
//     always@(posedge clk or negedge rst_n)begin //alreadysentARready
//         if(!rst_n)begin 
//             AlreadysentAR<=0;
//         end else begin
//             case(curr_state)
//                 READ: begin
//                     if((arready_m_inf==1)&&(curr_state==READ))
//                         AlreadysentAR<=1;
//                         else if(n_state_==PREADSD)
//                             AlreadysentAR<=0;
//                         else
//                         AlreadysentAR<=AlreadysentAR;
//                 end
//                 PREADSD: begin
//                     if((arready_m_inf==1))
//                         AlreadysentAR<=1;
//                         else
//                         AlreadysentAR<=AlreadysentAR;
//                 end
//                 default: AlreadysentAR<=0;
//             endcase
//         end
//     end
//     always @(*)begin //ARvalid araddr_m_inf
//             case(curr_state)            
//                 READ: begin
//                     if(!AlreadysentAR) begin 
//                         arvalid_m_inf=1;
//                         araddr_m_inf=address_dram;
//                     end else begin
//                         arvalid_m_inf=0; 
//                         araddr_m_inf=0;
//                     end
//                 end  
//                 PREADSD: begin
//                     if(!AlreadysentAR) begin 
//                         arvalid_m_inf=1;
//                         araddr_m_inf=address_dram;
//                     end else begin
//                         arvalid_m_inf=0; 
//                         araddr_m_inf=0;
//                     end
//                 end
//                 default: begin
//                 arvalid_m_inf=0; 
//                 araddr_m_inf=0;
//                 end 
//             endcase
//     end
//     assign rready_m_inf = _rready;
//     always@(*)//rdata_m_inf
//         begin
//             if(!rst_n)
//                 _rready <= 1'b0;
//             else
//             case(curr_state)
//                 READ: begin
//                     if(arvalid_m_inf && arready_m_inf)
//                         _rready <= 1'b1;
//                     else if(!rvalid_m_inf&&alreadysentrvalid)
//                         _rready <= 1'b0;
//                     else if(n_state_==PREADSD) 
//                         _rready <= 1'b0;
//                 end
//                 PREADSD: begin
//                     if(arvalid_m_inf && arready_m_inf)
//                         _rready <= 1'b1;
//                     else if(!rvalid_m_inf&&alreadysentrvalid)
//                         _rready <= 1'b0;
//                 end
//             endcase
//     end 
//     always @(posedge clk or negedge rst_n) begin//alreadysentrvalid
//         if(!rst_n) begin
//             alreadysentrvalid<=0;
//         end
//         else begin
//             case(curr_state)
//             READ: begin
//                 if(rvalid_m_inf) begin
//                     alreadysentrvalid<=1;
//                 end else if(n_state_==PREADSD)begin 
//                     alreadysentrvalid<=0;
//                 end else begin
//                     alreadysentrvalid<=alreadysentrvalid;
//                 end
//             end
//             PREADSD: begin
//                 if(rvalid_m_inf) begin
//                     alreadysentrvalid<=1;
//                 end else begin
//                     alreadysentrvalid<=alreadysentrvalid;
//                 end
//             end
//             IDLE: begin
//                 alreadysentrvalid<=0;
//             end
//             endcase 
//         end
//     end
//     always@(posedge clk or negedge rst_n)begin//busy
//         if(!rst_n)begin 
//             busy<=0;
//         end else if(in_valid)begin 
//             busy<=0;
//         end else if(!in_valid&&!CS_Idle)begin //rmbr make busy low at 
//             busy<=1;
//         end else if(CS_Out)begin 
//             busy<=0;
//         end
//     end
// //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SRAM_SAVE<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//     reg [6:0] AddrW, AddrLoc;
//     reg [127:0] Weight_Val;
//     wire [127:0] LOC_val;
//     reg wen_w, wen_loc;
//     reg [127:0] D_W, D_loc;

//     reg [127:0] weight_Q_r;
//     reg [3:0] weight_4b;
//     RA1SH Weight_ (.A0(AddrW[0]),.A1(AddrW[1]),.A2(AddrW[2]),.A3(AddrW[3]),.A4(AddrW[4]),.A5(AddrW[5]),.A6(AddrW[6]),
//             .DO0(Weight_Val[0]),.DO1(Weight_Val[1]),.DO2(Weight_Val[2]),.DO3(Weight_Val[3]),.DO4(Weight_Val[4]),.DO5(Weight_Val[5]), 
//             .DO6(Weight_Val[6]),.DO7(Weight_Val[7]),.DO8(Weight_Val[8]),.DO9(Weight_Val[9]),.DO10(Weight_Val[10]),.DO11(Weight_Val[11]), 
//             .DO12(Weight_Val[12]),.DO13(Weight_Val[13]),.DO14(Weight_Val[14]),.DO15(Weight_Val[15]),.DO16(Weight_Val[16]),.DO17(Weight_Val[17]), 
//             .DO18(Weight_Val[18]),.DO19(Weight_Val[19]),.DO20(Weight_Val[20]),.DO21(Weight_Val[21]),.DO22(Weight_Val[22]),.DO23(Weight_Val[23]), 
//             .DO24(Weight_Val[24]),.DO25(Weight_Val[25]),.DO26(Weight_Val[26]),.DO27(Weight_Val[27]),.DO28(Weight_Val[28]),.DO29(Weight_Val[29]), 
//             .DO30(Weight_Val[30]),.DO31(Weight_Val[31]),.DO32(Weight_Val[32]),.DO33(Weight_Val[33]),.DO34(Weight_Val[34]),.DO35(Weight_Val[35]), 
//             .DO36(Weight_Val[36]),.DO37(Weight_Val[37]),.DO38(Weight_Val[38]),.DO39(Weight_Val[39]),.DO40(Weight_Val[40]),.DO41(Weight_Val[41]), 
//             .DO42(Weight_Val[42]),.DO43(Weight_Val[43]),.DO44(Weight_Val[44]),.DO45(Weight_Val[45]),.DO46(Weight_Val[46]),.DO47(Weight_Val[47]), 
//             .DO48(Weight_Val[48]),.DO49(Weight_Val[49]),.DO50(Weight_Val[50]),.DO51(Weight_Val[51]),.DO52(Weight_Val[52]),.DO53(Weight_Val[53]), 
//             .DO54(Weight_Val[54]),.DO55(Weight_Val[55]),.DO56(Weight_Val[56]),.DO57(Weight_Val[57]),.DO58(Weight_Val[58]),.DO59(Weight_Val[59]), 
//             .DO60(Weight_Val[60]),.DO61(Weight_Val[61]),.DO62(Weight_Val[62]),.DO63(Weight_Val[63]),.DO64(Weight_Val[64]),.DO65(Weight_Val[65]), 
//             .DO66(Weight_Val[66]),.DO67(Weight_Val[67]),.DO68(Weight_Val[68]),.DO69(Weight_Val[69]),.DO70(Weight_Val[70]),.DO71(Weight_Val[71]), 
//             .DO72(Weight_Val[72]),.DO73(Weight_Val[73]),.DO74(Weight_Val[74]),.DO75(Weight_Val[75]),.DO76(Weight_Val[76]),.DO77(Weight_Val[77]), 
//             .DO78(Weight_Val[78]),.DO79(Weight_Val[79]),.DO80(Weight_Val[80]),.DO81(Weight_Val[81]),.DO82(Weight_Val[82]),.DO83(Weight_Val[83]), 
//             .DO84(Weight_Val[84]),.DO85(Weight_Val[85]),.DO86(Weight_Val[86]),.DO87(Weight_Val[87]),.DO88(Weight_Val[88]),.DO89(Weight_Val[89]), 
//             .DO90(Weight_Val[90]),.DO91(Weight_Val[91]),.DO92(Weight_Val[92]),.DO93(Weight_Val[93]),.DO94(Weight_Val[94]),.DO95(Weight_Val[95]), 
//             .DO96(Weight_Val[96]),.DO97(Weight_Val[97]),.DO98(Weight_Val[98]),.DO99(Weight_Val[99]),.DO100(Weight_Val[100]),.DO101(Weight_Val[101]), 
//             .DO102(Weight_Val[102]),.DO103(Weight_Val[103]),.DO104(Weight_Val[104]),.DO105(Weight_Val[105]),.DO106(Weight_Val[106]),.DO107(Weight_Val[107]), 
//             .DO108(Weight_Val[108]),.DO109(Weight_Val[109]),.DO110(Weight_Val[110]),.DO111(Weight_Val[111]),.DO112(Weight_Val[112]),.DO113(Weight_Val[113]),
//             .DO114(Weight_Val[114]),.DO115(Weight_Val[115]),.DO116(Weight_Val[116]),.DO117(Weight_Val[117]),.DO118(Weight_Val[118]),.DO119(Weight_Val[119]),
//             .DO120(Weight_Val[120]),.DO121(Weight_Val[121]),.DO122(Weight_Val[122]),.DO123(Weight_Val[123]),.DO124(Weight_Val[124]),.DO125(Weight_Val[125]),
//             .DO126(Weight_Val[126]),.DO127(Weight_Val[127]),.DI0(D_W[0]),.DI1(D_W[1]),.DI2(D_W[2]),.DI3(D_W[3]),.DI4(D_W[4]),
//             .DI5(D_W[5]),.DI6(D_W[6]),.DI7(D_W[7]),.DI8(D_W[8]),.DI9(D_W[9]),.DI10(D_W[10]),.DI11(D_W[11]),
//             .DI12(D_W[12]),.DI13(D_W[13]),.DI14(D_W[14]),.DI15(D_W[15]),.DI16(D_W[16]),.DI17(D_W[17]),.DI18(D_W[18]), 
//             .DI19(D_W[19]),.DI20(D_W[20]),.DI21(D_W[21]),.DI22(D_W[22]),.DI23(D_W[23]),.DI24(D_W[24]), 
//             .DI25(D_W[25]),.DI26(D_W[26]),.DI27(D_W[27]),.DI28(D_W[28]),.DI29(D_W[29]),.DI30(D_W[30]), 
//             .DI31(D_W[31]),.DI32(D_W[32]),.DI33(D_W[33]),.DI34(D_W[34]),.DI35(D_W[35]),.DI36(D_W[36]), 
//             .DI37(D_W[37]),.DI38(D_W[38]),.DI39(D_W[39]),.DI40(D_W[40]),.DI41(D_W[41]),.DI42(D_W[42]), 
//             .DI43(D_W[43]),.DI44(D_W[44]),.DI45(D_W[45]),.DI46(D_W[46]),.DI47(D_W[47]),.DI48(D_W[48]), 
//             .DI49(D_W[49]),.DI50(D_W[50]),.DI51(D_W[51]),.DI52(D_W[52]),.DI53(D_W[53]),.DI54(D_W[54]), 
//             .DI55(D_W[55]),.DI56(D_W[56]),.DI57(D_W[57]),.DI58(D_W[58]),.DI59(D_W[59]),.DI60(D_W[60]), 
//             .DI61(D_W[61]),.DI62(D_W[62]),.DI63(D_W[63]),.DI64(D_W[64]),.DI65(D_W[65]),.DI66(D_W[66]), 
//             .DI67(D_W[67]),.DI68(D_W[68]),.DI69(D_W[69]),.DI70(D_W[70]),.DI71(D_W[71]),.DI72(D_W[72]), 
//             .DI73(D_W[73]),.DI74(D_W[74]),.DI75(D_W[75]),.DI76(D_W[76]),.DI77(D_W[77]),.DI78(D_W[78]), 
//             .DI79(D_W[79]),.DI80(D_W[80]),.DI81(D_W[81]),.DI82(D_W[82]),.DI83(D_W[83]),.DI84(D_W[84]), 
//             .DI85(D_W[85]),.DI86(D_W[86]),.DI87(D_W[87]),.DI88(D_W[88]),.DI89(D_W[89]),.DI90(D_W[90]), 
//             .DI91(D_W[91]),.DI92(D_W[92]),.DI93(D_W[93]),.DI94(D_W[94]),.DI95(D_W[95]),.DI96(D_W[96]), 
//             .DI97(D_W[97]),.DI98(D_W[98]),.DI99(D_W[99]),.DI100(D_W[100]),.DI101(D_W[101]),.DI102(D_W[102]), 
//             .DI103(D_W[103]),.DI104(D_W[104]),.DI105(D_W[105]),.DI106(D_W[106]),.DI107(D_W[107]),.DI108(D_W[108]), 
//             .DI109(D_W[109]),.DI110(D_W[110]),.DI111(D_W[111]),.DI112(D_W[112]),.DI113(D_W[113]),.DI114(D_W[114]), 
//             .DI115(D_W[115]),.DI116(D_W[116]),.DI117(D_W[117]),.DI118(D_W[118]),.DI119(D_W[119]),.DI120(D_W[120]), 
//             .DI121(D_W[121]),.DI122(D_W[122]),.DI123(D_W[123]),.DI124(D_W[124]),.DI125(D_W[125]),.DI126(D_W[126]), 
//             .DI127(D_W[127]),.CK(clk),.WEB(wen_w),.OE(1'b1),.CS(1'b1));

//     RA1SH LOCATION_MAP (.A0(AddrLoc[0]),.A1(AddrLoc[1]),.A2(AddrLoc[2]),.A3(AddrLoc[3]),.A4(AddrLoc[4]),.A5(AddrLoc[5]),.A6(AddrLoc[6]),
//             .DO0(LOC_val[0]),.DO1(LOC_val[1]),.DO2(LOC_val[2]),.DO3(LOC_val[3]),.DO4(LOC_val[4]),.DO5(LOC_val[5]), 
//             .DO6(LOC_val[6]),.DO7(LOC_val[7]),.DO8(LOC_val[8]),.DO9(LOC_val[9]),.DO10(LOC_val[10]),.DO11(LOC_val[11]), 
//             .DO12(LOC_val[12]),.DO13(LOC_val[13]),.DO14(LOC_val[14]),.DO15(LOC_val[15]),.DO16(LOC_val[16]),.DO17(LOC_val[17]), 
//             .DO18(LOC_val[18]),.DO19(LOC_val[19]),.DO20(LOC_val[20]),.DO21(LOC_val[21]),.DO22(LOC_val[22]),.DO23(LOC_val[23]), 
//             .DO24(LOC_val[24]),.DO25(LOC_val[25]),.DO26(LOC_val[26]),.DO27(LOC_val[27]),.DO28(LOC_val[28]),.DO29(LOC_val[29]), 
//             .DO30(LOC_val[30]),.DO31(LOC_val[31]),.DO32(LOC_val[32]),.DO33(LOC_val[33]),.DO34(LOC_val[34]),.DO35(LOC_val[35]), 
//             .DO36(LOC_val[36]),.DO37(LOC_val[37]),.DO38(LOC_val[38]),.DO39(LOC_val[39]),.DO40(LOC_val[40]),.DO41(LOC_val[41]), 
//             .DO42(LOC_val[42]),.DO43(LOC_val[43]),.DO44(LOC_val[44]),.DO45(LOC_val[45]),.DO46(LOC_val[46]),.DO47(LOC_val[47]), 
//             .DO48(LOC_val[48]),.DO49(LOC_val[49]),.DO50(LOC_val[50]),.DO51(LOC_val[51]),.DO52(LOC_val[52]),.DO53(LOC_val[53]), 
//             .DO54(LOC_val[54]),.DO55(LOC_val[55]),.DO56(LOC_val[56]),.DO57(LOC_val[57]),.DO58(LOC_val[58]),.DO59(LOC_val[59]), 
//             .DO60(LOC_val[60]),.DO61(LOC_val[61]),.DO62(LOC_val[62]),.DO63(LOC_val[63]),.DO64(LOC_val[64]),.DO65(LOC_val[65]), 
//             .DO66(LOC_val[66]),.DO67(LOC_val[67]),.DO68(LOC_val[68]),.DO69(LOC_val[69]),.DO70(LOC_val[70]),.DO71(LOC_val[71]), 
//             .DO72(LOC_val[72]),.DO73(LOC_val[73]),.DO74(LOC_val[74]),.DO75(LOC_val[75]),.DO76(LOC_val[76]),.DO77(LOC_val[77]), 
//             .DO78(LOC_val[78]),.DO79(LOC_val[79]),.DO80(LOC_val[80]),.DO81(LOC_val[81]),.DO82(LOC_val[82]),.DO83(LOC_val[83]), 
//             .DO84(LOC_val[84]),.DO85(LOC_val[85]),.DO86(LOC_val[86]),.DO87(LOC_val[87]),.DO88(LOC_val[88]),.DO89(LOC_val[89]), 
//             .DO90(LOC_val[90]),.DO91(LOC_val[91]),.DO92(LOC_val[92]),.DO93(LOC_val[93]),.DO94(LOC_val[94]),.DO95(LOC_val[95]), 
//             .DO96(LOC_val[96]),.DO97(LOC_val[97]),.DO98(LOC_val[98]),.DO99(LOC_val[99]),.DO100(LOC_val[100]),.DO101(LOC_val[101]), 
//             .DO102(LOC_val[102]),.DO103(LOC_val[103]),.DO104(LOC_val[104]),.DO105(LOC_val[105]),.DO106(LOC_val[106]),.DO107(LOC_val[107]), 
//             .DO108(LOC_val[108]),.DO109(LOC_val[109]),.DO110(LOC_val[110]),.DO111(LOC_val[111]),.DO112(LOC_val[112]),.DO113(LOC_val[113]),
//             .DO114(LOC_val[114]),.DO115(LOC_val[115]),.DO116(LOC_val[116]),.DO117(LOC_val[117]),.DO118(LOC_val[118]),.DO119(LOC_val[119]),
//             .DO120(LOC_val[120]),.DO121(LOC_val[121]),.DO122(LOC_val[122]),.DO123(LOC_val[123]),.DO124(LOC_val[124]),.DO125(LOC_val[125]),
//             .DO126(LOC_val[126]),.DO127(LOC_val[127]),.DI0(D_loc[0]),.DI1(D_loc[1]),.DI2(D_loc[2]),.DI3(D_loc[3]),.DI4(D_loc[4]),
//             .DI5(D_loc[5]),.DI6(D_loc[6]),.DI7(D_loc[7]),.DI8(D_loc[8]),.DI9(D_loc[9]),.DI10(D_loc[10]),.DI11(D_loc[11]),
//             .DI12(D_loc[12]),.DI13(D_loc[13]),.DI14(D_loc[14]),.DI15(D_loc[15]),.DI16(D_loc[16]),.DI17(D_loc[17]),.DI18(D_loc[18]), 
//             .DI19(D_loc[19]),.DI20(D_loc[20]),.DI21(D_loc[21]),.DI22(D_loc[22]),.DI23(D_loc[23]),.DI24(D_loc[24]), 
//             .DI25(D_loc[25]),.DI26(D_loc[26]),.DI27(D_loc[27]),.DI28(D_loc[28]),.DI29(D_loc[29]),.DI30(D_loc[30]), 
//             .DI31(D_loc[31]),.DI32(D_loc[32]),.DI33(D_loc[33]),.DI34(D_loc[34]),.DI35(D_loc[35]),.DI36(D_loc[36]), 
//             .DI37(D_loc[37]),.DI38(D_loc[38]),.DI39(D_loc[39]),.DI40(D_loc[40]),.DI41(D_loc[41]),.DI42(D_loc[42]), 
//             .DI43(D_loc[43]),.DI44(D_loc[44]),.DI45(D_loc[45]),.DI46(D_loc[46]),.DI47(D_loc[47]),.DI48(D_loc[48]), 
//             .DI49(D_loc[49]),.DI50(D_loc[50]),.DI51(D_loc[51]),.DI52(D_loc[52]),.DI53(D_loc[53]),.DI54(D_loc[54]), 
//             .DI55(D_loc[55]),.DI56(D_loc[56]),.DI57(D_loc[57]),.DI58(D_loc[58]),.DI59(D_loc[59]),.DI60(D_loc[60]), 
//             .DI61(D_loc[61]),.DI62(D_loc[62]),.DI63(D_loc[63]),.DI64(D_loc[64]),.DI65(D_loc[65]),.DI66(D_loc[66]), 
//             .DI67(D_loc[67]),.DI68(D_loc[68]),.DI69(D_loc[69]),.DI70(D_loc[70]),.DI71(D_loc[71]),.DI72(D_loc[72]), 
//             .DI73(D_loc[73]),.DI74(D_loc[74]),.DI75(D_loc[75]),.DI76(D_loc[76]),.DI77(D_loc[77]),.DI78(D_loc[78]), 
//             .DI79(D_loc[79]),.DI80(D_loc[80]),.DI81(D_loc[81]),.DI82(D_loc[82]),.DI83(D_loc[83]),.DI84(D_loc[84]), 
//             .DI85(D_loc[85]),.DI86(D_loc[86]),.DI87(D_loc[87]),.DI88(D_loc[88]),.DI89(D_loc[89]),.DI90(D_loc[90]), 
//             .DI91(D_loc[91]),.DI92(D_loc[92]),.DI93(D_loc[93]),.DI94(D_loc[94]),.DI95(D_loc[95]),.DI96(D_loc[96]), 
//             .DI97(D_loc[97]),.DI98(D_loc[98]),.DI99(D_loc[99]),.DI100(D_loc[100]),.DI101(D_loc[101]),.DI102(D_loc[102]), 
//             .DI103(D_loc[103]),.DI104(D_loc[104]),.DI105(D_loc[105]),.DI106(D_loc[106]),.DI107(D_loc[107]),.DI108(D_loc[108]), 
//             .DI109(D_loc[109]),.DI110(D_loc[110]),.DI111(D_loc[111]),.DI112(D_loc[112]),.DI113(D_loc[113]),.DI114(D_loc[114]), 
//             .DI115(D_loc[115]),.DI116(D_loc[116]),.DI117(D_loc[117]),.DI118(D_loc[118]),.DI119(D_loc[119]),.DI120(D_loc[120]), 
//             .DI121(D_loc[121]),.DI122(D_loc[122]),.DI123(D_loc[123]),.DI124(D_loc[124]),.DI125(D_loc[125]),.DI126(D_loc[126]), 
//             .DI127(D_loc[127]),.CK(clk),.WEB(wen_loc),.OE(1'b1),.CS(1'b1));

//     always @(posedge clk or negedge rst_n) begin//loc map
//         if(!rst_n) begin
//             wen_loc<=1;
//             AddrLoc<=0;
//             D_loc<=0;
//         end
//         else begin
//             if(rvalid_m_inf&&CS_Read)begin
//                 wen_loc<=0;//fill it in
//                 AddrLoc<=ctr;
//                 D_loc<=rdata_m_inf;
//             end else begin 
//                 wen_loc<=1;
//                 AddrLoc<=0;
//                 D_loc<=0;
//             end
//         end
//     end
//     always @(posedge clk or negedge rst_n) begin//weight map
//         if(!rst_n) begin
//             wen_w<=1;
//             D_W<=0;
//             AddrW<=0;
//         end
//         else begin
//             if(rvalid_m_inf&&CS_PREADSD)begin
//                 wen_w<=0;//fill it in
//                 AddrW<=ctr;
//                 D_W<=rdata_m_inf;
//             end else begin 
//                 wen_w<=1;
//                 AddrW<=0;
//                 D_W<=0;
//             end
//         end
//     end
// //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Data Register<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// reg [1:0] map_state_nxt [0:63][0:63];  // 0:empty, 1: Blocked, 2:state_1, 3:state_2
// reg [1:0] map_state_r [0:63][0:63];  // 0:empty, 1: Blocked.
// reg [13:0] total_cost;
// parameter sourcex=15,sourcey=5,destx=39,desty=48;
// reg [1:0] direction;
// wire [5:0] curr_x,curr_y;
// reg [5:0] next_x,next_y;
// wire L_flag=map_state_r[curr_x][curr_y-1]==2;
// wire U_flag=map_state_r[curr_x-1][curr_y]==2;
// wire D_flag=map_state_r[curr_x+1][curr_y]==2;
// wire R_flag=map_state_r[curr_x][curr_y+1]==2;

// wire S_L=(map_state_nxt[curr_x][curr_y]==3&&map_state_nxt[curr_x][curr_y-1]==2)||(map_state_nxt[curr_x][curr_y]==2&&map_state_nxt[curr_x][curr_y-1]==1)||(map_state_nxt[curr_x][curr_y]==1&&map_state_nxt[curr_x][curr_y-1]==0);//||(map_state_nxt[curr_x][curr_y]==4&&map_state_nxt[curr_x][curr_y-1]==0);
// wire S_U=(map_state_nxt[curr_x][curr_y]==3&&map_state_nxt[curr_x-1][curr_y]==2)||(map_state_nxt[curr_x][curr_y]==2&&map_state_nxt[curr_x-1][curr_y]==1)||(map_state_nxt[curr_x][curr_y]==1&&map_state_nxt[curr_x-1][curr_y]==0);//||(map_state_nxt[curr_x][curr_y]+1==4&&map_state_nxt[curr_x-1][curr_y]==0);
// wire S_D=(map_state_nxt[curr_x][curr_y]==3&&map_state_nxt[curr_x+1][curr_y]==2)||(map_state_nxt[curr_x][curr_y]==2&&map_state_nxt[curr_x+1][curr_y]==1)||(map_state_nxt[curr_x][curr_y]==1&&map_state_nxt[curr_x+1][curr_y]==0);//||(map_state_nxt[curr_x][curr_y]+1==4&&map_state_nxt[curr_x][curr_y+1]==0);
// wire S_R=(map_state_nxt[curr_x][curr_y]==3&&map_state_nxt[curr_x][curr_y+1]==2)||(map_state_nxt[curr_x][curr_y]==2&&map_state_nxt[curr_x][curr_y+1]==1)||(map_state_nxt[curr_x][curr_y]==1&&map_state_nxt[curr_x][curr_y+1]==0);//||(map_state_nxt[curr_x][curr_y]==4&&map_state_nxt[curr_x][curr_y-1]==0);
// //assign cost = total_cost;
// always@(posedge clk or negedge rst_n)begin//map_state_r
//     if(!rst_n)begin 
//             for(i=0;i<64;i=i+1)begin 
//                 for(j=0;j<64;j=j+1)begin 
//                     map_state_r[i][j] = 0;
//                 end
//             end
//         end else begin 
//          case(curr_state)
//             READ: begin
//                if(ctr>128) begin 
//                 for(i=0;i<64;i=i+1)begin 
//                     for(j=0;j<64;j=j+1)begin 
//                         map_state_r[i][j] = map_state_r[i][j];
//                     end
//                 end
//                end else begin 
//                     for(i=0;i<64;i=i+1)begin 
//                         for(j=0;j<64;j=j+1)begin 
//                             map_state_r[i][j] = map_state_nxt[i][j];
//                         end
//                     end
//                end
//             end
//             PREADSD: begin
//                 //   if (CS_PREADSD&&ctr==2) begin 
//                 //     if(map_state_nxt[sourcex+1][sourcey]==0)begin 
//                 //     map_state_nxt[sourcex+1][sourcey]=0;
//                 //     map_state_r[sourcex+1][sourcey]=2;
//                 //     end   
//                 //     if(map_state_nxt[sourcex-1][sourcey]==0)begin
//                 //     map_state_nxt[sourcex-1][sourcey]=0;
//                 //     map_state_r[sourcex-1][sourcey]=2;
//                 //     end if(map_state_nxt[sourcex][sourcey+1]==0)begin 
//                 //     map_state_nxt[sourcex][sourcey+1]=0;
//                 //     map_state_r[sourcex][sourcey+1]=2;
//                 //     end if(map_state_nxt[sourcex][sourcey-1]==0)begin
//                 //     map_state_nxt[sourcex][sourcey-1]=0;
//                 //     map_state_r[sourcex][sourcey-1]=2;
//                 //     end 
//                   //end else
//                    if(ctr==4)begin //RETRACT 
//                     if(D_flag)begin 
//                         map_state_r[next_x+1][next_y]=1;
//                         $display("D_flag,ctr%d",ctr);
//                     end else if(U_flag)begin 
//                         map_state_r[next_x-1][next_y]=1;
//                         $display("U_flag,ctr%d",ctr);
//                     end else if(R_flag)begin 
//                         map_state_r[next_x][next_y+1]=1;
//                         $display("R_flag,ctr%d",ctr);
//                     end else if(L_flag)begin 
//                         map_state_r[next_x][next_y-1]=1;
//                         $display("L_flag,ctr%d",ctr);
//                     end else begin 
//                         map_state_r[next_x][next_y]=1;
//                         $display("else,ctr%d",ctr);
//                     end
//                 end else if(ctr>4&&ctr<10)begin 
//                         if(D_flag&&S_D)begin 
//                             map_state_r[next_x+1][next_y]=1;
//                         end else if(U_flag&&S_U)begin 
//                             map_state_r[next_x-1][next_y]=1;
//                         end else if(R_flag&&S_R)begin 
//                             map_state_r[next_x][next_y+1]=1;
//                         end else if(L_flag&&S_L)begin 
//                             map_state_r[next_x][next_y-1]=1;
//                         end else begin 
//                             map_state_r[next_x][next_y]=1;
//                         end
//                 end
//             end
//             default:      begin           
//                 for(i=0;i<64;i=i+1)begin 
//                     for(j=0;j<64;j=j+1)begin 
//                         map_state_r[i][j] = map_state_r[i][j];
//                     end
//                 end
//             end
//          endcase
//         end
// end

// always @(*) begin
//     if(CS_Idle&&ctr==0)begin 
//         for(i=0;i<64;i=i+1)begin 
//             for(j=0;j<64;j=j+1)begin 
//                 map_state_nxt[i][j] = 0;
//             end
//         end
//     end else if (CS_Read&&rvalid_m_inf) begin
//         for(i=32;i<64;i=i+1)
// 			map_state_nxt[63][i] = {1'b0,|rdata_m_inf[(i-32)*4 +: 4]};

// 		for(i=0;i<63;i=i+1)
// 			for(j=0;j<32;j=j+1)
// 				map_state_nxt[i][j]  = map_state_r[i][j+32];
// 		for(i=0;i<63 ;i=i+1)
// 			for(j=32;j<64;j=j+1)
// 				map_state_nxt[i][j] = map_state_r[i+1][j-32];
// 		for(i=0;i<32;i=i+1)
// 			map_state_nxt[63][i] = map_state_r[63][i+32];
//     end else if (CS_PREADSD&&ctr==1) begin
//         //if value is one set it as 3 
//         for(i=0;i<64;i=i+1)
//             for(j=0;j<64;j=j+1)
//                 if(map_state_r[i][j]==1)
//                     map_state_nxt[i][j] = 3;
//                 else
//                     map_state_nxt[i][j] = map_state_r[i][j];
//     end else if (CS_PREADSD&&ctr==2) begin 
//         //put one around the source
//         if(map_state_nxt[sourcex+1][sourcey]==0)begin 
//         map_state_nxt[sourcex+1][sourcey]=0;
//         map_state_r[sourcex+1][sourcey]=2;
//         end   
//         if(map_state_nxt[sourcex-1][sourcey]==0)begin
//         map_state_nxt[sourcex-1][sourcey]=0;
//         map_state_r[sourcex-1][sourcey]=2;
//         end if(map_state_nxt[sourcex][sourcey+1]==0)begin 
//         map_state_nxt[sourcex][sourcey+1]=0;
//         map_state_r[sourcex][sourcey+1]=2;
//         end if(map_state_nxt[sourcex][sourcey-1]==0)begin
//         map_state_nxt[sourcex][sourcey-1]=0;
//         map_state_r[sourcex][sourcey-1]=2;
//         end 
//         map_state_r[sourcex][sourcey]=2;
//     end else if(CS_PREADSD&&ctr==3)begin 
//         for (i = 0; i < 64; i = i + 1) begin 
//             for (j = 0; j < 64; j = j + 1) begin 
//                 if(map_state_r[i][j]==2)begin
//                    // map_state_r[i][j]<=3;
//                     if(map_state_r[i][j+1]==0)begin
//                         map_state_nxt[i][j+1]=map_state_nxt[i][j]+1;
//                         map_state_r[i][j+1]=2;
//                     end 
//                     else if(map_state_r[i][j-1]==0)begin 
//                         map_state_nxt[i][j-1]=map_state_nxt[i][j]+1;
//                         map_state_r[i][j-1]=2;
//                     end
//                     else if(map_state_r[i+1][j]==0)begin 
//                         map_state_nxt[i+1][j]=map_state_nxt[i][j]+1;
//                         map_state_r[i+1][j]=2;
//                     end
//                     else if(map_state_r[i-1][j]==0)begin 
//                         map_state_nxt[i-1][j]=map_state_nxt[i][j]+1;
//                         map_state_r[i-1][j]=2;
//                     end
//                 end
//             end
//         end

//     // end else if(CS_PREADSD&&ctr>4&&ctr<8)begin
//     //         if(D_flag&&S_D)begin 
//     //             map_state_r[next_x+1][next_y]=1;
//     //         end else if(U_flag&&S_U)begin 
//     //             map_state_r[next_x-1][next_y]=1;
//     //         end else if(R_flag&&S_R)begin 
//     //             map_state_r[next_x][next_y+1]=1;
//     //         end else if(L_flag&&S_L)begin 
//     //             map_state_r[next_x][next_y-1]=1;
//     //         end else begin 
//     //             map_state_r[next_x][next_y]=1;
//     //   end
//         //   $display("curr_x=%d curr_y=%d",curr_x,curr_y);
//         //       $display("S_L= %d", S_L);  
//         //       $display("S_U= %d", S_U);
//         //         $display("S_R= %d", S_R);
//         //         $display("S_D= %d", S_D);

//         //         $display("D_flag= %d", D_flag);
//         //         $display("U_flag= %d", U_flag);
//         //         $display("R_flag= %d", R_flag);
//         //         $display("L_flag= %d", L_flag);
//     end else begin
//         for(i=0;i<64;i=i+1)
//             for(j=0;j<64;j=j+1) begin 
//                 map_state_nxt[i][j] = map_state_nxt[i][j];
//             //    map_state_r[i][j] = map_state_r[i][j];
//             end
//     end
// end



// always @(posedge clk or negedge rst_n) begin//nxt_x_nxt_y
//     if(!rst_n) begin
//         next_x<=0;
//         next_y<=0;
//     end
//     else begin
//         if(CS_Idle&&ctr==0)begin
//             next_x<=0;
//             next_y<=0;
//         end else if (CS_Read&&ctr==0)begin 
//             next_x=destx;
//             next_y=desty;
//         end else if(CS_PREADSD&&ctr==4)begin 
//             if(D_flag)begin 
//                 next_x<=next_y+1;
//             end else if(U_flag)begin 
//                 next_x<=next_y-1;
//             end else if(R_flag)begin 
//                 next_y<=next_y+1;
//             end else if(L_flag)begin 
//                 next_y<=next_y-1;
//             end else begin 
//                 next_y<=next_y;
//                 next_x<=next_x;
//             end
//         end else if(CS_PREADSD&&ctr>4&&ctr<8)begin
//             if(D_flag&&S_D)begin 
//                 next_x<=next_x+1;
//             end else if(U_flag&&S_U)begin 
//                 next_x<=next_x-1;
//             end else if(R_flag&&S_R)begin 
//                 next_y<=next_y+1;
//             end else if(L_flag&&S_L)begin 
//                 next_y<=next_y-1;
//             end else begin 
//                 next_x<=next_x;
//                 next_y<=next_y;
//       end
//         end else begin 
//             next_x<=next_x;
//             next_y<=next_y;
//         end
// end
// end
// //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OUT<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//     always@(posedge clk or negedge rst_n)begin//cost
//         if(!rst_n)begin 
//             cost<=0;
//         end else if(CS_Input)begin 
//             cost<=0;
//         end
//     end
//     //  code tipatnean
//     // reg [4:0] frame_id_r;
//     // reg [3:0] net_id_r [0:14];
//     // reg [5:0] source_x_r [0:14];
//     // reg [5:0] source_y_r [0:14];
//     // reg [5:0] sink_x_r [0:14];
//     // reg [5:0] sink_y_r [0:14];


//     // wire [5:0] source_x, source_x_nxt;
//     // wire [5:0] source_y, source_y_nxt;
//     // wire [5:0] sink_x;
//     // wire [5:0] sink_y;
//     // assign source_x_nxt = source_x_r[process_num_nxt];
//     // assign source_y_nxt = source_y_r[process_num_nxt];
//     // assign source_x   = source_x_r[process_num];
//     // assign source_y   = source_y_r[process_num];
//     // assign sink_x     = sink_x_r[process_num];
//     // assign sink_y     = sink_y_r[process_num];

// endmodule