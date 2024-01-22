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

/* define clock cycle */
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;


// ========================================
// Parameter
// ========================================
integer seed = 214 ;
integer t, i, a;
integer c_num, out_cnt;
integer f_in, f_ans, f_bit;
integer latency, total_latency;
integer _weight;
integer _mode;
integer out_num, out_num_t;
integer golden_A, golden_B, golden_C, golden_E, golden_I, golden_L, golden_O, golden_V;
integer bit_A, bit_B, bit_C, bit_E, bit_I, bit_L, bit_O, bit_V;
integer your_A, your_B, your_C, your_E, your_I, your_L, your_O, your_V;
integer pat_i;

// ========================================
// REG and WIRE
// ========================================
reg gold;

//================================================================
// design
//================================================================

initial begin
    gold=0;
    f_in  = $fopen("../00_TESTBED/input.txt", "r");
    f_ans = $fopen("../00_TESTBED/golden.txt", "r");
    f_bit = $fopen("../00_TESTBED/numbit.txt", "r");


    reset_task;

    for(pat_i=0;pat_i<102;pat_i=pat_i+1)begin
        a = $fscanf(f_ans, "%b", golden_A);
        a = $fscanf(f_ans, "%b", golden_B);
        a = $fscanf(f_ans, "%b", golden_C);
        a = $fscanf(f_ans, "%b", golden_E);
        a = $fscanf(f_ans, "%b", golden_I);
        a = $fscanf(f_ans, "%b", golden_L);
        a = $fscanf(f_ans, "%b", golden_O);
        a = $fscanf(f_ans, "%b", golden_V);

        a = $fscanf(f_bit, "%d", bit_A);
        a = $fscanf(f_bit, "%d", bit_B);
        a = $fscanf(f_bit, "%d", bit_C);
        a = $fscanf(f_bit, "%d", bit_E);
        a = $fscanf(f_bit, "%d", out_cnt);
        a = $fscanf(f_bit, "%d", bit_L);
        a = $fscanf(f_bit, "%d", bit_O);
        a = $fscanf(f_bit, "%d", bit_V);

        input_task;
        wait_out_valid_task;
    
        check_ans_task;
        $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d\033[m",pat_i ,latency);
    end

    YOU_PASS_task;
    $finish;
end


task reset_task;begin
    rst_n = 'b1;
    in_valid = 'b0;
    out_mode = 'bx;
    in_weight = 'bx;
    total_latency = 0;

    force clk = 0;
    #CYCLE; rst_n = 0; 
    #CYCLE; rst_n = 1;
    //spec check

    #CYCLE; release clk;
    

end endtask

task input_task;begin
    t = $urandom_range(2, 4);
    repeat(t) @(negedge clk);

    in_valid = 'b1;
    _mode = {$random(seed)} % 2;
    out_mode = _mode;
    for(i=0;i<8;i=i+1)begin
        if(i == 1) out_mode = 'bx;
        a = $fscanf(f_in, "%d ", _weight);
        in_weight = _weight;
        @(negedge clk);
        
    end
    
    in_valid = 'b0;
    in_weight = 'dx;
    @(negedge clk);

end endtask


task wait_out_valid_task; begin
    latency = 0;
    while(out_valid !== 1'b1) begin
	latency = latency + 1;
      if( latency == 2000) begin
          $display("********************************************************");     
          $display("                          FAIL!                              ");
          $display("*  The execution latency are over 2000 cycles  at %8t   *",$time);//over max
          $display("********************************************************");
	    repeat(2)@(negedge clk);
	    $finish;
      end
     @(negedge clk);
   end
   total_latency = total_latency + latency;
end endtask


task check_ans_task; begin
    out_num_t = 0;

    c_num = 0;


    while(out_valid === 1)begin
        

        out_cnt = out_cnt - 1;
        if(_mode === 1) begin
            if(c_num === 0)begin
                gold = golden_I[out_cnt];
                if(out_code !== golden_I[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_I FAIL!                                                            ");
                    $display ("                                                          Golden :    %b  and FULL is  %b                                                        ",golden_I[out_cnt],golden_I); 
                    $display ("                                                          Your :      %b                                                           ",out_code);
                    $display ("out_cnt:%d", out_cnt);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                  //  repeat() @(negedge clk);
                    $finish;
                end
            end
            else if(c_num === 1)begin
                gold = golden_C[out_cnt];
                if(out_code !== golden_C[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_C FAIL!                                                            ");
                    $display ("                                                                 Golden :    %b  and FULL is  %b                                                        ",golden_C[out_cnt],golden_C); 
                                        $display ("out_cnt:%d", out_cnt);

                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                //    repeat(9) @(negedge clk);
                    $finish;
                end
            end
            else if(c_num === 2)begin
                gold = golden_L[out_cnt];
                if(out_code !== golden_L[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_L FAIL!                                                            ");
                    $display ("                                                                Golden :    %b  and FULL is  %b                                                        ",golden_L[out_cnt],golden_L); 
                                        $display ("out_cnt:%d", out_cnt);

                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                  //  repeat(9) @(negedge clk);
                    $finish;
                end
            end
            else if(c_num === 3)begin
                gold = golden_A[out_cnt];
                if(out_code !== golden_A[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_A FAIL!                                                            ");
                    $display ("                                                                Golden :    %b  and FULL is  %b                                                        ",golden_A[out_cnt],golden_A); 
                                        $display ("out_cnt:%d", out_cnt);

                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                   // repeat(9) @(negedge clk);
                    $finish;
                end
            end
            else if(c_num === 4)begin
                gold = golden_B[out_cnt];
                if(out_code !== golden_B[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_B FAIL!                                                            ");
                    $display ("                                                                Golden :    %b  and FULL is  %b                                                        ",golden_B[out_cnt],golden_B); 
                                        $display ("out_cnt:%d", out_cnt);

                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                 //   repeat(9) @(negedge clk);
                    $finish;
                end
            end
            
        end
        else if(_mode === 0)begin
            if(c_num === 0)begin
                if(out_code !== golden_I[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_I FAIL!                                                            ");
                    $display ("                                                                 Golden :    %b                                                           ",golden_I[out_cnt]); 
                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                   // repeat(9) @(negedge clk);
                    $finish;
                end
            end
            else if(c_num === 1)begin
                if(out_code !== golden_L[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_L FAIL!                                                            ");
                    $display ("                                                                 Golden :    %b                                                           ",golden_L[out_cnt]); 
                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                 //   repeat(9) @(negedge clk);
                    $finish;
                end
            end
            else if(c_num === 2)begin
                if(out_code !== golden_O[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_O FAIL!                                                            ");
                    $display ("                                                                 Golden :    %b                                                           ",golden_O[out_cnt]); 
                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
              //      repeat(9) @(negedge clk);
                    $finish;
                end
            end
            else if(c_num === 3)begin
                if(out_code !== golden_V[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_V FAIL!                                                            ");
                    $display ("                                                                 Golden :    %b                                                           ",golden_V[out_cnt]); 
                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
              //      repeat(9) @(negedge clk);
                    $finish;
                end
            end
            else if(c_num === 4)begin
                if(out_code !== golden_E[out_cnt])begin
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
                    $display ("                                                                 gold_E FAIL!                                                            ");
                    $display ("                                                                 Golden :    %b                                                           ",golden_E[out_cnt]); 
                    $display ("                                                                 Your :      %b                                                           ",out_code);
                    $display ("------------------------------------------------------------------------------------------------------------------------------------------");
              //      repeat(9) @(negedge clk);
                    $finish;
                end
            end

        end




        if(out_cnt === 0) begin
            @(negedge clk);
            c_num = c_num + 1;
            if(c_num === 1 && _mode === 1) out_cnt = bit_C;
            else if(c_num === 2 && _mode === 1) out_cnt = bit_L;
            else if(c_num === 3 && _mode === 1) out_cnt = bit_A;
            else if(c_num === 4 && _mode === 1) out_cnt = bit_B;
            else if(c_num === 1 && _mode === 0) out_cnt = bit_L;
            else if(c_num === 2 && _mode === 0) out_cnt = bit_O;
            else if(c_num === 3 && _mode === 0) out_cnt = bit_V;
            else if(c_num === 4 && _mode === 0) out_cnt = bit_E;
        end
        else @(negedge clk);

    

        

    end
    

end endtask

task YOU_PASS_task; begin
    $display ("----------------------------------------------------------------------------------------------------------------------");
    $display ("                                                  Congratulations!                                                                       ");
    $display ("                                           You have passed all patterns!                                                                 ");
    $display ("                                           Your execution cycles = %5d cycles                                                            ", total_latency);
    $display ("                                           Your clock period = %.1f ns                                                               ", CYCLE);
    $display ("                                           Total Latency = %.1f ns                                                               ", total_latency*CYCLE);
    $display ("----------------------------------------------------------------------------------------------------------------------");     
    repeat(2)@(negedge clk);
    $finish;
end endtask

endmodule