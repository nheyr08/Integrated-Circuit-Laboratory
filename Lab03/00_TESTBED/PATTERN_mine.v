`ifdef RTL
    `define CYCLE_TIME 40.0
`endif
`ifdef GATE
    `define CYCLE_TIME 40.0
`endif

`include "../00_TESTBED/pseudo_DRAM.v"
`include "../00_TESTBED/pseudo_SD.v"

module PATTERN(
    // Input Signals
    clk,
    rst_n,
    in_valid,
    direction,
    addr_dram,
    addr_sd,
    // Output Signals
    out_valid,
    out_data,
    // DRAM Signals
    AR_VALID, AR_ADDR, R_READY, AW_VALID, AW_ADDR, W_VALID, W_DATA, B_READY,
	AR_READY, R_VALID, R_RESP, R_DATA, AW_READY, W_READY, B_VALID, B_RESP,
    // SD Signals
    MISO,
    MOSI
);
reg clk;
real	CYCLE = `CYCLE_TIME;
always	#(CYCLE/2.0) clk = ~clk;
initial	clk = 0;
/* Input for design */
output reg        clk, rst_n;
output reg        in_valid;
output reg        direction;
output reg [12:0] addr_dram;
output reg [15:0] addr_sd;

/* Output for pattern */
input        out_valid;
input  [7:0] out_data; 

// DRAM Signals
// write address channel
input [31:0] AW_ADDR;
input AW_VALID;
output AW_READY;
// write data channel
input W_VALID;
input [63:0] W_DATA;
output W_READY;
// write response channel
output B_VALID;
output [1:0] B_RESP;
input B_READY;
// read address channel
input [31:0] AR_ADDR;
input AR_VALID;
output AR_READY;
// read data channel
output [63:0] R_DATA;
output R_VALID;
output [1:0] R_RESP;
input R_READY;

// SD Signals
output MISO;
input MOSI;

real CYCLE = `CYCLE_TIME;
integer pat_read;
integer PAT_NUM;
integer total_latency, latency;
integer i_pat;
reg [7:0] out_data_values[7:0];
initial begin
    pat_read = $fopen("../00_TESTBED/Input.txt", "r");
    in_valid = 1'b0;
    reset_signal_task;
    i_pat = 0;
    total_latency = 0;
    $fscanf(pat_read, "%d", PAT_NUM);
    @(negedge clk);
     
   $display("out!! PAT_NUM = %d", PAT_NUM);
    // $display("signal aleadyreset");
    for (i_pat = 1; i_pat <= PAT_NUM; i_pat = i_pat + 1) begin
         input_task;//done
         wait_out_valid_task;//done+-
         check_ans_task;
        total_latency = total_latency + latency;
        $display("PASS PATTERN NO.%4d", i_pat);
    end
    $fclose(pat_read);
    // $display("outdata = %h", out_data);
    // $display("outvalid = %h", out_valid);
    $finish;
    $writememh("../00_TESTBED/DRAM_final.dat", u_DRAM.DRAM);
    $writememh("../00_TESTBED/SD_final.dat", u_SD.SD);
    YOU_PASS;
end

//////////////////////////////////////////////////////////////////////
// Write your own task here
//////////////////////////////////////////////////////////////////////


