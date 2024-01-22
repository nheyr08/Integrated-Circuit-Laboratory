`include "synchronizer/NDFF_BUS_syn.v"//!remember to remove
`include "synchronizer/PULSE_syn.v"
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

input [WIDTH-1:0] wdata;
output  wfull;
input winc; 
input rinc;
output reg [WIDTH-1:0] rdata;
output reg rempty;

// You can change the input / output of the custom flag ports
input clk2_fifo_flag1;
input clk2_fifo_flag2;
output clk2_fifo_flag3;
output clk2_fifo_flag4;

input fifo_clk3_flag1;
input fifo_clk3_flag2;
output fifo_clk3_flag3;
output fifo_clk3_flag4;

wire [WIDTH-1:0] rdata_q;
reg [WIDTH-1:0] wdata_;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>declarations<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    reg [3:0] i, j;
    genvar idx, jdx;
    reg write_enable;
    parameter EMPTY = 'd0, WRITE = 'd1, READ = 'd2, FULL = 'd3;
    parameter EMPTY_r = 'd0, WRITE_r = 'd1, READ_r = 'd2, FULL_r = 'd3;
    reg [2:0] c_state ,n_state_r, c_state_r, n_state;
    wire CS_READ = c_state == READ, CS_EMPTY = c_state == EMPTY, CS_FULL = c_state == FULL, CS_WRITE = c_state == WRITE;
    wire CS_READ_r = c_state_r == READ_r, CS_EMPTY_r = c_state_r == EMPTY_r, CS_FULL_r = c_state_r == FULL_r, CS_WRITE_r = c_state_r == WRITE_r;
    reg [7:0] ctrbr;
    reg [$clog2(WORDS):0] rptr_before_gray,rptr_before_gray1;
            //   Don't modify the signal name
    reg [$clog2(WORDS):0] wptr,wptr_before_gray;
    reg [$clog2(WORDS):0] rptr,rptr_gray;
    reg [$clog2(WORDS):0] wptr_gray_q;
    reg [6:0]wptreal;
    reg [6:0] mywptr;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) c_state <= EMPTY;
        else c_state <= n_state;
    end
    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) wdata_ = 0;
        else
        if(winc) wdata_ = wdata;
    end

    always@(*) begin
        n_state = c_state;
        case(c_state)
            EMPTY: if(winc) n_state = WRITE;
            WRITE: if(ctrbr==512) n_state = EMPTY;
                    else n_state = WRITE; 
            default: n_state = EMPTY;
        endcase
    end
    //ctrbr
    always @(posedge wclk or negedge rst_n) begin
        if (!rst_n) 
            ctrbr <= 3'b0;
        else begin
            if (n_state != c_state) ctrbr <= 8'b0;
            else begin
                if (winc) ctrbr <= ctrbr + 1;
                else if (c_state == EMPTY) ctrbr <= 0;
                else ctrbr <= 0;
            end
        end
    end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>read fsm2<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    always@(posedge rclk or negedge rst_n) begin
        if(!rst_n) c_state_r <= EMPTY_r;
        else c_state_r <= n_state_r;
    end
    always@(*) begin//status
        n_state_r = c_state_r;
        case(c_state_r)
            EMPTY_r: if(winc) n_state_r = WRITE_r;
            WRITE_r: if(ctrbr==512) n_state_r = READ_r;
            READ_r: if(wfull) n_state_r = FULL_r;
            FULL_r: if(rempty) n_state_r = EMPTY_r;
            default: n_state_r = EMPTY_r;
        endcase
    end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>First Flop instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    //flip flops
    always@(posedge wclk or negedge rst_n) begin//mywptr not in use
        if(!rst_n) begin
            mywptr <= 0;
        end
        else begin
            if(CS_WRITE)begin   
            mywptr<=wptr;
            end else begin 
                mywptr <= mywptr;
            end 
        end

    end
        always@(posedge rclk or negedge rst_n) begin
        if(!rst_n) begin
            wptreal <= 0;
        end
        else begin
            if(winc||CS_WRITE_r&&wdata!=wdata_)begin  
                wptreal<=wptreal+1;
            end else begin 
                wptreal <=wptreal;
            end 
        end

    end
    always@( posedge wclk or negedge rst_n) begin//wptrbeforegray
        if(!rst_n) begin
            wptr_before_gray <= 0;
            wptr=0;
        end else begin
            if(CS_EMPTY&&!winc)begin 
                        wptr=0;
                        wptr_before_gray = 0;
            end else if(winc||CS_WRITE)begin
                        //perform binary to gray encoding
                        wptr <= bin2gray_func(wptr_before_gray);
                        wptr_before_gray<=wptreal;    
            end
        end
    end
    wire fifo_empty,fifo_full;
    wire [31:0] rptr_gray_q;
    assign fifo_empty=(wptr==rptr);
    assign fifo_full=(wptr==rptr+1);
    NDFF_BUS_syn look (
        .D (wptr),
        .clk (rclk),
        .Q (wptr_gray_q),
        .rst_n (rst_n)
    );
    //other flop
    NDFF_BUS_syn lookback (
        .D (rptr),
        .clk (wclk),
        .Q (rptr_gray_q),
        .rst_n (rst_n)
    );
    always@(posedge rclk or negedge rst_n) begin
        if(!rst_n) begin
            rptr <= 0;
        end
        else begin
            if(CS_IDLE) rptr <= 0;
            else if(CS_READ)begin   
                rptr<=bin2gray_func(rptr_before_gray);
            end else begin 
                rptr<=rptr;
            end 
        end
    end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Rd-ptr Binary to gray encoding<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

