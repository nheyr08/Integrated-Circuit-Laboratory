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

`define CYCLE      20.0
`define SEED_NUMBER     28825252
`define PATTERN_NUMBER 10000

module PATTERN(
    //Output Port
    clk,
    rst_n,
    in_valid,
    in_valid2,
    matrix_size,
    matrix,
	matrix_idx,
	mode,
    //Input Port
    out_valid,
    out_value
    );
//================================================================
// clock
//================================================================

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------

output  reg          clk, rst_n, in_valid, in_valid2;
output  reg          mode;
output  reg   [ 7:0]  matrix;
output  reg  [ 3:0]  matrix_idx;
output reg [ 1:0]  matrix_size;
input                out_valid;
input        [19:0]  out_value;

initial	clk = 0;
always #(20/2.0) clk = !clk;
//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
    reg[31:0] binaryStr;
	integer PATNUM;
	integer i, j, k, l, cnt, imcol, imrow,p;
	integer patcount, imgcount, IMGNUM;
	integer gap;
	integer lat, total_cycles, start, exe_cycles, total_time;
	integer out_cycles,ans;
	integer length,total_latency,wait_val_time,output_file,input_file,input_images,input_OPT,input_kernel,input_weight;
	integer golden_image_size,golden_filter_size,golden_pad_mode,golden_act_mode,conv_result;
	integer input_img;
	integer matrix_idx_1, matrix_idx_2,mode_reg;
		integer [30:0]sizee;
	integer[30:0] plk;
initial begin
	plk=5*5*16;
	    rst_n = 'b1;
    in_valid = 'b0;
    matrix = 'bx;
    matrix_size = 'bx;
	matrix_idx = 'bx;
	in_valid2 =0;
	mode= 'bx;
	input_img=$fopen("../00_TESTBED/input.txt","r");
    output_file=$fopen("../00_TESTBED/output.txt","r");
	 k = $fscanf(input_img,"%d",mode_reg);
    k = $fscanf(input_img,"%d",matrix_idx_1);
    p = $fscanf(input_img,"%d",matrix_idx_2);
	rst_n = 1'b1;
	in_valid = 1'b0;
		if(mode_reg==1) sizee=16*16*16 ;
	else if (mode_reg==0) sizee=8*8*16;
	else if(mode_reg==2) sizee=32*32*16;
    // $display("imgae index = %d",matrix_idx_1);
    // $display("kernel index = %d",matrix_idx_2);
	reset_signal_task;
  //  $display("already reset");
	// for(patcount=1; patcount<=PATNUM; patcount=patcount+1) begin
	INPUT_IMG_K_W_task;
	WAIT_OUT_valid;
	CHECK_ANSWER;
	// end
    $display("-----------------------------------------------------------------------------------");
	// YOU_PASS_task;
	$finish;
end
task reset_signal_task; begin 
	//make sure all signals are reset
	//rst_n = 'b1;
	in_valid = 0;
	in_valid2 = 0;
	matrix= 'bx;
	matrix_idx = 'bx;
	mode= 'bx;

	total_cycles=0;
	exe_cycles = 0;
	total_time = 0;
	out_cycles = 0;
	force clk  = 0;
	#50; rst_n = 0; 
    #50; rst_n = 1;
	release clk;
	if(out_valid !== 1'b0 || out_value !== 'b0) begin //out!==0
		//YOU_FAIL;
		$display("-----------------------------------------------------------------------------------");
		$display("                       OUTPUT SIGNALS SHOULD BE ZERO AT TIME  %4t      			",$time);
		$display("                                       Your Out:  %d                           			",out_value );
		$display("                                      Your Outvalid %d                          		",out_valid) ;
		$display("-----------------------------------------------------------------------------------");
		repeat(2) #50;
		$finish;
	end
end endtask
//================================================================
// task
//================================================================
integer[30:0] pp;
task INPUT_IMG_K_W_task;  begin 

	 pp=(sizee)+(plk);
	 $display("pp=%d",pp);
	 $display("plk=%d",plk);
	 $display("sizee=%d",sizee);
	@(negedge clk);
	repeat(3)@(negedge clk);
	in_valid = 1'b1;
	for(i=0; i<(pp); i=i+1) begin//img
         k = $fscanf(input_img,"%d",matrix);
	     if(i==1)begin mode='bx;matrix_size='bx; end 
	//	$display("Img = %d",matrix);
		@(negedge clk);
		end
 	// Img='bx;
	// Weight='bx;
	// Kernel='bx;
	 in_valid=0;
	 matrix='bx;

	 repeat(3)@(negedge clk);
	 in_valid2=1'b1;
	 mode=mode_reg;
	 matrix_idx=matrix_idx_1;
	 @(negedge clk);
	 mode='bx;
	 matrix_idx=matrix_idx_2;
	 @(negedge clk);
	 in_valid2=0;
	 matrix_idx='bx;
	  $display("done at=");
end  endtask

// task input_data_task; begin
// 	repeat(2)@(negedge clk);
// end endtask

task CHECK_ANSWER; begin
	if(out_valid==1)begin 
    for(i=0;i<(4*4);i++)begin 
	$fscanf(output_file, "%b", ans);
		for(i=0;i<20;i++)begin 
			if(out_value[i]!==ans[i])begin 
			$display ("--------------------------------------------------------------------");
			$display("-----------------------------------FAIL!-------------------------------------");
			$display ("--------------------------------------------------------------------");
			$display ("                 Oh no~ PATTERN #%d  FAILED!!!                         ",patcount);
			$display ("                      Ans: %h, Yours: %h                               ",ans, out_value);		
			$display ("--------------------------------------------------------------------");
			$finish;
			end
			@(negedge clk);	
		end	

end
 $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m",patcount ,wait_val_time);
end
end
endtask
always@(*) if((out_valid!==0||out_value!==0)&&(in_valid||in_valid2))begin
	 $display("Bro outvalid shouldnt be up now with invalid cmon!");
	 $finish; 
	 end

// task INPUT_WEIGHT; begin 
// 	  #(0.5);	rst_n=0;
//   #(50/2);
//   if((out_valid !== 0)||(out_value !== 0)) 
//   begin
// 		$display("-----------------------------------------------------------------------------------");
// 		$display("-----------------------------------FAIL!-------------------------------------");
// 		$display("");
// 	$display("*   Output signal should be 0 after initial RESET at %4t     *",$time);
// 		$display("-----------------------------------------------------------------------------------");
// 	$finish;
//   end
//   #(10);	rst_n=1;
//   #(3);		release clk;
// end  endtask
task WAIT_OUT_valid; begin
  wait_val_time = -1;
  while(out_valid!== 1) begin
	wait_val_time = wait_val_time + 1;
	if(wait_val_time ==  100000)
	begin
		$display("-----------------------------------------------------------------------------------");
		$display("-----------------------------------FAIL!-------------------------------------");
		$display("         Sorry, the execution latency is over 100000 cycles.  like sheeesh !           ");
		$display("	                                  													  ");
		 $display("-----------------------------------------------------------------------------------");
		$display("                                out_valid = %d, out = %d",out_valid,out_value);
		$display("-----------------------------------------------------------------------------------");
		$display(" ");
		repeat(2)@(negedge clk);
		$finish;
	end
	if(out_valid!==1&&out_value!==0) begin
		$display("-----------------------------------------------------------------------------------");
		// $display("               Sorry, your out supposed to be 0! 					           ");
		$display("			            But your out is %d now! 			   		                  ",out_value);
		$display("-----------------------------------------------------------------------------------");
		$display("");
		repeat(2)@(negedge clk);
		$finish;
	end

	@(negedge clk);
  end
  total_latency = total_latency + wait_val_time;
end endtask

// task CALCULATE_ANS; begin
// 	if(out_value!==ans) 
// 	begin
// 		$display ("--------------------------------------------------------------------");
// 		$display ("                 Oh no~ PATTERN #%d  FAILED!!!                         ",patcount);
// 		$display ("                      Ans: %h, Yours: %h                            ",ans, out_value);		
// 		$display ("--------------------------------------------------------------------");
// 		repeat(2) @(negedge clk);		
// 		$finish;
//     end
// 	$display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m",patcount ,wait_val_time);
// end endtask

// task YOU_PASS_task; begin
// 		$display("-----------------------------------------------------------------------------------");
//   $display ("       		   ~(￣▽￣)~(＿△＿)~(￣▽￣)~(＿△＿)~(￣▽￣)~                                ");
//   $display ("             		            Congratulations!                           ");
//   $display ("               		   You have passed all patterns!                     ");
// 		$display("-----------------------------------------------------------------------------------");
     
// #(500);
// $finish;
// end endtask


endmodule






