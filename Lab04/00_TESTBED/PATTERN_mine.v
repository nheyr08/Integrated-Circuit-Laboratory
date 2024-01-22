//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Siamese Neural Network
//   Author     		: Betsaleel Henry (henrybetsaleel at gmail dot com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : PATTERN.v
//   Module Name : PATTERN
//   Release version : V1.0 (Release Date: 2023-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

`define CYCLE      50.0
`define SEED_NUMBER     28825252
`define PATTERN_NUMBER 10000

module PATTERN(
    //Output Port
    clk,
    rst_n,
    in_valid,
    Img,
    Kernel,
	Weight,
    Opt,
    //Input Port
    out_valid,
    out
    );
//================================================================
// clock
//================================================================

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output  reg      clk, rst_n, in_valid;
output  reg [31:0]  Img;
output  reg [31:0]  Kernel;
output  reg [31:0]  Weight;
output  reg [ 1:0]  Opt; //give it in 97 cycles 
input           out_valid;
input   [31:0]  out;
initial	clk = 0;
always #(50/2.0) clk = !clk;
//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
// parameter inst_sig_width = 23;
// parameter inst_exp_width = 8;
// parameter inst_ieee_compliance = 0;
// parameter inst_arch_type = 0;
// parameter inst_arch = 0;
//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
	parameter inst_sig_width = 23;
	parameter inst_exp_width = 8;
	parameter inst_ieee_compliance = 0;
	parameter inst_arch = 2;
	reg[31:0] binaryStr;
	integer PATNUM;
	integer i, j, k, l, cnt, imcol, imrow;
	integer patcount, imgcount, IMGNUM;
	integer gap;
	integer lat, total_cycles, start, exe_cycles, total_time;
	integer out_cycles,ans;
	integer length,total_latency,wait_val_time,output_file,input_file,input_images,input_OPT,input_kernel,input_weight;
	integer golden_image_size,golden_filter_size,golden_pad_mode,golden_act_mode,conv_result;
	integer golden_filter3[0:2][0:2];
	integer golden_filter5[0:4][0:4];
	integer golden_if[0:7][0:7];
	integer golden_of[0:7][0:7];
	reg [15:0] golden_out;

//================================================================
// REG & WIRE
//================================================================
	reg  [inst_sig_width+inst_exp_width:0] mult_a, mult_b, add_a, add_b;
	wire  [inst_sig_width+inst_exp_width:0] mult_out, add_out;

//================================================================
// initial
//================================================================
	DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) M0 (.a(mult_a), .b(mult_b), .rnd(3'b000), .z(mult_out));
	DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) A0 (.a(add_a), .b(add_b), .rnd(3'b000), .z(add_out));

initial begin
	input_images=$fopen("../00_TESTBED/input_images.txt","r");
	input_kernel=$fopen("../00_TESTBED/input_kernel.txt","r");
	input_weight=$fopen("../00_TESTBED/input_weight.txt","r");
    output_file=$fopen("../00_TESTBED/output.txt","r");
    input_OPT = $fopen("../00_TESTBED/OPT.txt","r");
    k = $fscanf(output_file,"%d",PATNUM);
	rst_n = 1'b1;
	in_valid = 1'b0;
    $display("PATNUM = %d",PATNUM);
	reset_signal_task;
	//$display("already reset");
	for(patcount=1; patcount<=PATNUM; patcount=patcount+1) begin
		INPUT_IMG_K_W_task;
		WAIT_OUT_valid;
		CHECK_ANSWER;
	end

	YOU_PASS_task;
end
task reset_signal_task; begin 
	//make sure all signals are reset
	// rst_n = 'b1;
	in_valid = 'bx;
	Img = 'bx;
	Kernel = 'bx;
	Weight = 'bx;
	Opt = 'bx;

	total_cycles=0;
	exe_cycles = 0;
	total_time = 0;
	out_cycles = 0;
	force clk  = 0;
	#50; rst_n = 0; 
    #50; rst_n = 1;
	release clk;
	if(out_valid !== 1'b0 || out !== 'b0) begin //out!==0
		//YOU_FAIL;
		$display("-----------------------------------------------------------------------------------");
		$display("                       OUTPUT SIGNALS SHOULD BE ZERO AT TIME  %4t      			",$time);
		$display("                                       Your Out:  %d                           			",out );
		$display("                                      Your Outvalid %d                          		",out_valid) ;
		$display("-----------------------------------------------------------------------------------");

		repeat(2) #50;
		$finish;
	end
end endtask
//================================================================
// task
//================================================================
task INPUT_IMG_K_W_task;  begin 
	@(negedge clk);
	in_valid = 1'b1;
	for(i=0; i<64*7; i=i+1) begin//img
		$fscanf(input_images, "%b", matrix);
		if(i==0)begin 
		$fscanf(input_OPT, "%d", Opt);
		end else begin
		Opt='bx;
		end

		if(i<4)begin 
		$fscanf(input_weight, "%b", Weight);
		end else begin 
		Weight='bx;
		end

		if(i<27) begin 
		$fscanf(input_kernel, "%b", Kernel);
		end else begin 
		Kernel='bx;
		end
		//$display("Img = %b,kernel= %b,weight = %b",Img,Kernel,Weight);
		@(negedge clk);
	end
	Img='bx;
	Weight='bx;
	Kernel='bx;
	in_valid=0;
end  endtask

// task input_data_task; begin
// 	repeat(2)@(negedge clk);
// end endtask

task CHECK_ANSWER; begin
	$fscanf(output_file, "%b", ans);
	if(out_valid==1)begin end
	if(out!==ans)begin 
		$display ("--------------------------------------------------------------------");
		$display("-----------------------------------FAIL!-------------------------------------");
		$display ("--------------------------------------------------------------------");
		$display ("                 Oh no~ PATTERN #%d  FAILED!!!                         ",patcount);
		$display ("                      Ans: %h, Yours: %h                               ",ans, out);		
		$display ("--------------------------------------------------------------------");
		repeat(2) @(negedge clk);		
		$finish;
	end else begin 
		$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m",patcount ,wait_val_time);
	end
end endtask

// task INPUT_KERNEL; begin 
// 	  #(0.5);	rst_n=0;
//   #(50/2);
//   if((out_valid !== 0)||(out !== 0)) 
//   begin
// 		$display("-----------------------------------------------------------------------------------");
// 	    $display("*   Output signal should be 0 after initial RESET at %4t     *",$time);
// 		$display("-----------------------------------------------------------------------------------");
// 	$finish;
//   end
//   #(10);	rst_n=1;
//   #(3);		release clk;
// end  endtask


task INPUT_WEIGHT; begin 
	  #(0.5);	rst_n=0;
  #(50/2);
  if((out_valid !== 0)||(out !== 0)) 
  begin
		$display("-----------------------------------------------------------------------------------");
		$display("-----------------------------------FAIL!-------------------------------------");
		$display("");
	$display("*   Output signal should be 0 after initial RESET at %4t     *",$time);
		$display("-----------------------------------------------------------------------------------");
	$finish;
  end
  #(10);	rst_n=1;
  #(3);		release clk;
end  endtask
task WAIT_OUT_valid; begin
  wait_val_time = -1;
  while(out_valid !== 1) begin
	wait_val_time = wait_val_time + 1;
	if(wait_val_time == 1000)
	begin
		$display("-----------------------------------------------------------------------------------");
		$display("-----------------------------------FAIL!-------------------------------------");
		$display("                        Sorry, the execution latency is over 1000 cycles.               ");
		$display("	                                  													  ");
		// $display("-----------------------------------------------------------------------------------");
		// $display("                                out_valid = %d, out = %d",out_valid,out);
		$display("-----------------------------------------------------------------------------------");
		$display(" ");
		repeat(2)@(negedge clk);
		$finish;
	end
	if(out_valid!==1&&out!==0) begin
		$display("-----------------------------------------------------------------------------------");
		$display("               Sorry, your out supposed to be 0! 					           ");
		$display("			            But your out is %d now! 			   		                  ",out);
		$display("-----------------------------------------------------------------------------------");
		$display("");
		repeat(2)@(negedge clk);
		$finish;
	end

	@(negedge clk);
  end
  total_latency = total_latency + wait_val_time;
end endtask

task CALCULATE_ANS; begin
	if(out!==ans) 
	begin
		$display ("--------------------------------------------------------------------");
		$display ("                 Oh no~ PATTERN #%d  FAILED!!!                         ",patcount);
		$display ("                      Ans: %h, Yours: %h                            ",ans, out);		
		$display ("--------------------------------------------------------------------");
		repeat(2) @(negedge clk);		
		$finish;
    end
	$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m",patcount ,wait_val_time);
end endtask

task YOU_PASS_task; begin
		$display("-----------------------------------------------------------------------------------");
  $display ("       		   ~(￣▽￣)~(＿△＿)~(￣▽￣)~(＿△＿)~(￣▽￣)~                                ");
  $display ("             		            Congratulations!                           ");
  $display ("               		   You have passed all patterns!                     ");
		$display("-----------------------------------------------------------------------------------");
     
#(500);
$finish;
end endtask


endmodule






