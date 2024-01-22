/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NYCU Institute of Electronic
2023 Autumn IC Design Laboratory 
Lab09: SystemVerilog Design and Verification 
File Name   : PATTERN.sv
Module Name : PATTERN
Release version : v1.0 (Release Date: Nov-2023)
Author : Jui-Huang Tsai (erictsai.10@nycu.edu.tw)
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
`include "Usertype_BEV.sv"
`define CYCLE_TIME 12.0
// `define SEED 699
program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;

//================================================================
// parameters & integer
//================================================================
    parameter DRAM_p_r = "../00_TESTBED/DRAM/dram.dat";
    parameter SEED = 67 ;
    parameter PATNUM = 1 ;
    parameter BASE_Addr = 65536 ;
   parameter  BASE_deposit = 65536 + 255*4 ;
    logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  
    integer i, cycles, total_cycles, y;
    integer patcount;
     real CYCLE=`CYCLE_TIME/2;
//================================================================
// wire & registers 
//================================================================

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<______________CLASS RANDOM_________________>>>>>>>>>>>>>>>>>>>>>>>>
    /**
    * Class representing a random action.
    */
    class random_act;
        randc Action act_id;
        constraint range{
            act_id inside{Make_drink, Supply, Check_Valid_Date};
        }
    endclass

    /**
    * Class representing a random box from 0 to 31.
    */
    class random_box;
        randc logic [7:0] box_id;
        constraint range{
            box_id inside{[0:255]};
        }
    endclass
    // class rand_gap;	
        //     rand int gap;
        //     function new (int seed);
        //         this.srandom(seed);		
        //     endfunction 
        //     constraint limit { gap inside {[2:10]}; }
        // endclass

        // class rand_delay;	
        //     rand int delay;
        //     function new (int seed);
        //         this.srandom(seed);		
        //     endfunction 
        //     constraint limit { delay inside {[1:5]}; }
        // endclass

        // class rand_give_id;
        //     rand int give_id;
        //     function new (int seed);
        //         this.srandom(seed);		
        //     endfunction 
        //     constraint limit { give_id inside {[0:1]}; }
        //     // constraint limit { give_id inside {1}; }
        // endclass

        // class rand_land_id;
        //     rand Land land_id;
        //     function new (int seed);
        //         this.srandom(seed);		
        //     endfunction 
        //     constraint limit { land_id inside {[0:255]}; }
        // endclass

        // class rand_action;
        //     rand Action action;
        //     function new (int seed);
        //         this.srandom(seed);		
        //     endfunction 
        //     constraint limit { action inside {Seed, Water, Reap, Steal, Check_dep}; }
        // endclass

        // class rand_crop_category;
        //     rand Crop_cat crop_category;
        //     function new (int seed);
        //         this.srandom(seed);		
        //     endfunction 
        //     constraint limit { crop_category inside {Potato, Corn, Tomato, Wheat}; }
        // endclass

        // class rand_water_amount;
        //     rand Water_amnt water_amount;
        //     function new (int seed);
        //         this.srandom(seed);		
        //     endfunction 
        //     constraint limit { water_amount inside {[1:1000]}; }
        // endclass

        // // 
        // rand_gap r_gap = new(SEED) ;
        // rand_delay r_delay = new(SEED) ;
        // // 
        // rand_give_id r_give_id = new(SEED) ;
        // rand_land_id r_land_id = new(SEED) ;
        // rand_action r_action = new(SEED) ;
        // rand_crop_category r_crop_cat = new(SEED) ;
        // rand_water_amount r_water_amnt = new(SEED) ;
    logic [31:0] current_deposit, golden_deposit, golden_out_info;

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<_______________INITIAL________________>>>>>>>>>>>>>>>>>>>>>>>>
initial $readmemh(DRAM_p_r, golden_DRAM);
initial begin
    current_deposit = { golden_DRAM[BASE_deposit+0], golden_DRAM[BASE_deposit+1], golden_DRAM[BASE_deposit+2], golden_DRAM[BASE_deposit+3] };
    cycles = 0;

    patcount = 0;
    //$display("initial deposit = %h", current_deposit);
    $display ("----------------------------------------------------------------------------------------------------------------------");
    $display ("                                                  Welcome to BEV!                                                     ");
    $display ("                                                                                                                      ");
    $display ("                                        Your clock period       = %.1f ns                                             ", `CYCLE_TIME);
    $display ("----------------------------------------------------------------------------------------------------------------------");
    $display ("                                                                                                                      ");
    $display ("                                                                                                                      ");
    $display ("                                                                                                                      ");
    $display ("                                                                                                                      ");
    $display ("                                                                                                                      ");
    patcount = 0;
   reset_signal_task();
   for(int i=0;i<PATNUM;i=i+1)begin 
       input_task();
      // wait_output_task();
       //check_output_task();
   end
   YOU_PASS_task();
    repeat(2)@(negedge clk);
    $finish;

