/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NYCU Institute of Electronic
2023 Autumn IC Design Laboratory 
Lab10: SystemVerilog Coverage & Assertion
File Name   : CHECKER.sv
Module Name : CHECKER
Release version : v1.0 (Release Date: Nov-2023)
Author : Jui-Huang Tsai (erictsai.10@nycu.edu.tw)
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

`include "Usertype_BEV.sv"
module Checker(input clk, INF.CHECKER inf);
import usertype::*;

/*
    Coverage Part
*/

/*
class BEV;
    Bev_Type bev_type;
    Bev_Size bev_size;
endclass

BEV bev_info = new();

always_ff @(posedge clk) begin
    if (inf.type_valid) begin
        bev_info.bev_type = inf.D.d_type[0];
    end
end
*/

/*
1. Each case of Beverage_Type should be select at least 100 times.
*/


// covergroup Spec1 @(posedge clk);
//     option.per_instance = 1;
//     option.at_least = 100;
//     btype:coverpoint bev_info.bev_type{
//         bins b_bev_type [] = {[Black_Tea:Super_Pineapple_Milk_Tea]};
//     }
// endgroup


/*
2.	Each case of Bererage_Size should be select at least 100 times.
*/

/*
3.	Create a cross bin for the SPEC1 and SPEC2. Each combination should be selected at least 100 times. 
(Black Tea, Milk Tea, Extra Milk Tea, Green Tea, Green Milk Tea, Pineapple Juice, Super Pineapple Tea, Super Pineapple Tea) x (L, M, S)
*/

/*
4.	Output signal inf.err_msg should be No_Err, No_Exp, No_Ing and Ing_OF, each at least 20 times. (Sample the value when inf.out_valid is high)
*/

/*
5.	Create the transitions bin for the inf.D.act[0] signal from [0:2] to [0:2]. Each transition should be hit at least 200 times. (sample the value at posedge clk iff inf.sel_action_valid)
*/

/*
6.	Create a covergroup for material of supply action with auto_bin_max = 32, and each bin have to hit at least one time.
*/

/*
    Create instances of Spec1, Spec2, Spec3, Spec4, Spec5, and Spec6
*/
// Spec1_2_3 cov_inst_1_2_3 = new();

/*
    Asseration
*/
logic [2:0] act_capture;
    always_comb begin //act capture
        if(!inf.rst_n) begin 
            act_capture=0;
        end
        else begin 
            if(inf.sel_action_valid) begin 
                act_capture=inf.D.d_act[0];
            end else begin 
                act_capture=act_capture;
            end
        end
    end
/*
    If you need, you can declare some FSM, logic, flag, and etc. here.
*/
logic [15:0]ctr;
always_ff @(posedge clk or negedge inf.rst_n) begin
    if (!inf.rst_n) ctr <= 0;
    else ctr <= ctr + 1;
end

/*
    1. All outputs signals (including BEV.sv and bridge.sv) should be zero after reset.
*/
always @(negedge inf.rst_n) begin
	#1;
	assert_1 : assert (((inf.out_valid===0)&&
                         (inf.err_msg===0)&&
                         (inf.complete==='b0)&&
                         (inf.C_addr===0)&&
                         (inf.C_data_w===0)&&
                         (inf.C_in_valid===0)&&
                         (inf.C_r_wb===0)&&
                         (inf.AR_VALID === 0)&&
                         (inf.AR_ADDR === 0 )&&
                         (inf.R_READY === 0 )&&
                         (inf.AW_VALID === 0) &&
                         (inf.AW_ADDR === 0 )&&
                         (inf.W_VALID === 0 )&&
                         (inf.W_DATA === 0 )&&
                         (inf.B_READY === 0)&&
                        (inf.C_out_valid===0)&&
                        (inf.C_data_r===0)))
    	else begin
		    $display("Assertion 1 is violated");
		    printsignals(); $fatal;; 
	    end
end

/*
    2.	Latency should be less than 1000 cycles for each operation.
*/ 
// end
assert_2 : assert property ( @(posedge clk) ((act_capture==0||act_capture==1)&&(inf.box_no_valid==1)) |=> ( ##[1:1000] inf.out_valid==1 ) )
else
begin
	$display("Assertion 2 is violated");
    $display("ctr = %d", ctr);
	    printsignals(); 
        $fatal;; 
end
/*
    3. If out_valid does not pull up, complete should be 0.
*///if out_valid is low, complete should be low

assert_3 : assert property ( @(negedge clk) (inf.complete==1&&inf.out_valid==1) |-> (inf.err_msg==0) )
else
begin
    $display("Assertion 3 is violated");
        printsignals();
    $fatal; 
end
/*
4. Next input valid will be valid 1-4 cycles after previous input valid fall.
*/// assert_e4 : assert property ( @(posedge clk) (inf.sel_action_valid==1) |-> ##[1:4] (inf.type_valid==1) )
// else
// begin
// $display("Assertion 4 is violated");
// printsignals();
// $fatal; 
// end
assert_4 :assert property ( @(posedge clk) (inf.type_valid==1&&act_capture!=2)  |-> ##[1:4] ( inf.size_valid==1) )  
else begin
 	$display("Assertion 4 is violated");
    printsignals();
 	$fatal; 
end

assert_4_1 :assert property ( @(posedge clk) (inf.size_valid==1&&act_capture==1)  |-> ##[1:4] ( inf.date_valid==1) )  
else begin
 	$display("Assertion 4 is violated");
    printsignals();
 	$fatal; 
end

assert_4_2 :assert property ( @(posedge clk) (inf.date_valid==1)  |-> ##[1:4] ( inf.box_no_valid==1) )  
else begin
 	$display("Assertion 4 is violated");
    printsignals();
 	$fatal; 
end

assert_4_3 :assert property ( @(posedge clk) (inf.box_no_valid==1&&act_capture!=0&&act_capture!=2)  |-> ##[1:4] ( inf.box_sup_valid==1) )  
else begin
 	$display("Assertion 4 is violated");
    $display("part4_");
    printsignals();
 	$fatal; 
end
logic[2:0] supfour;

assert_4_3_ :assert property ( @(posedge clk)
                                      ( inf.box_sup_valid==1&&act_capture==0) |-> 
                             ##[1:4]  ( inf.box_sup_valid==1) |->
                             ##[1:4] ( inf.box_sup_valid==1)|->
                             ##[1:4] ( inf.box_sup_valid==1)|->
                                     ( inf.box_sup_valid==1) )
else begin
 	$display("Assertion 4 is violated");
    $display("part4_");
    printsignals();
 	$fatal; 
end
//infbox supply is valid for 4 cycles the cycles can be separated by 1 to 4 cycles after that it should be invalid


// assert_4_4 :assert property ( @(posedge clk) (inf.box_no_valid==1&&act_capture==1&&supfour<4)  |-> ##[1:4] ( inf.box_no_valid==1) )  
// else begin
//  	$display("Assertion 4 is violated");
//     $display("part4_");
//     printsignals();
//  	$fatal; 
// end
// assert_4__ :assert property ( @(posedge clk) (inf.sel_action_valid==1&&act_capture==2)  |-> ##[1:4] ( inf.date_valid==1) )  
// else begin
//  	$display("Assertion 4 is violated");
//     printsignals();
//  	$fatal; 
// end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>make drink<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// assert_4_m1 :assert property ( @(posedge clk) (inf.sel_action_valid==1&&act_capture==0)  |-> ##[1:4] ( inf.size_valid==1) )  
// else begin
//  	$display("Assertion 4 is violated");
//     printsignals();
//  	$fatal; 
// end
logic [4:0]date_capture;
    always_ff@(posedge clk or negedge inf.rst_n) begin //type_capture
        if(!inf.rst_n) begin 
          date_capture<=0;
        end
        else begin 
            if(inf.date_valid) begin
                date_capture<=inf.D.d_date;
            end else begin 
                date_capture<=date_capture;
            end
        end
    end


/*
    5. All input valid signals won't overlap with each other. 
*/
logic no_one;
assign no_one = !( inf.box_sup_valid || inf.type_valid || inf.box_no_valid || inf.sel_action_valid || inf.size_valid || inf.date_valid) ;
assert_5 :assert property ( @(posedge clk)   $onehot({ inf.box_sup_valid, inf.type_valid, inf.box_no_valid , inf.date_valid, inf.sel_action_valid,inf.size_valid,no_one }) )  
else
begin
 	$display("Assertion 5 is violated");
 	printsignals();$fatal; 
end
/*
    6. Out_valid can only be high for exactly one cycle.
*/
assert_6 : assert property ( @(posedge clk)  (inf.out_valid===1) |=> (inf.out_valid===0) )
else
begin
	$display("Assertion 6 is violated");
	printsignals();
    $fatal; 
end
/*
    7. Next operation will be valid 1-4 cycles after out_valid fall.
*/
assert_7 :assert property ( @(posedge clk) (inf.out_valid==1)  |-> ##[1:4] ( inf.sel_action_valid==1) )  
else begin
 	$display("Assertion 7 is violated");
    printsignals();
 	$fatal; 
end
/*
    8. The input date from pattern should adhere to the real calendar. (ex: 2/29, 3/0, 4/31, 13/1 are illegal cases)
    real dates are months are 1-12, days are 1-31 and 28 days for feb, 30 days for 4,6,9,11, 31 days for 1,3,5,7,8,10,12
*/

//assert for february
assert_8_1 : assert property ( @(posedge clk) (inf.date_valid===1) |-> (
    (inf.D.d_date[0][8:5] == 2) |-> (inf.D.d_date[0][4:0] <= 28 && inf.D.d_date[0][4:0] != 0)
))
else begin
    $display("Assertion 8 is violated");
    $display("part1");
    printsignals();
    $fatal; 
end
assert_8_30daysmonths: assert property ( @(posedge clk) (inf.date_valid===1) |-> (
    (inf.D.d_date[0][8:5] == 4 || inf.D.d_date[0][8:5] == 6 || inf.D.d_date[0][8:5] == 9 || inf.D.d_date[0][8:5] == 11) |-> (inf.D.d_date[0][4:0] <= 30&& inf.D.d_date[0][4:0] != 0)
))
else begin
    $display("Assertion 8 is violated");
    printsignals();
    $display("part2");
    $fatal; 
end
assert_8_31daysmonths: assert property ( @(posedge clk) (inf.date_valid===1) |-> (
    (inf.D.d_date[0][8:5] == 1 || inf.D.d_date[0][8:5] == 3 || inf.D.d_date[0][8:5] == 5 || inf.D.d_date[0][8:5] == 7 || inf.D.d_date[0][8:5] == 8 || inf.D.d_date[0][8:5] == 10 || inf.D.d_date[0][8:5] == 12) |-> (inf.D.d_date[0][4:0] <= 31&& inf.D.d_date[0][4:0] != 0)
))
else begin
    $display("Assertion 8 is violated");
    $display("part3");
    printsignals();
    $fatal; 
end
assert_8_31ddaysmonths: assert property ( @(posedge clk) (inf.date_valid===1) |-> (
    (inf.D.d_date[0][8:5] > 12) |-> (inf.D.d_date[0][4:0] == 0)
))
else begin
    $display("Assertion 8 is violated");
    $display("part4");
    printsignals();
    $fatal; 
end
/*
    9. C_in_valid can only be high for one cycle and can't be pulled high again before C_out_valid
*/
assert_9_1 : assert property ( @(posedge clk) (inf.C_in_valid===1) |=> (inf.C_in_valid===0) )
else
begin
    $display("Assertion 9 is violated");
    printsignals();
        $display("part4");
    $fatal; 
end
logic [3:0] date_state[1:0];
    always_ff@(posedge clk or negedge inf.rst_n) begin //date from input
        if(!inf.rst_n) begin 
            date_state[0]<=0;
            date_state[1]<=0;
        end
        else begin 
            if(inf.date_valid) begin
                date_state[0]<=inf.D.d_date[0][4:0];
                date_state[1]<=inf.D.d_date[0][8:5];
            end else begin 
                date_state[0]<=date_state[0];
                date_state[1]<=date_state[1];
            end
        end
    end
task printsignals;
begin //print all signals value 
$display("CTR = %d", ctr);
$display("day [0] = %d", date_state[0]);
$display("month [1] = %d", date_state[1]);
$display("inf.rst_n = %d", inf.rst_n);
$display("inf.sel_action_valid = %d", inf.sel_action_valid);
$display("inf.type_valid = %d", inf.type_valid);
$display("actcapture = %d", act_capture);
$display("inf.size_valid = %d", inf.size_valid);
$display("inf.date_valid = %d", inf.date_valid);
$display("inf.box_no_valid = %d", inf.box_no_valid);
$display("inf.box_sup_valid = %d", inf.box_sup_valid);
$display("inf.D.d_type = %d", inf.D.d_type);
$display("inf.D.d_size = %d", inf.D.d_size);
$display("inf.D.d_date = %d", inf.D.d_date);
//$display("inf.D.d_box_no = %d", inf.D.d_box_no);
//$display("inf.D.d_box_sup = %d", inf.D.d_box_sup);

$display("inf.out_valid = %d", inf.out_valid);
$display("inf.err_msg = %d", inf.err_msg);
$display("inf.complete = %d", inf.complete);
$display("inf.C_addr = %d", inf.C_addr);
$display("inf.C_data_w = %d", inf.C_data_w);
$display("inf.C_in_valid = %d", inf.C_in_valid);
$display("inf.C_r_wb = %d", inf.C_r_wb);
$display("inf.C_out_valid = %d", inf.C_out_valid);
$display("inf.C_data_r = %d", inf.C_data_r);
$display("inf.AR_VALID = %d", inf.AR_VALID);
$display("inf.AR_ADDR = %d", inf.AR_ADDR);
$display("inf.R_READY = %d", inf.R_READY);
$display("inf.AW_VALID = %d", inf.AW_VALID);
$display("inf.AW_ADDR = %d", inf.AW_ADDR);
$display("inf.W_VALID = %d", inf.W_VALID);
$display("inf.W_DATA = %d", inf.W_DATA);
$display("inf.B_READY = %d", inf.B_READY);
end
endtask

initial begin
if(ctr==1000) begin
    $display("Assertion 2 is violated");
    printsignals();
    $finish;
end
end
endmodule
