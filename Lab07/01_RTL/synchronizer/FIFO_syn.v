module FIFO_syn #(parameter WIDTH=32, parameter WORDS=64) (
    wclk,
    rclk,
    rst_n,
    winc,
    wdata,
    wfull,
    rinc,
    rdata,
    rempty,

    clk2_fifo_flag1,
    clk2_fifo_flag2,
    clk2_fifo_flag3,
    clk2_fifo_flag4,

    fifo_clk3_flag1,
    fifo_clk3_flag2,
    fifo_clk3_flag3,
    fifo_clk3_flag4
);

input wclk, rclk;
input rst_n;
input winc;
input [WIDTH-1:0] wdata;
output  wfull;
input rinc;
output reg [WIDTH-1:0] rdata;
output  rempty;

// You can change the input / output of the custom flag ports
output clk2_fifo_flag1;
input clk2_fifo_flag2;
output clk2_fifo_flag3;
output clk2_fifo_flag4;

output reg fifo_clk3_flag1;
input fifo_clk3_flag2;
output fifo_clk3_flag3;
output fifo_clk3_flag4;

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Variable declarations <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
wire [$clog2(WORDS):0]r2w_rptr, w2r_wptr;
wire [$clog2(WORDS):0]r2w_rptr_inv, w2r_wptr_inv, rptr_inv, wptr_inv;
wire [$clog2(WORDS):0] wptr_gray;
wire [$clog2(WORDS):0] rptr_gray;
wire [WIDTH-1:0] mydata;
wire [31:0] init_= 0;
wire b_wen;
reg [$clog2(WORDS)+1:0] waddr;
reg [$clog2(WORDS):0] raddr;
wire _is_in_play=waddr[7:0] != 0 && !wfull;
wire _is_not_in_play=waddr[7:0] == 0 && winc && !wfull;
reg W;
// Remember: 
//   wptr and rptr should be gray coded
//   Don't modify the signal name
reg [$clog2(WORDS):0] wptr;
reg [$clog2(WORDS):0] rptr;
assign clk2_fifo_flag1 = winc;
assign w2r_wptr_inv[$clog2(WORDS)] = w2r_wptr[$clog2(WORDS)];
assign w2r_wptr_inv[$clog2(WORDS)-1] = w2r_wptr[$clog2(WORDS)] ^ w2r_wptr[$clog2(WORDS)-1];
assign w2r_wptr_inv[$clog2(WORDS)-2:0] = w2r_wptr[$clog2(WORDS)-2:0];
assign r2w_rptr_inv[$clog2(WORDS)] = r2w_rptr[$clog2(WORDS)];
assign r2w_rptr_inv[$clog2(WORDS)-1] = r2w_rptr[$clog2(WORDS)] ^ r2w_rptr[$clog2(WORDS)-1];
assign r2w_rptr_inv[$clog2(WORDS)-2:0] = r2w_rptr[$clog2(WORDS)-2:0];
assign wptr_inv[$clog2(WORDS)] = wptr[$clog2(WORDS)];
assign wptr_inv[$clog2(WORDS)-1] = wptr[$clog2(WORDS)] ^ wptr[$clog2(WORDS)-1];
assign wptr_inv[$clog2(WORDS)-2:0] = wptr[$clog2(WORDS)-2:0];
assign rptr_inv[$clog2(WORDS)] = rptr[$clog2(WORDS)];
assign rptr_inv[$clog2(WORDS)-1] = rptr[$clog2(WORDS)] ^ rptr[$clog2(WORDS)-1];
assign rptr_inv[$clog2(WORDS)-2:0] = rptr[$clog2(WORDS)-2:0];
assign wfull= {~r2w_rptr_inv[$clog2(WORDS)], r2w_rptr_inv[$clog2(WORDS)-1:0]} == wptr_inv;
assign rempty= w2r_wptr_inv == rptr_inv;

always@(posedge rclk, negedge rst_n)begin
    if(!rst_n)begin
        fifo_clk3_flag1 <= 0;
    end else begin
        fifo_clk3_flag1 <= ~rempty;
    end
end

always @(posedge rclk, negedge rst_n) begin
    if(!rst_n)begin
        rdata <= 0;
    end else begin
        if (rinc || fifo_clk3_flag1)begin
            rdata <= mydata;
        end
    end
end


always@(*)begin
    wptr = bin2gray_func(waddr[$clog2(WORDS):0]);
end
always@(*)begin
    rptr =  bin2gray_func(raddr);
end

//fifo full

always@(posedge wclk, negedge rst_n)begin
    if(!rst_n)begin
        waddr <= 0;
    end else begin
        if(_is_not_in_play)begin
            waddr <= waddr + 8'd1;
        end else if(_is_in_play)begin
            waddr <= waddr + 8'd1;
        end
    end
end
always@(*)begin
    if(wfull)begin
        W = 1'b1;
    end else if(waddr[7:0] == 0)begin
        if(winc)begin
            W = 'd0;
        end else begin
            W = 1'b1;
        end
    end else begin
        W = 'd0;
    end
