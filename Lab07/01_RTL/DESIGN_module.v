//   Author     		: Betsaleel Henry (henrybetsaleel@gmail.com)

module CLK_1_MODULE (
    clk,
    rst_n,
    in_valid,
    seed_in,
    out_idle,
    out_valid,
    seed_out,

    clk1_handshake_flag1,
    clk1_handshake_flag2,
    clk1_handshake_flag3,
    clk1_handshake_flag4
);

input clk;
input rst_n;
input in_valid;
input [31:0] seed_in;
input out_idle;
output reg out_valid;
output reg [31:0] seed_out;

// You can change the input / output of the custom flag ports
input clk1_handshake_flag1;
input clk1_handshake_flag2;
output clk1_handshake_flag3;
output clk1_handshake_flag4;
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        out_valid <= 0;
    end else begin
        if(in_valid && out_idle)begin
            out_valid <= 1'b1;
        end else begin
            out_valid <= 1'b0;
        end
    end
end
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        seed_out <= 0;
    end else begin
        if(in_valid && out_idle)begin
            seed_out <= seed_in;
        end
    end
end

endmodule

module CLK_2_MODULE (
    clk,
    rst_n,
    in_valid,
    fifo_full,
    seed,
    out_valid,
    rand_num,
    busy,

    handshake_clk2_flag1,
    handshake_clk2_flag2,
    handshake_clk2_flag3,
    handshake_clk2_flag4,

    clk2_fifo_flag1,
    clk2_fifo_flag2,
    clk2_fifo_flag3,
    clk2_fifo_flag4
);

input clk;
input rst_n;
input in_valid;
input fifo_full;
input [31:0] seed;
output out_valid;
output [31:0] rand_num;
output busy;

// You can change the input / output of the custom flag ports
input handshake_clk2_flag1;
input handshake_clk2_flag2;
output handshake_clk2_flag3;
output handshake_clk2_flag4;

input clk2_fifo_flag1;
input clk2_fifo_flag2;
output clk2_fifo_flag3;
output clk2_fifo_flag4;

parameter A_INIT = 13, B_INIT = 17, C_INIT = 5;

reg unsigned  [7:0] cnt;
reg unsigned  [31:0] debake_1,debake_2,debake_3,debake_6,debake_7;//debake[0:2];
reg unsigned  [31:0] temp, temp_1, temp_6,temp_7;
reg unsigned  valid;


assign busy = valid;
assign out_valid = fifo_full ? 1'b0 :valid;
assign rand_num = temp_1;

always_comb begin
    debake_1 = temp ^ (temp << A_INIT);
    debake_2 = debake_1 ^ (debake_1 >> B_INIT);
    debake_3 = debake_2 ^ (debake_2 << C_INIT);
end

always@(posedge clk)begin
    if(!fifo_full)begin
        temp_6 <= debake_6;
    end else begin
        temp_6 <= temp_6;
    end
end
always@(*)begin
    if(in_valid)begin
        temp = seed;
    end else begin
        temp = temp_1;
    end
end
always@(posedge clk)begin
    if(!fifo_full)begin
        temp_1 <= debake_3;
    end else begin
        temp_1 <= temp_1;
    end
end
always@(posedge clk)begin
    if(!fifo_full)begin
        temp_6 <= debake_6;
    end else begin
        temp_6 <= temp_6;
    end
end
always@(posedge clk)begin
    if(!fifo_full)begin
        temp_7 <= debake_7;
    end else begin
        temp_7 <= temp_7;
    end
end
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        valid <= 0;
    end else begin
        if(in_valid) begin
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end
end

endmodule

module CLK_3_MODULE (
    clk,
    rst_n,
    fifo_empty,
    fifo_rdata,
    fifo_rinc,
    out_valid,
    rand_num,

    fifo_clk3_flag1,
    fifo_clk3_flag2,
    fifo_clk3_flag3,
    fifo_clk3_flag4
);

input clk;
input rst_n;
input fifo_empty;
input [31:0] fifo_rdata;
output fifo_rinc;
output reg out_valid;
output reg [31:0] rand_num;

input fifo_clk3_flag1; 
input fifo_clk3_flag2;
output fifo_clk3_flag3;
output fifo_clk3_flag4;

reg [1:0] ctr;
wire fifo_rinc = ~fifo_empty;
reg  [31:0] mydata_buff,mydata_buff2,mydata_buff1;
reg receiver,receiver2,receiver1;
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        out_valid <= 0;
    end else begin
        out_valid <= receiver1;
    end
end
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        receiver1 <= 0;
    end else begin
        receiver1 <= receiver2;
    end
end
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        mydata_buff1 <= 0;
    end else begin
        mydata_buff1 <= mydata_buff2;
    end
end
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        receiver <= 0;
    end else begin
        receiver <= fifo_clk3_flag1;
    end
end
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        receiver2 <= 0;
    end else begin
        receiver2 <= receiver;
    end
end
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        mydata_buff <= 0;
    end else begin
        mydata_buff <= fifo_rdata;
    end
end
always@(posedge clk, negedge rst_n)begin
    if(!rst_n)begin
        mydata_buff2 <= 0;
    end else begin
        mydata_buff2 <= mydata_buff;
    end
end
always@(*)begin
    if(out_valid)begin
        rand_num = mydata_buff1;
    end else begin
        rand_num = 0;
    end
end


endmodule