end

task reset_signal_task; begin 
    inf.rst_n = 'b1;
    inf.sel_action_valid = 'b0;
    inf.type_valid=0;
    inf.size_valid=0;
    inf.date_valid=0;
    inf.box_no_valid=0;
    inf.box_sup_valid=0;
    inf.D='bx;
    //$display("here");
   // inf.C_in_valid = 'b0;
    force clk = 0;
    #CYCLE; inf.rst_n = 0; 
    #CYCLE; inf.rst_n = 1;
    //reset check
        if(inf.out_valid !== 1'b0 ||inf.complete !== 'b0 ||inf.err_msg!==0) begin 
            $display("                Sorry, your Design output signals are not 0 during reset! at %d", $time);
            repeat(2) #CYCLE;
            fail_task();
            $finish;
        end 
	#CYCLE; release clk;
 

end endtask


task YOU_PASS_task;begin
$display ("----------------------------------------------------------------------------------------------------------------------");
$display ("                                                  Congratulations!                                                    ");
$display ("                                           You have passed all patterns!                                              ");
$display ("                                                                                                                      ");
$display ("                                        Your execution cycles   = %5d cycles                                          ", total_cycles);
$display ("                                        Your clock period       = %.1f ns                                             ", `CYCLE_TIME);
$display ("                                        Total latency           = %.1f ns                                             ", total_cycles*`CYCLE_TIME );
$display ("----------------------------------------------------------------------------------------------------------------------");
$finish;    
end endtask

task fail_task; begin
    $display ();
    $display("*                                        FAIL!                                    ");
    $display("*                              Error message from PATTERN.v                       ");
    $display("*                                                                      ");
    $display("*                                                                      ");
    $display("*                                                                      ");
    $display("*_____________________________________________________________________________________________________________________");
end endtask
logic [4:0] randtime;
task input_task; begin
    cycles = 0;
    patcount = patcount + 1;
    randtime = $urandom_range(3, 15);
    $display("random time = %d", randtime);
    repeat(randtime) @(negedge clk);
    inf.sel_action_valid = 1;
    @(negedge clk);
    inf.sel_action_valid = 0;
    repeat(3) @(negedge clk);
    inf.type_valid = 1;
    @(negedge clk);
    inf.type_valid = 0;
    inf.size_valid = 1;
    @(negedge clk);
    inf.size_valid = 0;
   repeat(3) @(negedge clk);
    inf.date_valid = 1;
    @(negedge clk);
    inf.date_valid = 0;
    @(negedge clk);
    inf.box_no_valid = 1;
    @(negedge clk);
    inf.box_no_valid = 0;
    @(negedge clk);
    inf.box_sup_valid = 0;
    @(negedge clk);
    inf.box_sup_valid = 0;
end endtask

// task wait_output_task; begin
//     cycles = 0; 
//     while(inf.out_valid!==1)begin 
//         if(cycles>100000)begin 
//             $display("                Sorry, your Design output signals are not 1 after 100000 cycles! at %d", $time);
//             repeat(2)@(negedge clk);
//             fail_task();
//             $finish;
//         end
//     end
//     total_cycles = total_cycles + cycles;
// end endtask
endprogram