end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>READ<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
always@(posedge rclk, negedge rst_n)begin
    if(!rst_n)begin
        raddr <= 0;
    end else begin
        if(rinc && !rempty)begin
            raddr <= raddr + 1'b1;
        end
    end
end
DUAL_64X32X1BM1 u_dual_sram (
    .CKA(wclk),
    .CKB(rclk),
    .WEAN(W),
    .WEBN(1'b1),
    .CSA(1'b1),
    .CSB(1'b1),
    .OEA(1'b1),
    .OEB(1'b1),
    .A0(waddr[0]),
    .A1(waddr[1]),
    .A2(waddr[2]),
    .A3(waddr[3]),
    .A4(waddr[4]),
    .A5(waddr[5]),
    .B0(raddr[0]),
    .B1(raddr[1]),
    .B2(raddr[2]),
    .B3(raddr[3]),
    .B4(raddr[4]),
    .B5(raddr[5]),
    .DIA0(wdata[0]),
    .DIA1(wdata[1]),
    .DIA2(wdata[2]),
    .DIA3(wdata[3]),
    .DIA4(wdata[4]),
    .DIA5(wdata[5]),
    .DIA6(wdata[6]),
    .DIA7(wdata[7]),
    .DIA8(wdata[8]),
    .DIA9(wdata[9]),
    .DIA10(wdata[10]),
    .DIA11(wdata[11]),
    .DIA12(wdata[12]),
    .DIA13(wdata[13]),
    .DIA14(wdata[14]),
    .DIA15(wdata[15]),
    .DIA16(wdata[16]),
    .DIA17(wdata[17]),
    .DIA18(wdata[18]),
    .DIA19(wdata[19]),
    .DIA20(wdata[20]),
    .DIA21(wdata[21]),
    .DIA22(wdata[22]),
    .DIA23(wdata[23]),
    .DIA24(wdata[24]),
    .DIA25(wdata[25]),
    .DIA26(wdata[26]),
    .DIA27(wdata[27]),
    .DIA28(wdata[28]),
    .DIA29(wdata[29]),
    .DIA30(wdata[30]),
    .DIA31(wdata[31]),
    .DIB0(init_[0]),
    .DIB1(init_[1]),
    .DIB2(init_[2]),
    .DIB3(init_[3]),
    .DIB4(init_[4]),
    .DIB5(init_[5]),
    .DIB6(init_[6]),
    .DIB7(init_[7]),
    .DIB8(init_[8]),
    .DIB9(init_[9]),
    .DIB10(init_[10]),
    .DIB11(init_[11]),
    .DIB12(init_[12]),
    .DIB13(init_[13]),
    .DIB14(init_[14]),
    .DIB15(init_[15]),
    .DIB16(init_[16]),
    .DIB17(init_[17]),
    .DIB18(init_[18]),
    .DIB19(init_[19]),
    .DIB20(init_[20]),
    .DIB21(init_[21]),
    .DIB22(init_[22]),
    .DIB23(init_[23]),
    .DIB24(init_[24]),
    .DIB25(init_[25]),
    .DIB26(init_[26]),
    .DIB27(init_[27]),
    .DIB28(init_[28]),
    .DIB29(init_[29]),
    .DIB30(init_[30]),
    .DIB31(init_[31]),
    .DOB0(mydata[0]),
    .DOB1(mydata[1]),
    .DOB2(mydata[2]),
    .DOB3(mydata[3]),
    .DOB4(mydata[4]),
    .DOB5(mydata[5]),
    .DOB6(mydata[6]),
    .DOB7(mydata[7]),
    .DOB8(mydata[8]),
    .DOB9(mydata[9]),
    .DOB10(mydata[10]),
    .DOB11(mydata[11]),
    .DOB12(mydata[12]),
    .DOB13(mydata[13]),
    .DOB14(mydata[14]),
    .DOB15(mydata[15]),
    .DOB16(mydata[16]),
    .DOB17(mydata[17]),
    .DOB18(mydata[18]),
    .DOB19(mydata[19]),
    .DOB20(mydata[20]),
    .DOB21(mydata[21]),
    .DOB22(mydata[22]),
    .DOB23(mydata[23]),
    .DOB24(mydata[24]),
    .DOB25(mydata[25]),
    .DOB26(mydata[26]),
    .DOB27(mydata[27]),
    .DOB28(mydata[28]),
    .DOB29(mydata[29]),
    .DOB30(mydata[30]),
    .DOB31(mydata[31])
);
function [6:0] bin2gray_func;
    input [6:0] bin;
    integer i;
    reg [6:0] gray;
    for (i = 0; i < 6; i = i + 1) begin
        gray[i] = bin[i] ^ bin[i+1];
    end
    gray[6] = bin[6];
    return gray;
endfunction

NDFF_BUS_syn #(.WIDTH(7)) fsdfsgp(.D(wptr), .Q(w2r_wptr), .clk(rclk), .rst_n(rst_n));
NDFF_BUS_syn #(.WIDTH(7)) sdfgrw(.D(rptr), .Q(r2w_rptr), .clk(wclk), .rst_n(rst_n));
endmodule