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
output reg wfull;
input winc; 
input rinc;
output reg [WIDTH-1:0] rdata;
output reg rempty;

// You can change the input / output of the custom flag ports
output clk2_fifo_flag1;//whitlblower for idle
input clk2_fifo_flag2;
output clk2_fifo_flag3;
output clk2_fifo_flag4;

output fifo_clk3_flag1;
input fifo_clk3_flag2;
output fifo_clk3_flag3;
output fifo_clk3_flag4;
wire [WIDTH-1:0] rdata_q;
reg [WIDTH-1:0] wdata_;
wire whistlblower_3=fifo_clk3_flag3;
assign clk2_fifo_flag1=whistlblower_3;
assign clk2_fifo_flag4=rclk;
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
    reg [$clog2(WORDS)-1:0] rptr_before_gray,rptr_before_gray1;
            //   Don't modify the signal name
    reg [$clog2(WORDS):0] wptr;
    reg [$clog2(WORDS):0] rptr,rptr_gray;
    reg [$clog2(WORDS):0] wptr_gray_q;
    reg [$clog2(WORDS):0] wptr_before_gray;
    reg [5:0]wptreal;
    reg [6:0] mywptr;
    wire fifo_empty,fifo_full;
    wire [$clog2(WORDS):0] rptr_gray_q;
    wire readdone_=rptr_gray_q==wptr;
    assign clk2_fifo_flag2=readdone_;
    reg[4:0] ctr_donesavedvalues;
    assign fifo_empty=(wptr==rptr);
    assign fifo_full=(g2binary(rptr_gray_q)==wptr_before_gray+1);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) c_state <= EMPTY;
        else c_state <= n_state;
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
    always @(posedge rclk or negedge rst_n) begin
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
    assign fifo_clk3_flag1=rinc;
    //flip flops
       reg inc_;
        always@(posedge rclk or negedge rst_n) begin
        if(!rst_n) begin
            wptreal <= 0;
        end
        else begin
            if(winc)begin  
                wptreal<=wptreal+1;
                $display("wptreal=%d",wptreal," rptr=%d",rptr_before_gray);
            end else if(whistlblower_3)begin
                wptreal<=0;
            end else begin 
                wptreal <=wptreal;
            end 
        end
         
    end
    always@( posedge wclk or negedge rst_n) begin//wptrbeforegray
        if(!rst_n) begin
            wptr_before_gray = 0;
            wptr=0;
        end else begin
            if(CS_EMPTY&&!winc)begin 
                        wptr=0;
                        wptr_before_gray = 0;
            end else if(winc||CS_WRITE)begin
                        //perform binary to gray encoding
                        wptr = bin2gray_func(wptreal);
                        wptr_before_gray=wptreal;    
            end
        end
    end


    NDFF_BUS_syn #($clog2(WORDS)+1)  look 
    (
        .D (wptr),
        .clk (rclk),
        .Q (wptr_gray_q),
        .rst_n (rst_n)
    );
    //other flop
    NDFF_BUS_syn #($clog2(WORDS)+1) lookback 
    (
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
            if(CS_EMPTY) rptr <= 0;
            else if(rinc)begin   
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
                rptr_before_gray<=rptr_before_gray+1;
               // $display("rptr_before_gray=%d",rptr_before_gray);
         end else if(whistlblower_3)begin 
                rptr_before_gray<=0;
         end else begin 
                rptr_before_gray <= rptr_before_gray;
         end 
    end
end
wire rempty_val=(wptreal==rptr_before_gray);
assign rempty=(wptreal!=rptr_before_gray);

assign wfull=(wptreal==rptr_before_gray+1);
always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rptr_before_gray1 <= 0;
        ReadData1<=0;
    end
    else begin
        if(winc)begin   
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
// always@(posedge rclk or negedge rst_n) begin
//     if(!rst_n) begin
//         rempty <= 1;
//     end else begin  
//          rempty <= rempty_val;
//         end
// end

//pass rptr and wptr to gray_to_binary module
// gray_to_binary #(.WORDS(WORDS)) u_gray_to_binary (
//  Add one more register stage to rdata
wire write_enabl=(~winc);
reg [31:0] Deto;
always @(posedge rclk) begin
        if (rinc) begin 
            rdata <= rdata_q;
        end else 
            rdata <=rdata;
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
