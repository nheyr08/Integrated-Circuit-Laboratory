module Handshake_syn #(parameter WIDTH=32) (
    sclk,
    dclk,
    rst_n,
    sready,
    din,
    dbusy,
    sidle,
    dvalid,
    dout,

    clk1_handshake_flag1,//!change path back remember!!!
    clk1_handshake_flag2,
    clk1_handshake_flag3,
    clk1_handshake_flag4,

    handshake_clk2_flag1,
    handshake_clk2_flag2,
    handshake_clk2_flag3,
    handshake_clk2_flag4 //wistleblower
);

input sclk, dclk;
input rst_n;
input sready;
input [WIDTH-1:0] din;
input dbusy;
output sidle;
output reg dvalid;
output reg [WIDTH-1:0] dout;

// You can change the input / output of the custom flag ports
input clk1_handshake_flag1;
input clk1_handshake_flag2;
output reg clk1_handshake_flag3;
output clk1_handshake_flag4;

input handshake_clk2_flag1;
input handshake_clk2_flag2;
output handshake_clk2_flag3;
input handshake_clk2_flag4;
// assign clk1_handshake_flag4 =clk1_handshake_flag3;
assign clk1_handshake_flag4=handshake_clk2_flag4;
always @(posedge sclk or negedge rst_n) begin//clk1_handshake_flag3
    if (!rst_n)
        clk1_handshake_flag3 <= 0;
    else if (sready)begin
        clk1_handshake_flag3 <= 1;
       // $display("clk1_handshake_flag3= %d", clk1_handshake_flag3);
    end else if (dvalid)
        clk1_handshake_flag3 <= 0;
end



//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Driver<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// Remember:
//   Don't modify the signal name
reg sreq;
wire dreq;
reg dack;
wire sack;

always @(posedge sclk or negedge rst_n) begin//sreq
    if (!rst_n)
        sreq <= 0;
    else if (sready)
        sreq <= 1;
    else if (sack)
        sreq <= 0;
end
always @(posedge dclk or negedge rst_n) begin//dack
    if (!rst_n)
        dack <= 0;
    else if (dvalid)
        dack <= 1;
    else if (dbusy)
        dack <= 0;
end
always @(posedge sclk or negedge rst_n) begin//dvalid
    if (!rst_n)
        dvalid <= 0;
    else if (sreq && !dack)
        dvalid <= 1;
    else if (dack)
        dvalid <= 0;
end
// assign sack = dreq && !sreq;
// assign dreq = dvalid && !dbusy;
assign sidle = !sreq && !dack;
always @(posedge dclk or negedge rst_n) begin//dout
    if (!rst_n)
        dout <= 0;
    else if (dreq)
        dout <= din;
    else if (dack)
        dout <= dout;
end
NDFF_syn clk2_dff (
    .D (sreq),
    .clk (dclk),
    .Q (dreq),
    .rst_n (rst_n)
);
NDFF_syn clk1_dff (
    .D (dack),
    .clk (sclk),
    .Q (sack),
    .rst_n (rst_n)
);

endmodule