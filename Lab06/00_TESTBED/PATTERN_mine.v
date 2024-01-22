`ifdef RTL
    `define CYCLE_TIME 20.0
`endif
`ifdef GATE
    `define CYCLE_TIME 20.0
`endif

module PATTERN(
    // Output signals
    clk,
	rst_n,
	in_valid,
    in_weight, 
	out_mode,
    // Input signals
    out_valid, 
	out_code
);

// ========================================
// Input & Output
// ========================================
output reg clk, rst_n, in_valid, out_mode;
output reg [2:0] in_weight;

input out_valid, out_code;
integer wait_val_time;
integer i,j,k,total_latency;
reg [2:0] in_weight_store[7:0];
// ========================================
// Parameter
// ========================================
//create a clock
parameter PERIOD = `CYCLE_TIME/2;
always #(PERIOD) clk = ~clk;
initial begin 
    in_weight = 'bx;
    out_mode = 'bx;
    reset_task;
    input_data_task;
    wait_out_value;
$finish;
end

//================================================================
// design
//================================================================

task reset_task; begin 
    rst_n = 'b1;
    in_valid = 'bx;
    out_mode = 'bx;
    in_weight = 'bx;
    total_latency = 0;

    force clk = 0;

    #`CYCLE_TIME; rst_n = 0; 
    #`CYCLE_TIME; rst_n = 1;
    
    if(out_valid !== 1'b0 || out_code !== 'b0) begin //out!==0
        $display("************************************************************");  
        $display("                          FAIL!                              ");    
        $display("*  Output signal should be 0 after initial RESET  at %8t   *",$time);
        $display("************************************************************");
        repeat(2) #`CYCLE_TIME;
        $finish;
    end
	#`CYCLE_TIME; release clk;
end endtask
task  input_data_task;
begin
   // $display("gotehre");
	repeat(2)@(negedge clk);
	in_valid = 1'b1;
	out_mode=1'b1;
	for(i=0;i<8;i=i+1)begin
        if(i==1)out_mode=1'bx;
        //in_weight is in the range of 0 to 7
        in_weight = $random();
		in_weight_store[i] = in_weight;
    //    $display("in_weight = %b",in_weight);
		@(negedge clk);
	end
    in_weight = 'bx;
	in_valid = 1'b0;
end
endtask



task wait_out_value;  begin
  wait_val_time = -1;
//   $display("wait_val_time = %d",wait_val_time);
//   $display("out_valid = %b",out_valid);
  while(out_valid !== 1) begin
	wait_val_time = wait_val_time + 1;
	if(wait_val_time == 2000)
	begin
         $display("wait_val_time = %d",wait_val_time);
		$display("***************************************************************");
        $display("                          FAIL!                              ");
		$display("*         The execution latency are over 2000 cycles.           *");
        $display("*                   Please check your design.                   *");
		$display("***************************************************************");
		repeat(2)@(negedge clk);
		$finish;
	end
	@(negedge clk);
    // $display("going arround");
    //   $display("out_valid = %b",out_valid);
  end
  total_latency = total_latency + wait_val_time;
end
endtask
endmodule


