module Train(
    //Input Port
    clk,
    rst_n,
	in_valid,
	data,

    //Output Port
    out_valid,
	result
);

input        clk;
input 	     in_valid;
input        rst_n;
input  [3:0] data;
output   reg out_valid;
output   reg result; 

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Declarations<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
parameter WIDTH = 5, DEPTH = 5;
reg [3:0] K1, K2, K3, K4;
reg [3:0] i, j;
int ii,jj;
genvar idx, jdx;
reg [3:0] matrix [WIDTH-1:0];
reg [3:0] wfmatrix [WIDTH-1:0][DEPTH-1:0];
reg [2:0] c_state, n_state;
parameter IDLE = 0, 
          INPUT = 1, 
          COMP1 = 2, 
          COMP2 = 3, 
          OUT = 4;
wire CS_COMP1 = c_state == COMP1,CS_COMP2 = c_state == COMP2, CS_IDLE = c_state == IDLE, CS_OUT = c_state == OUT, CS_INPUT = c_state == INPUT;
reg [7:0] ctr;
reg [4:0] last,last_next,TET,snrt,TET_next,snrt_next,order[0:10],
order_next[0:10],station[0:10],station_next[0:10];
reg [4:0] prod,prod_next;
reg out_ready,res_val;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

always@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin     
        c_state <= 0;
    end 
    else begin
        c_state <= n_state;
    end 
end 
always@(*) begin
	n_state = c_state;
    if(CS_IDLE) begin
            if(in_valid) begin
                n_state = INPUT;
            end else begin
                    n_state = 0;
            end 
        end
	else if(CS_INPUT) begin
            if(last==prod-1) begin
                n_state = COMP1;
            end 
	end else if (CS_COMP1) begin
        if(TET==prod+1) begin
            n_state = OUT;
        end
        if(TET==order[last]) begin
            if(last== prod-2) begin
                n_state = OUT;
            end else begin 
                 n_state = COMP2;
            end
        end
    end else if(CS_COMP2) begin
        if(station[snrt-1] == order[last]) begin
            if(last== prod-2) begin
                n_state = OUT;
            end 
        end else begin
            n_state = COMP1;
        end
        if(TET==prod+1) begin
            n_state = OUT;
        end
    end else if(CS_OUT) n_state = IDLE;
end
 
always@(posedge clk, negedge rst_n) begin
    if (!rst_n) begin     
        last <= 0;
        TET <= 0;
            end 
    else begin
        last <= last_next;
        TET <= TET_next;
    end 
end 
always@(posedge clk, negedge rst_n) begin //prod
    if (!rst_n) begin     
       snrt <= 0;
        prod <= 0;
    end 
    else begin
            snrt <=snrt_next;
        prod <= prod_next;
    end 
end 
always@(posedge clk, negedge rst_n) begin//station next
    if (!rst_n) begin     
        for(ii=0; ii<=11; ii=ii+1) begin                
            order[ii] <= 0;
            station[ii] <= 0;
        end
    end 
    else begin
        station <= station_next;
        order <= order_next;
    end 
end 
always@(*) begin
    prod_next = prod;
	TET_next = TET;
   snrt_next =snrt;
	last_next = last;
    res_val = 0;
    order_next = order;
    out_ready = 0;
    station_next = station;
    if(CS_IDLE) begin
            if(in_valid) begin
                prod_next = data;
            end else begin
                for(ii=0; ii<=11; ii=ii+1) begin                
                    order_next[ii] = 0;
                    station_next[ii] = 0;
                end
                    TET_next = 0;
                    last_next = 0;
                    prod_next = 0;
                    out_ready = 0;
                    res_val = 0;
                    snrt_next = 0;
            end 
        end
	else if(CS_INPUT) begin
            if(last==prod-1) begin
                last_next = 0;
                TET_next = 1;
                snrt_next = 0;
            end else begin 
                TET_next=0;
                last_next = last+1;
                order_next[last] = data; 
                snrt_next=0;
            end 
	end else if (CS_COMP1) begin
        if(TET==prod+1) begin
            res_val = 0;
            out_ready = 1;
        end
        station_next[snrt] = TET;
        if(TET==order[last]) begin
            if(last== prod-2) begin
                 res_val = 1;
                 out_ready = 1;
            end
            last_next = last+1;
            station_next[snrt] = 0;
        end
        else begin
           snrt_next =snrt+1;
            TET_next = TET+1;
        end    
    end else if(CS_COMP2) begin
        if(station[snrt-1] == order[last]) begin
            last_next = last+1;
            snrt_next =snrt-1;
            station_next[snrt-1] = 0;
            if(last== prod-2) begin
                res_val = 1;
                out_ready = 1;
            end
        end else begin
            TET_next = TET+1;
            station_next[snrt] = TET+1;
        end
    end
end


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>out<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
always@(posedge clk, negedge rst_n) begin//out
    if (!rst_n) begin     
        out_valid <= 0;
    end 
    else begin
        out_valid <= out_ready;
    end 
end 
always@(posedge clk, negedge rst_n) begin //result
    if (!rst_n) begin     
        result<=0;
    end 
    else begin
        result <= res_val;
    end 
end 

endmodule