reg [31:0]ReadData,ReadData1;
always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rptr_before_gray <= 0;
    end else begin
         if(rinc)begin       
                rptr_before_gray<=g2binary(wptr_gray_q);
                $display("rptr_before_gray=%d",rptr_before_gray);
        end
    end
end
assign rempty=(wptr_before_gray==rptr_before_gray);
assign wfull=0;//(wptr_before_gray==rptr_before_gray+1);
always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rptr_before_gray1 <= 0;
        ReadData1<=0;
    end
    else begin
        if(CS_READ_r)begin   
            rptr_before_gray1<=rptr_before_gray;
            ReadData1<=rdata_q;
        end else begin 
            rptr_before_gray1 <= rptr_before_gray1;
        end 
    end
end
//Write Operation: Increment wptr after writing data into the FIFO.
//Read Operation: Increment rptr after reading data from the FIFO.
//2 stage sync
//gray to binary of result from sync
//wrptr rdclk
//compare rdclk and wrclk


//pass rptr and wptr to gray_to_binary module
// gray_to_binary #(.WORDS(WORDS)) u_gray_to_binary (
//  Add one more register stage to rdata
wire write_enabl=(winc)&&(wdata!=wdata_);

always @(posedge rclk) begin
    if (rinc)
        rdata <= rdata_q;
