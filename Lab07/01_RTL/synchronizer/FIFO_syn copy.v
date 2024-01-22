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
    rinc,

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
always @(posedge wclk or negedge rst_n) begin
    if (!rst_n)
        wfull <= 0;
    else if (winc)
        wfull <= 1;
    else if (rinc)
        wfull <= 0;
end
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
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
reg [3:0] K1, K2, K3, K4;
reg [3:0] i, j;
genvar idx, jdx;
parameter EMPTY = 'd0, WRITE = 'd1, READ = 'd2, FULL = 'd3;
reg [2:0] c_state, n_state;
wire CS_READ = c_state == READ, CS_EMPTY = c_state == EMPTY, CS_FULL = c_state == FULL, CS_WRITE = c_state == WRITE;
reg [7:0] ctr;
always@(posedge rclk or posedge wclk or negedge rst_n) begin
    if(!rst_n) c_state <= EMPTY;
    else c_state <= n_state;
end

always@(*) begin
    n_state = c_state;
    case(c_state)
        EMPTY: if(winc) n_state = WRITE;
        WRITE: if(rinc) n_state = READ;
        READ: if(wfull) n_state = FULL;
        FULL: if(rempty) n_state = EMPTY;
        default: n_state = EMPTY;
    endcase
end

// Remember: 
//   wptr and rptr should be gray coded
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Wr-ptr Binary to gray encoding<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//   Don't modify the signal name
reg [$clog2(WORDS):0] wptr,wptr_gray;
reg [$clog2(WORDS):0] rptr,rptr_gray;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>First Flop instantiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//flops  then 
always@( posedge wclk or negedge rst_n) begin
    if(!rst_n) begin
        wptr_gray <= 0;
        wptr=0;
    end
    else begin
        case (c_state)
            EMPTY: begin
                wptr=0;
                wptr_gray <= 0;
            end
            WRITE: begin
                //perform binary to gray encoding
                wptr=wptr+1;
                wptr_gray <= bin2gray_func(wptr);
            end
            READ: begin
                
            end
            FULL: begin
                
            end
            default: begin
                
            end
        endcase
    end
end

always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
       rdata<=0;
    end else begin 
        rdata<=rdata_;
    end 
end
always@(posedge rclk or negedge rst_n) begin
    if(!rst_n) begin
        rptr_gray <= 0;
        rptr=0;
    end
    else begin
        case (c_state)
            EMPTY: begin
                rptr_gray <= 0;
            end
            WRITE: begin
                //perform binary to gray encoding
                rptr=rptr+1;
                rptr_gray <= bin2gray_func(rptr);
            end
            READ: begin
                
            end
            FULL: begin
                
            end
            default: begin
                
            end
        endcase
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
    .WEAN(),//controls write
    .WEBN(),//controls read
    .CSA(1),
    .CSB(1),
    .OEA(1),
    .OEB(1),
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
    .DIB0(rdata_[0]),
    .DIB1(rdata_[1]),
    .DIB2(rdata_[2]),
    .DIB3(rdata_[3]),
    .DIB4(rdata_[4]),
    .DIB5(rdata_[5]),
    .DIB6(rdata_[6]),
    .DIB7(rdata_[7]),
    .DIB8(rdata_[8]),
    .DIB9(rdata_[9]),
    .DIB10(rdata_[10]),
    .DIB11(rdata_[11]),
    .DIB12(rdata_[12]),
    .DIB13(rdata_[13]),
    .DIB14(rdata_[14]),
    .DIB15(rdata_[15]),
    .DIB16(rdata_[16]),
    .DIB17(rdata_[17]),
    .DIB18(rdata_[18]),
    .DIB19(rdata_[19]),
    .DIB20(rdata_[20]),
    .DIB21(rdata_[21]),
    .DIB22(rdata_[22]),
    .DIB23(rdata_[23]),
    .DIB24(rdata_[24]),
    .DIB25(rdata_[25]),
    .DIB26(rdata_[26]),
    .DIB27(rdata_[27]),
    .DIB28(rdata_[28]),
    .DIB29(rdata_[29]),
    .DIB30(rdata_[30]),
    .DIB31(rdata_[31]),
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
function [5:0] bin2gray_func;
    input [5:0] bin;
    integer i;
    reg [5:0] gray;
    for (i = 0; i < 5; i = i + 1) begin
        gray[i] = bin[i] ^ bin[i+1];
    end

    gray[5] = bin[5];

    return gray;
endfunction
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>guycode<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
reg [WIDTH-1:0] buf_mem [WORDS-1:0];		//Buffer memory
reg [WIDTH-1:0] buf_in;				//Buffer input
reg [WIDTH-1:0] buf_out;			//Buffer output
reg [WIDTH-1:0] buf_out_q;			//Buffer output
reg [7:0] fifo_counter;				//FIFO counter
reg buf_empty;					//Buffer empty flag
reg buf_full;					//Buffer full flag

always @(fifo_counter)
begin
   buf_empty = (fifo_counter==0);   // Checking for whether buffer is empty or not
   buf_full = (fifo_counter== 64);  //Checking for whether buffer is full or not

end
//Setting FIFO counter value for different situations of read and write operations.
always @(posedge rclk or negedge rst_n)
begin
   if(! rst_n )
       fifo_counter <= 0;		// Reset the counter of FIFO

   else if( (!buf_full && winc) && ( !buf_empty && rinc ) )  //When doing read and write operation simultaneously
       fifo_counter <= fifo_counter;			// At this state, counter value will remain same.

   else if( !buf_full && winc )			// When doing only write operation
       fifo_counter <= fifo_counter + 1;

   else if( !buf_empty && rinc )		//When doing only read operation
       fifo_counter <= fifo_counter - 1;

   else
      fifo_counter <= fifo_counter;			// When doing nothing.
end

always @(posedge rclk)
begin
   if( winc && !buf_full )
      buf_mem[ wptr ] <= buf_in;		//Writing 8 bit data input to buffer location indicated by write pointer
   else
      buf_mem[ wptr ] <= buf_mem[ wptr ];
end

always@(posedge rclk or negedge rst_n) begin
   if( !rst_n )
   begin
      wptr <= 0;		// Initializing write pointer
      rptr <= 0;		//Initializing read pointer
   end
   else
   begin
      if( !buf_full && winc )    
			wptr <= wptr + 1;		// On write operation, Write pointer points to next location
      else  
			wptr <= wptr;

      if( !buf_empty && rinc )   
			rptr <= rptr + 1;		// On read operation, read pointer points to next location to be read
      else 
			rptr <= rptr;
   end

end


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