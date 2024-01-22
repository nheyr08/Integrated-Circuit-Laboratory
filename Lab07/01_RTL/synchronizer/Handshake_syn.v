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

    clk1_handshake_flag1,
    clk1_handshake_flag2,
    clk1_handshake_flag3,
    clk1_handshake_flag4,

    handshake_clk2_flag1,
    handshake_clk2_flag2,
    handshake_clk2_flag3,
    handshake_clk2_flag4
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
output clk1_handshake_flag3;
output clk1_handshake_flag4;

input handshake_clk2_flag1;
input handshake_clk2_flag2;
output handshake_clk2_flag3;
output handshake_clk2_flag4;

// Remember:
//   Don't modify the signal name
reg sreq;
wire dreq;
reg dack;
wire d_sel;
wire sack;
reg vld;
assign sidle = !sreq && !sack;
assign d_sel = dack == 1'b0 && dreq && !dbusy;
always @(posedge sclk, negedge rst_n) begin
    if(!rst_n)begin
        sreq <= 1'b0;
    end else begin
        case(sreq)
        1'b0:begin
            if(sready && !sack)begin
                sreq <= 1'b1;
            end
        end
        1'b1:begin
            if(sack)begin
                sreq <= 1'b0;
            end
        end
        endcase
    end
end
always@(posedge dclk, negedge rst_n)begin
    if(!rst_n)begin
        dack <= 1'b0;
    end else begin
        if(dack == 1'b0 && dreq && !dbusy)begin
            dack <= 1'b1;
        end else if(dack == 1'b1 && !dreq)begin
            dack <= 1'b0;
        end
    end
end
always@(posedge dclk, negedge rst_n)begin
    if(!rst_n)begin
        dout <= 0;    
    end else begin
        if(d_sel)begin
            dout <= din;
        end else begin
            dout <= dout;
        end
    end
end
always@(posedge dclk, negedge rst_n)begin
    if(!rst_n)begin
        vld <= 1'b0;
    end else begin
        if(d_sel)begin
            vld <= 1'b1;
        end else begin
            vld <= 1'b0;
        end
    end
end
always@(*)begin
    if(dbusy)begin
        dvalid = 0;
    end else begin
        dvalid = vld;
    end
end

NDFF_syn PIDPS(.D(dack), .Q(sack), .clk(sclk), .rst_n(rst_n));
NDFF_syn caosr(.D(sreq), .Q(dreq), .clk(dclk), .rst_n(rst_n));
endmodule