end
DUAL_64X32X1BM1 u_dual_sram (
    .CKA(wclk),
    .CKB(rclk),
    .WEAN(write_enabl),//controls write
    .WEBN(1'b1),//controls read
    .CSA(1'b1),
    .CSB(1'b1),
    .OEA(1'b1),
    .OEB(1'b1),
    .A0(wptreal[0]),
    .A1(wptreal[1]),
    .A2(wptreal[2]),
    .A3(wptreal[3]),
    .A4(wptreal[4]),
    .A5(wptreal[5]),
    .B0(rptr_before_gray[0]),
    .B1(rptr_before_gray[1]),
    .B2(rptr_before_gray[2]),
    .B3(rptr_before_gray[3]),
    .B4(rptr_before_gray[4]),
    .B5(rptr_before_gray[5]),
    .DIA0(wdata_[0]),
    .DIA1(wdata_[1]),
    .DIA2(wdata_[2]),
    .DIA3(wdata_[3]),
    .DIA4(wdata_[4]),
    .DIA5(wdata_[5]),
    .DIA6(wdata_[6]),
    .DIA7(wdata_[7]),
    .DIA8(wdata_[8]),
    .DIA9(wdata_[9]),
    .DIA10(wdata_[10]),
    .DIA11(wdata_[11]),
    .DIA12(wdata_[12]),
    .DIA13(wdata_[13]),
    .DIA14(wdata_[14]),
    .DIA15(wdata_[15]),
    .DIA16(wdata_[16]),
    .DIA17(wdata_[17]),
    .DIA18(wdata_[18]),
    .DIA19(wdata_[19]),
    .DIA20(wdata_[20]),
    .DIA21(wdata_[21]),
    .DIA22(wdata_[22]),
    .DIA23(wdata_[23]),
    .DIA24(wdata_[24]),
    .DIA25(wdata_[25]),
    .DIA26(wdata_[26]),
    .DIA27(wdata_[27]),
    .DIA28(wdata_[28]),
    .DIA29(wdata_[29]),
    .DIA30(wdata_[30]),
    .DIA31(wdata_[31]),
    .DIB0(rdata[0]),
    .DIB1(rdata[1]),
    .DIB2(rdata[2]),
    .DIB3(rdata[3]),
    .DIB4(rdata[4]),
    .DIB5(rdata[5]),
    .DIB6(rdata[6]),
    .DIB7(rdata[7]),
    .DIB8(rdata[8]),
    .DIB9(rdata[9]),
    .DIB10(rdata[10]),
    .DIB11(rdata[11]),
    .DIB12(rdata[12]),
    .DIB13(rdata[13]),
    .DIB14(rdata[14]),
    .DIB15(rdata[15]),
    .DIB16(rdata[16]),
    .DIB17(rdata[17]),
    .DIB18(rdata[18]),
    .DIB19(rdata[19]),
    .DIB20(rdata[20]),
    .DIB21(rdata[21]),
    .DIB22(rdata[22]),
    .DIB23(rdata[23]),
    .DIB24(rdata[24]),
    .DIB25(rdata[25]),
    .DIB26(rdata[26]),
    .DIB27(rdata[27]),
    .DIB28(rdata[28]),
    .DIB29(rdata[29]),
    .DIB30(rdata[30]),
    .DIB31(rdata[31]),
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
// function [31:0] binary_to_gray;
//     input [31:0] binary;
//     begin
//         binary_to_gray = binary ^ (binary >> 1);
//     end
// endfunction

// function [:0] gray_to_binary;
//     input [31:0] gray;
//     begin
//         gray_to_binary = gray;
//         for (int i = 1; i < 32; i = i + 1) begin
//             gray_to_binary[i] = gray_to_binary[i] ^ gray_to_binary[i-1];
//         end
//     end
//endfunction
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FUNTCTIONS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
parameter N = 7;
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
// function [6:0] g2binary;
//     input [6:0] gray_code;
//     reg [6:0] binary_code;

//     begin
//         binary_code = gray_code;
//         for (int i = 1; i < 7; i = i + 1) begin
//             binary_code[i] = binary_code[i] ^ binary_code[i-1];
//         end
//     end
//     return binary_code;
// endfunction
function [$clog2(WORDS):0] g2binary;
    input [$clog2(WORDS):0] gray;
    reg [$clog2(WORDS)-1:0] bin;
    int i;
    begin
    for(i=0;i<$clog2(WORDS);i = i+1)
        bin[i] = ^(gray >> i);
    end
    return bin;
  endfunction
endmodule

module gray_to_binary#(parameter WORDS=32) (
  input [WORDS-1:0] gray,  output reg [$clog2(WORDS):0] gray_to_binary
);
always_comb begin
    gray_to_binary = gray;
    for (int i = 1; i < WORDS; i = i + 1) begin
        gray_to_binary[i] = gray_to_binary[i] ^ gray_to_binary[i-1];
    end
end
endmodule

module g2b_converter #(parameter WIDTH=4) (input [WIDTH-1:0] gray, output [WIDTH-1:0] binary);
  genvar i;
  generate
    for(i=0;i<WIDTH;i++) begin
      assign binary[i] = ^(gray >> i);
    end
  endgenerate
endmodule

module bin2gray #(parameter N=4) ( input [N-1:0] bin,output [N-1:0] gray);
    genvar i;
    generate
        for(i=0;i<N;i=i+1)begin
            assign gray[i]= bin[i] ^ bin[i+1];
        end
    endgenerate
    assign gray [N-1]=bin[N-1];
endmodule
`include "synchronizer/NDFF_BUS_syn.v"//!remember to remove
`include "synchronizer/PULSE_syn.v"
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

input [WIDTH-1:0] wdata;
output  wfull;
input winc; 
input rinc;
output reg [WIDTH-1:0] rdata;
output reg rempty;

// You can change the input / output of the custom flag ports
input clk2_fifo_flag1;
input clk2_fifo_flag2;
output clk2_fifo_flag3;
output clk2_fifo_flag4;

input fifo_clk3_flag1;
input fifo_clk3_flag2;
output fifo_clk3_flag3;
output fifo_clk3_flag4;

wire [WIDTH-1:0] rdata_q;
reg [WIDTH-1:0] wdata_;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
reg [3:0] i, j;
genvar idx, jdx;
reg write_enable;
parameter EMPTY = 'd0, WRITE = 'd1, READ = 'd2, FULL = 'd3;
parameter EMPTY_r = 'd0, WRITE_r = 'd1, READ_r = 'd2, FULL_r = 'd3;
reg [2:0] c_state ,n_state_r, c_state_r, n_state;
wire CS_READ = c_state == READ, CS_EMPTY = c_state == EMPTY, CS_FULL = c_state == FULL, CS_WRITE = c_state == WRITE;
wire CS_READ_r = c_state_r == READ_r, CS_EMPTY_r = c_state_r == EMPTY_r, CS_FULL_r = c_state_r == FULL_r, CS_WRITE_r = c_state_r == WRITE_r;
reg [7:0] ctr;
reg [7:0] ctr_r;
always@(posedge wclk or negedge rst_n) begin
    if(!rst_n) c_state <= EMPTY;
    else c_state <= n_state;
end
always@(posedge wclk or negedge rst_n) begin
    if(!rst_n) wdata_ = 0;
    else
    if(winc) wdata_ = wdata;
end

always@(*) begin
    n_state = c_state;
    case(c_state)
        EMPTY: if(winc) n_state = WRITE;
        WRITE: if(ctr==512) n_state = READ;
                else n_state = WRITE; 
        READ: if(wfull) n_state = FULL;
        FULL: if(rempty) n_state = EMPTY;
        default: n_state = EMPTY;
    endcase
end
//ctr
always @(posedge wclk or negedge rst_n) begin
    if (!rst_n) 
        ctr <= 3'b0;
    else begin
        if (n_state != c_state) ctr <= 8'b0;
        else begin
            if (c_state == WRITE) ctr <= ctr + 1;
            else if (c_state == READ) ctr <= ctr + 1;
            else ctr <= ctr;
        end
    end
end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>read fsm<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    always@(posedge rclk or negedge rst_n) begin
        if(!rst_n) c_state_r <= EMPTY_r;
        else c_state_r <= n_state_r;
    end

    always@(*) begin
        n_state_r = c_state_r;
        case(c_state_r)
            EMPTY_r: if(winc) n_state_r = WRITE_r;
            WRITE_r: if(ctr_r==512) n_state_r = READ_r;
            READ_r: if(wfull) n_state_r = FULL_r;
            FULL_r: if(rempty) n_state_r = EMPTY_r;
            default: n_state_r = EMPTY_r;
        endcase
    end
    //ctr
    always @(posedge rclk or negedge rst_n) begin
        if (!rst_n) ctr_r <= 3'b0;
        else begin
            if (n_state_r != c_state_r) ctr_r <= 8'b0;
            else begin
                if (c_state_r == WRITE_r) ctr <= ctr_r + 1;
                else if (c_state_r == READ_r) ctr_r <= ctr_r + 1;
                else ctr_r <= ctr_r;
            end
        end
    end

    // Remember: 
    //   wptr and rptr should be gray coded
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Wr-ptr Binary to gray encoding<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    //   Don't modify the signal name
    reg [$clog2(WORDS):0] wptr,wptr_before_gray;
    reg [$clog2(WORDS):0] rptr,rptr_gray;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>First Flop instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
reg [$clog2(WORDS):0] wptr_gray_q;
reg [6:0]wptreal;
reg [6:0] mywptr;
//flip flop
always@(posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        mywptr <= 0;
    end
    else begin
        if(CS_WRITE)begin   
        mywptr<=wptr;
        end else begin 
            mywptr <= mywptr;
        end 
    end

end

    always@( posedge wclk or negedge rst_n) begin//wptrbeforegray
        if(!rst_n) begin
            wptr_before_gray <= 0;
            wptr=0;
        end
        else begin
        //
        if(CS_EMPTY&&!winc)begin 
                    wptr=0;
                    wptr_before_gray = 0;
        end else if(winc||CS_WRITE)begin
                    //perform binary to gray encoding
                    wptr <= bin2gray_func(wptr_before_gray);
                    wptr_before_gray<=wptreal;    
            end
        end
    end
    wire fifo_empty,fifo_full;
    wire [31:0] rptr_gray_q;
    assign fifo_empty=(wptr==rptr);
    assign fifo_full=(wptr==rptr+1);
    NDFF_BUS_syn look (
        .D (wptr),
        .clk (rclk),
        .Q (wptr_gray_q),
        .rst_n (rst_n)
    );
    //other flop
    NDFF_BUS_syn lookback (
        .D (rptr),
        .clk (wclk),
        .Q (rptr_gray_q),
        .rst_n (rst_n)
    );
    always@(posedge rclk or negedge rst_n) begin
        if(!rst_n) begin
            wptreal <= 0;
        end
        else begin
            if(winc||CS_WRITE_r&&wdata!=wdata_)begin  
                wptreal<=wptreal+1;
            end else begin 
                wptreal <=wptreal;
            end 
        end

    end
    always@(*) begin
        if(!rst_n) begin
            write_enable=1;
        end
        else begin
            if(winc)begin  
                write_enable=0;
            end else begin 
                write_enable=1;
            end 
        end

    end
    // wire sync_winc;
    // PULSE_syn sync_wptr (
    // .IN(winc),
    // .TX_CLK(wclk),
    // .RX_CLK(rclk),
    // .RST_N(rst_n),
    // .OUT(sync_winc)
    // );
    reg [$clog2(WORDS):0] rptr_before_gray,rptr_before_gray1;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Rd-ptr Binary to gray encoding<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

reg [31:0]ReadData,ReadData1;
always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rptr_before_gray <= 0;
    end
    else begin
         if(rinc)begin       
                rptr_before_gray<=g2binary(wptr_gray_q);
                $display("rptr_before_gray=%d",rptr_before_gray);
        end
    end
end
assign rempty=(wptr_before_gray==rptr_before_gray);
assign wfull=0;//(wptr_before_gray==rptr_before_gray+1);
always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rptr_before_gray1 <= 0;
        ReadData1<=0;
    end
    else begin
        if(CS_READ_r)begin   
            rptr_before_gray1<=rptr_before_gray;
            ReadData1<=rdata_q;
        end else begin 
            rptr_before_gray1 <= rptr_before_gray1;
        end 
    end
end
//Write Operation: Increment wptr after writing data into the FIFO.
//Read Operation: Increment rptr after reading data from the FIFO.
//2 stage sync
//gray to binary of result from sync
//wrptr rdclk
//compare rdclk and wrclk


//pass rptr and wptr to gray_to_binary module
// gray_to_binary #(.WORDS(WORDS)) u_gray_to_binary (
//     .gray(rptr),
//     .gray_to_binary(raddr)
// );




//  Add one more register stage to rdata
always @(posedge rclk) begin
    if (rinc)
        rdata <= rdata_q;
end
DUAL_64X32X1BM1 u_dual_sram (
    .CKA(wclk),
    .CKB(rclk),
    .WEAN(~(winc||CS_WRITE_r)),//controls write
    .WEBN(1'b1),//controls read
    .CSA(1'b1),
    .CSB(1'b1),
    .OEA(1'b1),
    .OEB(1'b1),
    .A0(wptreal[0]),
    .A1(wptreal[1]),
    .A2(wptreal[2]),
    .A3(wptreal[3]),
    .A4(wptreal[4]),
    .A5(wptreal[5]),
    .B0(rptr_before_gray[0]),
    .B1(rptr_before_gray[1]),
    .B2(rptr_before_gray[2]),
    .B3(rptr_before_gray[3]),
    .B4(rptr_before_gray[4]),
    .B5(rptr_before_gray[5]),
    .DIA0(wdata_[0]),
    .DIA1(wdata_[1]),
    .DIA2(wdata_[2]),
    .DIA3(wdata_[3]),
    .DIA4(wdata_[4]),
    .DIA5(wdata_[5]),
    .DIA6(wdata_[6]),
    .DIA7(wdata_[7]),
    .DIA8(wdata_[8]),
    .DIA9(wdata_[9]),
    .DIA10(wdata_[10]),
    .DIA11(wdata_[11]),
    .DIA12(wdata_[12]),
    .DIA13(wdata_[13]),
    .DIA14(wdata_[14]),
    .DIA15(wdata_[15]),
    .DIA16(wdata_[16]),
    .DIA17(wdata_[17]),
    .DIA18(wdata_[18]),
    .DIA19(wdata_[19]),
    .DIA20(wdata_[20]),
    .DIA21(wdata_[21]),
    .DIA22(wdata_[22]),
    .DIA23(wdata_[23]),
    .DIA24(wdata_[24]),
    .DIA25(wdata_[25]),
    .DIA26(wdata_[26]),
    .DIA27(wdata_[27]),
    .DIA28(wdata_[28]),
    .DIA29(wdata_[29]),
    .DIA30(wdata_[30]),
    .DIA31(wdata_[31]),
    .DIB0(rdata[0]),
    .DIB1(rdata[1]),
    .DIB2(rdata[2]),
    .DIB3(rdata[3]),
    .DIB4(rdata[4]),
    .DIB5(rdata[5]),
    .DIB6(rdata[6]),
    .DIB7(rdata[7]),
    .DIB8(rdata[8]),
    .DIB9(rdata[9]),
    .DIB10(rdata[10]),
    .DIB11(rdata[11]),
    .DIB12(rdata[12]),
    .DIB13(rdata[13]),
    .DIB14(rdata[14]),
    .DIB15(rdata[15]),
    .DIB16(rdata[16]),
    .DIB17(rdata[17]),
    .DIB18(rdata[18]),
    .DIB19(rdata[19]),
    .DIB20(rdata[20]),
    .DIB21(rdata[21]),
    .DIB22(rdata[22]),
    .DIB23(rdata[23]),
    .DIB24(rdata[24]),
    .DIB25(rdata[25]),
    .DIB26(rdata[26]),
    .DIB27(rdata[27]),
    .DIB28(rdata[28]),
    .DIB29(rdata[29]),
    .DIB30(rdata[30]),
    .DIB31(rdata[31]),
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
// function [31:0] binary_to_gray;
//     input [31:0] binary;
//     begin
//         binary_to_gray = binary ^ (binary >> 1);
//     end
// endfunction

// function [:0] gray_to_binary;
//     input [31:0] gray;
//     begin
//         gray_to_binary = gray;
//         for (int i = 1; i < 32; i = i + 1) begin
//             gray_to_binary[i] = gray_to_binary[i] ^ gray_to_binary[i-1];
//         end
//     end
//endfunction
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FUNTCTIONS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
parameter N = 7;
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
// function [6:0] g2binary;
//     input [6:0] gray_code;
//     reg [6:0] binary_code;

//     begin
//         binary_code = gray_code;
//         for (int i = 1; i < 7; i = i + 1) begin
//             binary_code[i] = binary_code[i] ^ binary_code[i-1];
//         end
//     end
//     return binary_code;
// endfunction
function [$clog2(WORDS):0] g2binary;
    input [$clog2(WORDS):0] gray;
    reg [$clog2(WORDS)-1:0] bin;
    int i;
    begin
    for(i=0;i<$clog2(WORDS);i = i+1)
        bin[i] = ^(gray >> i);
    end
    return bin;
  endfunction
endmodule

module gray_to_binary#(parameter WORDS=32) (
  input [WORDS-1:0] gray,  output reg [$clog2(WORDS):0] gray_to_binary
);
always_comb begin
    gray_to_binary = gray;
    for (int i = 1; i < WORDS; i = i + 1) begin
        gray_to_binary[i] = gray_to_binary[i] ^ gray_to_binary[i-1];
    end
end
endmodule

module g2b_converter #(parameter WIDTH=4) (input [WIDTH-1:0] gray, output [WIDTH-1:0] binary);
  genvar i;
  generate
    for(i=0;i<WIDTH;i++) begin
      assign binary[i] = ^(gray >> i);
    end
  endgenerate
endmodule

module bin2gray #(parameter N=4) ( input [N-1:0] bin,output [N-1:0] gray);
    genvar i;
    generate
        for(i=0;i<N;i=i+1)begin
            assign gray[i]= bin[i] ^ bin[i+1];
        end
    endgenerate
    assign gray [N-1]=bin[N-1];
endmodule