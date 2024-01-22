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

parameter DSIZE = WIDTH;
parameter ASIZE = $clog2(WORDS);
parameter MEM_SIZE = 2**ASIZE;

input wclk, rclk;
input rst_n;

input      [WIDTH-1:0] wdata;
output reg [WIDTH-1:0] rdata;
output wfull;
output rempty;
input  winc; 
input  rinc;

// You can change the input / output of the custom flag ports
output clk2_fifo_flag1;//whitlblower for idle
input clk2_fifo_flag2;
output clk2_fifo_flag3;
output clk2_fifo_flag4;

output fifo_clk3_flag1;
input fifo_clk3_flag2;
output fifo_clk3_flag3;
output fifo_clk3_flag4;
reg [WIDTH-1:0] rdata_q;



reg [ASIZE-1:0] r_wr_ptr,r_wr_ptr_rd_sync_int,r_wr_ptr_rd_sync;
reg [ASIZE-1:0] r_rd_ptr,r_rd_ptr_wr_sync_int,r_rd_ptr_wr_sync;
reg [DSIZE-1:0] ex_mem [0:2**ASIZE-1];

integer i;
wire [ASIZE-1:0] w_wr_ptr_grey,w_rd_ptr_grey;

//binary to ger conversion
assign w_wr_ptr_grey = wptr ^ (wptr >> 1);
assign w_rd_ptr_grey = rptr ^ (rptr >> 1);

//full contion check in grey code we match first two MSB　ｂｉｔｓ　ｔｏ　ｂｂｅ　ｉｎｖｅｒｓｅ　ｏｆ　ｅａｃｈ　ｏｔｈｅｒ
assign wfull =(r_rd_ptr_wr_sync[ASIZE:0]=={(~w_wr_ptr_grey[ASIZE:(ASIZE-1)],w_wr_ptr_grey[(ASIZE-1):0])}) ? 1'b1 : 1'b0;
//for empty both should be equall for it to be empty
assign rempty =(w_rd_ptr_grey==w_wr_ptr_grey) ? 1'b1 : 1'b0;

//in write clock domain 
always @(posedge wclk or negedge rst_n)
begin
    if(~rst_n) begin
         r_rd_ptr_wr_sync_int <=0;
         r_wr_ptr_rd_sync_int <=0;     
    end else begin //double flop sync of read pointer in write clock domain to check full condition
        r_rd_ptr_wr_sync <= r_rd_ptr_wr_sync_int;
        r_wr_ptr_wr_sync_int <= w_rd_ptr_grey;
        if(~wfull&& winc) //never write in a full FIFO
        begin
            wptr <= wptr + 1;
        end 
    end
end

//in read clock domain
always @(posedge rclk or negedge rst_n) begin 
  if(~rst_n) begin
    r_wr_ptr_rd_sync_int <=0;
    r_rd_ptr_wr_sync_int <=0;
  end 
  else begin //double flop sync of write pointer in read clock domain to check empty condition
    r_wr_ptr_rd_sync <= r_wr_ptr_rd_sync_int;
    r_rd_ptr_wr_sync_int <= w_wr_ptr_grey;
    if(~rempty && rinc) //never read from an empty FIFO
    begin
      rdata <= rdata_q;
      rptr <= rptr + 1;
    end 
  end
end 
wire write_enabl=~(wfull&& winc);
DUAL_64X32X1BM1 u_dual_sram (
    .CKA(wclk),
    .CKB(rclk),
    .WEAN(write_enabl),//controls write
    .WEBN(1'b1),//controls read
    .CSA(1'b1),
    .CSB(1'b1),
    .OEA(1'b1),
    .OEB(1'b1),
    .A0(wptr[0]),
    .A1(wptr[1]),
    .A2(wptr[2]),
    .A3(wptr[3]),
    .A4(wptr[4]),
    .A5(wptr[5]),
    .B0(rptr[0]),
    .B1(rptr[1]),
    .B2(rptr[2]),
    .B3(rptr[3]),
    .B4(rptr[4]),
    .B5(rptr[5]),
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
    .DIB0(0),
    .DIB1(0),
    .DIB2(0),
    .DIB3(0),
    .DIB4(0),
    .DIB5(0),
    .DIB6(0),
    .DIB7(0),
    .DIB8(0),
    .DIB9(0),
    .DIB10(0),
    .DIB11(0),
    .DIB12(0),
    .DIB13(0),
    .DIB14(0),
    .DIB15(0),
    .DIB16(0),
    .DIB17(0),
    .DIB18(0),
    .DIB19(0),
    .DIB20(0),
    .DIB21(0),
    .DIB22(0),
    .DIB23(0),
    .DIB24(0),
    .DIB25(0),
    .DIB26(0),
    .DIB27(0),
    .DIB28(0),
    .DIB29(0),
    .DIB30(0),
    .DIB31(0),
    .DOB0(rdata_q[0]),
    .DOB1(rdata_q[1]),
    .DOB2(rdata_q[2]),
    .DOB3(rdata_q[3]),
    .DOB4(rdata_q[4]),
    .DOB5(rdata_q[5]),
    .DOB6(rdata_q[6]),
    .DOB7(rdata_q[7]),
    .DOB8(rdata_q[8]),
    .DOB9(rdata_q[9]),
    .DOB10(rdata_q[10]),
    .DOB11(rdata_q[11]),
    .DOB12(rdata_q[12]),
    .DOB13(rdata_q[13]),
    .DOB14(rdata_q[14]),
    .DOB15(rdata_q[15]),
    .DOB16(rdata_q[16]),
    .DOB17(rdata_q[17]),
    .DOB18(rdata_q[18]),
    .DOB19(rdata_q[19]),
    .DOB20(rdata_q[20]),
    .DOB21(rdata_q[21]),
    .DOB22(rdata_q[22]),
    .DOB23(rdata_q[23]),
    .DOB24(rdata_q[24]),
    .DOB25(rdata_q[25]),
    .DOB26(rdata_q[26]),
    .DOB27(rdata_q[27]),
    .DOB28(rdata_q[28]),
    .DOB29(rdata_q[29]),
    .DOB30(rdata_q[30]),
    .DOB31(rdata_q[31])
);
endmodule 