task reset_signal_task; begin 
    rst_n = 'b1;
    in_valid='b0;
    direction='bx;
    addr_dram='bx;
    addr_sd='bx;	
    total_latency = 0;
    //AR_ADDR = 'bx;

    force clk = 0;

    #CYCLE; rst_n = 0; 
    #CYCLE; rst_n = 1;

    if(out_valid !== 1'b0 || out_data !== 'b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(AW_ADDR!=='b0||AW_READY!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(AW_ADDR!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(AR_VALID!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(AW_VALID!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(AR_ADDR!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(W_DATA!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(B_READY!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(R_READY!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(W_VALID!=='b0) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
    if(MOSI!=='b1) begin //out!==0
        $display("SPEC MAIN-1 FAIL");
        repeat(2) #CYCLE;
        $finish;
    end
	#CYCLE; release clk;
end
//display all signals
endtask

integer patternType,address1,address2;

task input_task; begin
     $fscanf(pat_read, "%d %d %d", patternType,address1,address2);
     // $fscanf("Input.txt", "%d %d %d", patternType, address1, address2);
        //	$display("patterntype = %h", patternType);
	    //$display("address1 = %h", address1);
         //$display("address2 = %h", address2);
	repeat(2) @(negedge clk);
	direction = patternType;	
    addr_dram = address1;
    addr_sd = address2;
    in_valid = 1'b1;
	@(negedge clk);		
    in_valid = 1'b0;	
    addr_dram = 'b0;
    addr_sd = 'b0;
end endtask 

task wait_out_valid_task; begin
    $display("goth theresss");
    latency = 0;
    while(out_valid !== 1'b1) begin
	latency = latency + 1;

    if( latency == 10000) begin
        $display(" SPEC MAIN-3 FAIL");     
       $display("latentcy = %d", latency);
        repeat(2) #CYCLE;
        $finish;
    end
     @(negedge clk);
   end
  // total_latency = total_latency + latency;
end endtask
integer u_DRAMDRAMaddress1, u_SDSDaddress;
integer stall_8_cycles;

task check_ans_task; begin 
    stall_8_cycles=0;
    u_DRAMDRAMaddress1=u_DRAM.DRAM[address1];
    u_SDSDaddress=u_SD.SD[address2];
    while (out_valid===1) begin
        if(stall_8_cycles == 9) begin
            $display("SPEC MAIN-4 FAIL"); //The out_valid and out_data must be asserted in 8 cycles.
            repeat(2)@(negedge clk);
            $finish;
        end //check answer correct or not
         out_data_values[stall_8_cycles] = out_data;
        @(negedge clk);
        stall_8_cycles = stall_8_cycles +1;
    end
    if(out_valid===0&&stall_8_cycles!==8) begin
        $display("SPEC MAIN-4 FAIL"); //The out_valid and out_data must be asserted in 8 cycles.
        repeat(2)@(negedge clk);
        $finish;
    end
     if(out_valid===0&&stall_8_cycles===8) begin
    //      if(( {out_data_values[0],out_data_values[1],out_data_values[2],out_data_values[3],out_data_values[4],out_data_values[5],out_data_values[6],out_data_values[7]})!=u_DRAM.DRAM[address1]) begin
    //         $display("SPEC MAIN-5 FAIL"); // The out_data should be correct when out_valid is high.
    //         repeat(2)@(negedge clk);
    //         $finish;
    //      end
    if(( {out_data_values[0],out_data_values[1],out_data_values[2],out_data_values[3],out_data_values[4],out_data_values[5],out_data_values[6],out_data_values[7]})!=u_SD.SD[address2]) begin
            $display("SPEC MAIN-5 FAIL"); // The out_data should be correct when out_valid is high.
            repeat(2)@(negedge clk);
            $finish;
         end
    end

end endtask

always@(*)begin //check answer correct or not
    if((u_DRAM.DRAM[address1]!=u_SD.SD[address2])&&out_valid==1) begin
        $display("DRAM is %h, SD is %h", u_DRAM.DRAM[address1], u_SD.SD[address2]);
        $display("SPEC MAIN-6 FAIL");
        repeat(2)@(negedge clk);
        $finish;
    end
end

always@(*)begin //outdata not 0 when outvalid zero///////////////////////////////////////////
	if(out_valid ==0)begin
		if (out_data!=0)begin
			$display ("SPEC MAIN-2 FAIL");
            repeat(2)@(negedge clk);
			$finish ;
		end
	end
     else begin //outvalid is high with invalid
		if (in_valid == 1)begin
			$display ("SPEC MAIN-2 FAIL");
			$finish ;
		end
	end
end

task YOU_PASS; begin
    $display("*************************************************************************");
    $display("*                         Congratulations!                              *");
    $display("*                Your execution cycles = %5d cycles          *", total_latency);
    $display("*                Your clock period = %.1f ns          *", CYCLE);
    $display("*                Total Latency = %.1f ns          *", total_latency*CYCLE);
    $display("*************************************************************************");
    $finish;
end endtask

task YOU_FAIL_task; begin
    $display("*                              FAIL!                                    *");
    $display("*                    Error message from PATTERN.v                       *");
end endtask

pseudo_DRAM u_DRAM (
    .clk(clk),
    .rst_n(rst_n),
    // write address channel
    .AW_ADDR(AW_ADDR),
    .AW_VALID(AW_VALID),
    .AW_READY(AW_READY),
    // write data channel
    .W_VALID(W_VALID),
    .W_DATA(W_DATA),
    .W_READY(W_READY),
    // write response channel
    .B_VALID(B_VALID),
    .B_RESP(B_RESP),
    .B_READY(B_READY),
    // read address channel
    .AR_ADDR(AR_ADDR),
    .AR_VALID(AR_VALID),
    .AR_READY(AR_READY),
    // read data channel
    .R_DATA(R_DATA),
    .R_VALID(R_VALID),
    .R_RESP(R_RESP),
    .R_READY(R_READY)
);

pseudo_SD u_SD (
    .clk(clk),
    .MOSI(MOSI),
    .MISO(MISO)
);

endmodule