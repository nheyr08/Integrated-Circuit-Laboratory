
// `include "../00_TESTBED/bem_dm.sv"
// `include "Usertype_BEV.sv"
// program automatic PATTERN(input clk, INF.PATTERN inf);
// import usertype::*;
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Parameters >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// parameter ING_MAX_VAL = (2**$bits(ING)-1);
// parameter SEED = 0;
// parameter PATNUM = 100;
// parameter DRAM_p_r="../00_TESTBED/DRAM/dram.dat";
// parameter DELAY   = 10000;
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// logic[9:0] volume;
// logic[1:0] blackRatio;
// logic[1:0] greenRatio;
// logic[1:0] milkRatio;
// logic[1:0] pineappleRatio;
// logic[1:0] black;
// logic[1:0] green;
// logic[1:0] milk;
// logic[1:0] pineapple;
// logic[4:0] day;
// logic[3:0] month;
// logic[4:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
// logic[1:0] type_;
// logic[1:0] size_;
// logic[1:0] date_;

// integer total_latency;
// integer input_delay;
// integer output_delay;
// integer dram_delay;
// integer dram_delay2;



// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Give sel action>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //Make drink
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give type >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give size >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give no DRAM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< box sup valid only once >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //Check date
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give no DRAM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //Supply
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give no DRAM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give four data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Wait outvalid >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Check answer >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

// initial begin 
//     RESET;

// end
// //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  TASKS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

// integer tot_lat;
// task RESET; begin
//     inf.rst_n            = 1;
//     inf.sel_action_valid = 0;
//     inf.type_valid       = 0;
//     inf.size_valid       = 0;
//     inf.date_valid       = 0;
//     inf.box_no_valid     = 0;
//     inf.box_sup_valid    = 0;
//     inf.D                = 'dx;
//     tot_lat              = 0;

//     #(10) inf.rst_n = 0;
//     #(10) inf.rst_n = 1;
//     if ( inf.out_valid !== 0 || inf.complete !== 0 || inf.err_msg !== 0) begin
//         $display("                            Fail                                              ");
//         $display("        Output signal should be 0 at %-12d ps  ", $time*1000);
//         $display("__________________________________________________________________________");
//         repeat(5) #(10);
//         $finish;
//     end
// end endtask

// // task exe_task; begin
// //     reset_task;
// //     dram_task;
// //     for (pat=0 ; pat<PATNUM ; pat=pat+1) begin
// //         input_task;
// //         cal_task;
// //         wait_task;
// //         check_task;
// //     end
// //      pass_task;
// //     $finish;
// // end endtask

// endprogram