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
program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Parameters >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
parameter SEED = 1111;
parameter PATNUM = 8750;
parameter DRAM_p_r="../00_TESTBED/DRAM/dram.dat";
parameter DELAY   = 1000;
parameter Black_Tea_=0;
parameter Milk_Tea_=1;
parameter Extra_Milk_Tea_=2;
parameter Green_Tea_=3;
parameter Green_Milk_Tea_=4;
parameter Pineapple_Juice_=5;
parameter Super_Pineapple_Tea_=6;
parameter Super_Pineapple_Milk_Tea_=7;
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
logic expired_flag;
logic Element_overflow_flag;
logic[1:0] golden_err;
logic golden_complete;
logic [7:0] date_state_[1:0];
//logic [63:0] _box_num;
logic [11:0] supply_nums[3:0];
integer total_latency;
integer input_delay;
integer output_delay;
integer exe_lat;
//integer _Bev_size_capture;
// //logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  // 256 box
// logic [7:0] golden_DRAM[ (65536) : ((65536+256*8)-1) ];
logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  // 256 box
logic [7:0] Month_y,Day_y;
logic [11:0] Milk_y,Green_tea_y,Black_tea_y,Pineapple_juice_y;

initial begin
    $readmemh( DRAM_p_r, golden_DRAM );
end

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Give sel action>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//Make drink
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give type >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give size >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give no DRAM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< box sup valid only once >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//Check date
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give no DRAM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//Supply
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give no DRAM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Give four data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Wait outvalid >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Check answer >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
integer pat=0;
initial begin 
    RESET;
    pat=0;
    repeat(3) @(negedge clk);
    repeat(PATNUM) begin
        if(pat!=0)
        Delay_task;
        INPUT;
        WAIT_OUTVALID;
        CHECK_ANS;
        $display("                            Pass pattern %0d at %-12d ps  ", pat, $time*1000);   
        pat=pat+1;
    end
     YOUPASS;
    $finish;
end
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< CLASSESS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    class rand_action_;
        rand Action act_c;
        function new (int seed);
            this.srandom(seed);
        endfunction 
        constraint limit { act_c inside
                     {Make_drink,Supply,Check_Valid_Date}; }
                  //  {Make_drink}; }
                   // {Supply}; }
                  // {Check_Valid_Date}; }
    endclass

    class rand_bevtype_;
        rand Bev_Type Bevtype;
        function new (int seed);
            this.srandom(seed);		
        endfunction 
        constraint limit { Bevtype inside { Milk_Tea, Extra_Milk_Tea, 
                    Green_Tea, Green_Milk_Tea, Pineapple_Juice,
                    Super_Pineapple_Tea,Black_Tea, Super_Pineapple_Milk_Tea};}
    endclass
    class rand_bevsize_;
        rand Bev_Size Bevsize;
        function new (int seed);
            this.srandom(seed);		
        endfunction 
        constraint limit { Bevsize inside { L, M, S};}
    endclass

class rand_date_;
    rand Date date;
    function new(int seed);
        this.srandom(seed);        
    endfunction 
    
    constraint valid_month {
        date.M inside {[1:12]}; // Constrain month to valid range 1-12
    }
    
    constraint valid_dates {
        if (date.M == 2) {
            date.D inside {[1:28]};
        } else if (date.M == 4 || date.M == 6 || date.M == 9 || date.M == 11) {
            date.D inside {[1:30]};
        } else {
            date.D inside {[1:31]};
        }
    }
endclass
    class Boxno_;
        rand Barrel_No boxno;
        function new(int seed);
            this.srandom(seed);        
        endfunction 
        constraint limit { boxno inside {[0:255]};}
    endclass
    class Boxsup_; //thats wrong for now
        rand logic[11:0] boxsup;
        function new(int seed);
            this.srandom(seed);        
        endfunction 
        constraint limit { boxsup inside {[0:'hfff]};}
    endclass

    class rand_delay_val;
        rand logic [2:0] delay_val;
        function new(int seed);
            this.srandom(seed);        
        endfunction 
        constraint limit { delay_val inside {[1:4]};}
    endclass


    rand_bevsize_ r_bevsize_=new(SEED);
    rand_action_  r_act_=new(SEED);
    rand_bevtype_ r_bevtype_=new(SEED);
    rand_date_    r_date_=new(SEED);
    Boxno_        r_boxno_=new(SEED);
    Boxsup_       r_boxsup_=new(SEED);
    rand_delay_val r_delay_=new(SEED);
    logic         [16:0] myaddr;

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  TASKS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    task INPUT; begin 
    selactionvalidtask;
    Delay_task;

    case(r_act_.act_c)//Make drink
        0://MAKE_DRINK 
        begin 
            typevalidtask;
            Delay_task;
            sizevalidtask;
            Delay_task;
            datevalidtask;
            Delay_task;
            boxnovalidtask;
            myaddr= r_boxno_.boxno;
        //  $display("myaddr = %b", myaddr);
            computeans_make_drink;

        end
        1://SUPPLY
        begin 
            datevalidtask;
            Delay_task;
            boxnovalidtask;
            Delay_task;
            boxsupvalidtask;
            myaddr= r_boxno_.boxno;
            computeans_supply;
            // $display("ingredient overflow = %b", Element_overflow_flag);
            // $display("golden err = %b", golden_err);
            // $display("golden complete = %b", golden_complete);
            
        end
        2://CHECK_VALID_DATE
        begin 
            datevalidtask;
            Delay_task;
            boxnovalidtask;
            myaddr= r_boxno_.boxno;
            computeanswer_check_valid;
        end
    endcase
    end
    endtask


    task boxsupvalidtask; begin 
        inf.box_sup_valid = 1;
        r_boxsup_.randomize();
        inf.D = r_boxsup_.boxsup;
        supply_nums[0]=r_boxsup_.boxsup;
        // $display("supply_nums[0] = %h", supply_nums[0]);
        @(negedge clk);
        inf.box_sup_valid = 0;
        Delay_task;
        inf.box_sup_valid = 1;
        r_boxsup_.randomize();
        inf.D = r_boxsup_.boxsup;
        supply_nums[1]=r_boxsup_.boxsup;
        // $display("supply_nums[1] = %h", supply_nums[1]);
        @(negedge clk);
        inf.box_sup_valid = 0;
        Delay_task;
        inf.box_sup_valid = 1;
        r_boxsup_.randomize();
        inf.D = r_boxsup_.boxsup;
        supply_nums[2]=r_boxsup_.boxsup;
        // $display("supply_nums[2] = %h", supply_nums[2]);
        @(negedge clk);
        inf.box_sup_valid = 0;
        Delay_task;
        inf.box_sup_valid = 1;
        r_boxsup_.randomize();
        inf.D = r_boxsup_.boxsup;
        supply_nums[3]=r_boxsup_.boxsup;
        // $display("supply_nums[3] = %h", supply_nums[3]);
        @(negedge clk);
        inf.box_sup_valid = 0;
    end 
    endtask;
    logic [4:0] new_day,new_month;
    task computeans_supply;begin 
        readfromdram;
        check_dateok;
        Deduct_golden_ans_supply;
        new_day=r_date_.date[4:0];
        new_month=r_date_.date[8:5];
    end
    endtask
    task Deduct_golden_ans_supply; begin
        // $display("milk_y = %h", Milk_y);    
        // $display("Pineapple_juice_y = %h", Pineapple_juice_y);
        // $display("Black_tea_y = %h", Black_tea_y);
        // $display("Green_tea_y = %h", Green_tea_y);
        // $display("Month_y = %h", Month_y);
        // $display("Day_y = %h", Day_y);
        // $display("");
        Element_overflow_flag=(Milk_y+supply_nums[2]>4095)||
                            (Pineapple_juice_y+supply_nums[3]>4095)||
                                (Black_tea_y+supply_nums[0]>4095)||
                                (Green_tea_y+supply_nums[1]>4095);
                // wire  Element_overflow=(Milk_box+Ingredient_box[1])>4095||
                //       (Pineapple_juice_box+Ingredient_box[0])>4095||
                //       (Black_tea_box+Ingredient_box[3])>4095||
                //       (Green_tea_box+Ingredient_box[2])>4095;
                    // $display("supply_nums[0] = %h", supply_nums[0]);
                    // $display("supply_nums[1] = %h", supply_nums[1]);
                    // $display("supply_nums[2] = %h", supply_nums[2]);
                    // $display("supply_nums[3] = %h", supply_nums[3]);


        if(Milk_y+supply_nums[2]>4095) begin
            Milk_y=4095;
        end
        else begin
            Milk_y=Milk_y+supply_nums[2];
        end
        if(Pineapple_juice_y+supply_nums[3]>4095) begin
            Pineapple_juice_y=4095;
        end
        else begin
            Pineapple_juice_y=Pineapple_juice_y+supply_nums[3];
        end
        if(Black_tea_y+supply_nums[0]>4095) begin
            Black_tea_y=4095;
        end
        else begin
            Black_tea_y=Black_tea_y+supply_nums[0];
        end
        if(Green_tea_y+supply_nums[1]>4095) begin
            Green_tea_y=4095;
        end
        else begin
            Green_tea_y=Green_tea_y+supply_nums[1];
        end
        // $display("");
        // $display("milk_y1 = %h", Milk_y);    
        // $display("Pineappl1e_juice_y = %h", Pineapple_juice_y);
        // $display("Black_tea1_y = %h", Black_tea_y);
        // $display("Green_tea1_y = %h", Green_tea_y);
        // $display("");
        
        // Milk_y=Milk_y+supply_nums[0];
        // Green_tea_y=Green_tea_y+supply_nums[1];
        // Black_tea_y=Black_tea_y+supply_nums[2];
        // Pineapple_juice_y=Pineapple_juice_y+supply_nums[3];

        // golden_DRAM[65536+myaddr*8+7]=Black_tea_y[7:0];
        // golden_DRAM[65536+myaddr*8+6][7:4]=Black_tea_y[11:8];
        // golden_DRAM[65536+myaddr*8+6][3:0]=Green_tea_y[3:0];
        // golden_DRAM[65536+myaddr*8+5]=Green_tea_y[7:0];
        // golden_DRAM[65536+myaddr*8+3]=Milk_y[7:0];
        // golden_DRAM[65536+myaddr*8+2][7:4]=Milk_y[11:8];
        // golden_DRAM[65536+myaddr*8+2][3:0]=Pineapple_juice_y[3:0];
        // golden_DRAM[65536+myaddr*8+1]=Pineapple_juice_y[7:0];
        // golden_DRAM[65536+myaddr*8+4]=new_month;
        // golden_DRAM[65536+myaddr*8]=new_day;
        
            {golden_DRAM[65536+myaddr*8+7], golden_DRAM[65536+myaddr*8+6][7:4]} = Black_tea_y;
            {golden_DRAM[65536+myaddr*8+6][3:0], golden_DRAM[65536+myaddr*8+5]} = Green_tea_y;
            {golden_DRAM[65536+myaddr*8+3], golden_DRAM[65536+myaddr*8+2][7:4]} = Milk_y;
            {golden_DRAM[65536+myaddr*8+2][3:0], golden_DRAM[65536+myaddr*8+1]} = Pineapple_juice_y;
            golden_DRAM[65536+myaddr*8+4] = date_state_[1];
            golden_DRAM[65536+myaddr*8]   = date_state_[0];
        //   $display("Data Sup: %h", golden_DRAM[65536+myaddr*8+7:65536+myaddr*8]);
        //$display("pp0: %h", {golden_DRAM[65536+myaddr*8+7], golden_DRAM[65536+myaddr*8+6][7:4],golden_DRAM[65536+myaddr*8+6][3:0], golden_DRAM[65536+myaddr*8+5],golden_DRAM[65536+myaddr*8+3], golden_DRAM[65536+myaddr*8+2][7:4],golden_DRAM[65536+myaddr*8+2][3:0], golden_DRAM[65536+myaddr*8+1],golden_DRAM[65536+myaddr*8+4],golden_DRAM[65536+myaddr*8]});


        if(Element_overflow_flag==1) begin
            golden_err=3;
        end
        else begin
            golden_err=0;
        end
        if(golden_err==0) begin
            golden_complete=1;
        end
        else begin
            golden_complete=0;
        end
    end
    endtask

    task selactionvalidtask; begin
        inf.sel_action_valid = 1;
        r_act_.randomize();
        inf.D = r_act_.act_c;
        @(negedge clk);
        inf.sel_action_valid = 0;
    end endtask
    task typevalidtask; begin
        inf.type_valid = 1;
        r_bevtype_.randomize();
        inf.D = r_bevtype_.Bevtype;
        @(negedge clk);
        inf.type_valid = 0;
    end endtask
    task sizevalidtask; begin
        inf.size_valid = 1;
        r_bevsize_.randomize();
        inf.D = r_bevsize_.Bevsize;
        @(negedge clk);
        inf.size_valid = 0;
    end endtask
    task datevalidtask; begin
        inf.date_valid = 1;
        r_date_.randomize();
        inf.D = r_date_.date;
        @(negedge clk);
        inf.date_valid = 0;
    end endtask
    task boxnovalidtask; begin
        inf.box_no_valid = 1;
        r_boxno_.randomize();
        inf.D = r_boxno_.boxno;
        @(negedge clk);
        inf.box_no_valid = 0;
    end endtask

    task RESET; begin
        inf.rst_n            = 1;
        inf.sel_action_valid = 0;
        inf.type_valid       = 0;
        inf.size_valid       = 0;
        inf.date_valid       = 0;
        inf.box_no_valid     = 0;
        inf.box_sup_valid    = 0;
        inf.D                = 'dx;
        total_latency        = 0;
        
        #(10) inf.rst_n = 0;
        #(10) inf.rst_n = 1;
        // if ( inf.out_valid !== 0 || inf.complete !== 0 || inf.err_msg !== 0) begin
        //     $display("                            Fail                                              ");
        //     $display("        Output signal should be 0 at %-12d ps  ", $time*1000                   );
        //     $display("__________________________________________________________________________"    );
        //     repeat(5) #(10);
        //     $finish;
        // end
    end endtask
  // integer input_delay;
    task Delay_task; begin
        r_delay_.randomize();
        case (r_delay_.delay_val%4)
            1: repeat (1) @(negedge clk);
            2: repeat (2) @(negedge clk);
            3: repeat (3) @(negedge clk);
            4: repeat (4) @(negedge clk);
            default: repeat (1) @(negedge clk);
        endcase
    end 
    endtask

    task WAIT_OUTVALID; begin
        exe_lat = -1;
        while(inf.out_valid !== 1) begin
            if (inf.complete !== 0 || inf.err_msg !== 0) begin
                $display("    Output signal should be 0 at %-12d ps  ", $time*1000);
               // $finish;
            end
            if (exe_lat == 1000) begin
                $display("    The execution latency at %-12d ps is over %5d cycles  ", $time*1000, exe_lat);
              //  $finish; 
            end
            exe_lat = exe_lat + 1;
            @(negedge clk);
        end
    end endtask

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Check answer::MAke drink >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    parameter Large=2'b00,Medium=2'b01,Small=2'b11;//960 ,720,480
    parameter Small_size=360,Medium_size=360,Large_size=480;
    logic [63:0] _box_num;
    logic [8:0] date_capture;
    logic [8:0] addr;
    logic [8:0] Action_capture; //checkvalid,make suply
    logic [15:0] box_no; 
    logic [3:0] _Bev_size_capture;
    logic [7:0] date_state[1:0];
    logic  [11:0] Milk_box;//= _box_num[31:20];//{_box_num[39:32],_box_num[47:44]};
    logic  [11:0] Pineapple_juice_box;//=_box_num[19:8]; //{_box_num[55:48],_box_num[43:40]};
    logic  [11:0] Black_tea_box;//=_box_num[63:52]; //{_box_num[7:0],_box_num[15:12]};
    logic  [11:0]  Green_tea_box;//=_box_num[51:40]; //{_box_num[11:8],_box_num[23:16]};
    logic  [7:0]  day;//=_box_num[7:0];
    logic  [7:0]  month;//=_box_num[39:32];
    logic  Element_overflow;
    logic [11:0] Black_tea_used; //=(Ingr
    logic [11:0] Green_tea_used;//=(Ingre
    logic [11:0] Milk_used;//=(Ingredient
    logic [11:0] Pineapple_juice_used;//
    logic insuficient_Pineaple;//= (Pineapple_juice_box<Pineapple_juice_used);  //(_Bev_size_capture==Large&&Pineapple_juice_box<Large_size)||(_Bev_size_capture==Medium&&Pineapple_juice_box<Medium_size)||(_Bev_size_capture==Small&&Pineapple_juice_box<Small_size);
    logic insuficient_Milk;//= (Milk_box<Milk_used);                //(_Bev_size_capture==Large&&Milk_box<Large_size)||(_Bev_size_capture==Medium&&Milk_box<Medium_size)||(_Bev_size_capture==Small&&Milk_box<Small_size);
    logic insuficient_Green_Tea;//= (Green_tea_box<Green_tea_used);       //(_Bev_size_capture==Large&&Green_tea_box<Large_size)||(_Bev_size_capture==Medium&&Green_tea_box<Medium_size)||(_Bev_size_capture==Small&&Green_tea_box<Small_size);
    logic insuficient_Black_Tea;//= (Black_tea_box<Black_tea_used);      //(_Bev_size_capture==Large&&Black_tea_box<Large_size)||(_Bev_size_capture==Medium&&Black_tea_box<Medium_size)||(_Bev_size_capture==Small&&Black_tea_box<Small_size);
    logic insuficent_material;
task readfromdram;
//    _box_num =getnumbox(myaddr);
  // $display("myaddr = %h", myaddr);
//    $display("boxnum = %h", _box_num);

    Black_tea_y       = {golden_DRAM[65536+myaddr*8+7], golden_DRAM[65536+myaddr*8+6][7:4]};
    Green_tea_y       = {golden_DRAM[65536+myaddr*8+6][3:0], golden_DRAM[65536+myaddr*8+5]};
    Milk_y            = {golden_DRAM[65536+myaddr*8+3], golden_DRAM[65536+myaddr*8+2][7:4]};
    Pineapple_juice_y = {golden_DRAM[65536+myaddr*8+2][3:0], golden_DRAM[65536+myaddr*8+1]};
    Month_y = golden_DRAM[65536+myaddr*8+4];
    Day_y =  golden_DRAM[65536+myaddr*8];
    //display all 
    //$display("Black_tea_ = %h", Black_tea_);
    //$display("Green_tea_ = %h", Green_tea_);
    //$display("Milk_ = %h", Milk_);
    //$display("Pineapple_juice_ = %h", Pineapple_juice_);
    //$display("Month_ = %h", Month_);
    //$display("Day_ = %h", Day_);
endtask
task computeans_make_drink; begin 
    readfromdram;
    Drink_quantity;
    check_dateok;
    //.........drink type: there's 7
    //.........drink size: there's 3
    //.........drink date: there's 31*12(look in dram if expired or not leads to error)
    //.........drink no: there's 256
    insuficient_Pineaple= (Pineapple_juice_y<Pineapple_juice_used);  //(_Bev_size_capture==Large&&Pineapple_juice_box<Large_size)||(_Bev_size_capture==Medium&&Pineapple_juice_box<Medium_size)||(_Bev_size_capture==Small&&Pineapple_juice_box<Small_size);
    insuficient_Milk= (Milk_y<Milk_used);                //(_Bev_size_capture==Large&&Milk_box<Large_size)||(_Bev_size_capture==Medium&&Milk_box<Medium_size)||(_Bev_size_capture==Small&&Milk_box<Small_size);
    insuficient_Green_Tea= (Green_tea_y<Green_tea_used);       //(_Bev_size_capture==Large&&Green_tea_box<Large_size)||(_Bev_size_capture==Medium&&Green_tea_box<Medium_size)||(_Bev_size_capture==Small&&Green_tea_box<Small_size);
    insuficient_Black_Tea= (Black_tea_y<Black_tea_used);   
    insuficent_material= insuficient_Pineaple||insuficient_Milk||insuficient_Green_Tea||insuficient_Black_Tea;
    //  Element_overflow=(Milk_box+Ingredient_box[1])>4095||(Pineapple_juice_box+Ingredient_box[0])>4095||(Black_tea_box+Ingredient_box[3])>4095||(Green_tea_box+Ingredient_box[2])>4095;
    //display all 
    // $display("Black_tea_used = %h", Black_tea_used);
    // $display("Green_tea_used = %h", Green_tea_used);
    // $display("Milk_used = %h", Milk_used);
    // $display("Pineapple_juice_used = %h", Pineapple_juice_used);
    // $display("Month_ = %h", Month_y);
    // $display("Day_ = %h", Day_y);
    // $display("insuficient_Pineaple = %h", insuficient_Pineaple);
    // $display("insuficient_Milk = %h", insuficient_Milk);
    // $display("insuficient_Green_Tea = %h", insuficient_Green_Tea);
    // $display("insuficient_Black_Tea = %h", insuficient_Black_Tea);
    // $display("type capture", r_bevtype_.Bevtype);
    // $display("Milk_Tea_ = %h", Milk_Tea_);
    // $display("Extra_Milk_Tea_ = %h", Extra_Milk_Tea_);
    // $display("Green_Tea_ = %h", Green_Tea_);
    // $display("Green_Milk_Tea_ = %h", Green_Milk_Tea_);
    // $display("Pineapple_Juice_ = %h", Pineapple_Juice_);
    // $display("Super_Pineapple_Tea_ = %h", Super_Pineapple_Tea_);
    // $display("Black_Tea_ = %h", Black_Tea_);
    // $display("Super_Pineapple_Milk_Tea_ = %h", Super_Pineapple_Milk_Tea_);
    Deduct_golden_ans_make_drink;
end 
endtask

task computeanswer_check_valid;
begin 
    readfromdram;
    check_dateok;
    Deduct_golden_ans_check_valid;
end
endtask

// parameter Large=2'b00,Medium=2'b01,Small=2'b11;
task Drink_quantity;
            Black_tea_used = 0;
            Green_tea_used = 0;
            Milk_used = 0;
            Pineapple_juice_used= 0;
            case( r_bevtype_.Bevtype)   
            Black_Tea_: begin
                case( r_bevsize_.Bevsize)
                Large: Black_tea_used = 960;
                Medium: Black_tea_used = 720;
                Small: Black_tea_used = 480;
                endcase
            end    	    
            Milk_Tea_: begin
                case( r_bevsize_.Bevsize)
                Large: begin
                    Black_tea_used = 720;
                    Milk_used = 240;
                end
                Medium: begin
                    Black_tea_used = 540; 
                    Milk_used = 180;
                end
                Small: begin
                    Black_tea_used = 360; 
                   Milk_used = 120;
                end
                endcase
            end    		           
            Extra_Milk_Tea_: begin
                case( r_bevsize_.Bevsize)
                Large: begin
                    Black_tea_used = 480; 
                    Milk_used = 480;
                end
                Medium: begin
                    Black_tea_used = 360; 
                    Milk_used = 360;
                end
                Small: begin
                    Black_tea_used = 240; 
                    Milk_used = 240;
                end
                endcase
            end    	         
            Green_Tea_: begin
                case( r_bevsize_.Bevsize)
                Large: Green_tea_used = 960;
                Medium: Green_tea_used = 720;
                Small: Green_tea_used = 480;
                endcase
            end    	 	           
            Green_Milk_Tea_: begin
                case( r_bevsize_.Bevsize)
                Large: begin
                    Green_tea_used = 480;
                Milk_used = 480;
                end
                Medium: begin
                    Green_tea_used = 360;
                Milk_used = 360;
                end
                Small: begin
                    Green_tea_used = 240;
                Milk_used = 240;
                end
                endcase
            end    	 	          
            Pineapple_Juice_: begin
                case( r_bevsize_.Bevsize)
                Large: Pineapple_juice_used= 960;
                Medium: Pineapple_juice_used= 720;
                Small: Pineapple_juice_used= 480;
                endcase
            end    	 	            
            Super_Pineapple_Tea_: begin
                case( r_bevsize_.Bevsize)
                Large: begin
                    Black_tea_used = 480;
                    Pineapple_juice_used= 480;
                end
                Medium: begin
                    Black_tea_used = 360;
                    Pineapple_juice_used= 360; 
                end
                Small: begin
                    Black_tea_used = 240;
                    Pineapple_juice_used= 240;
                end
                endcase
            end    	 	      
            Super_Pineapple_Milk_Tea_: begin
                case( r_bevsize_.Bevsize)
                Large: begin
                    Black_tea_used = 480;
                Milk_used = 240;
                    Pineapple_juice_used= 240;
                end
                Medium: begin
                    Black_tea_used = 360;
                Milk_used = 180;
                    Pineapple_juice_used= 180;
                end
                Small: begin
                    Black_tea_used = 240;
                Milk_used = 120;
                    Pineapple_juice_used= 120;
                end
                endcase
            end    	 	   
            endcase
endtask

task check_dateok; begin 
    date_state_[0]=r_date_.date[4:0];
    date_state_[1]=r_date_.date[8:5];
    // $display("date_state_[0] = %h", date_state_[0]);
    // $display("date_state_[1] = %h", date_state_[1]);
    // $display("Month_y = %h", Month_y);
    // $display("Day_y = %h", Day_y);
    //(day < date_state[0]&&month==date_state[1]) || month < date_state[1];
    expired_flag= ( Day_y<date_state_[0]&&Month_y==date_state_[1] ) || Month_y<date_state_[1];
end
endtask

task Deduct_golden_ans_check_valid;begin 
//    $display(" golden error = %b", golden_err);
//     $display(" golden complete = %b", golden_complete);
//     $display(" golden expired = %b", expired_flag);
    if (expired_flag==1) begin
        golden_err=1;
        golden_complete=0;
    end
    else begin
        golden_err=0;
        golden_complete=1;
    end 
end
endtask
// function  getnumbox(id);
//     logic [63:0] out;
//     logic [16:0] id;
//     logic [7:0] Month_,Day_;
//     logic [11:0] Milk_,Green_tea_,Black_tea_,Pineapple_juice_;
//     Black_tea_       = {golden_DRAM['h10000+id*8+7], golden_DRAM['h10000+id*8+6][7:4]};
//     Green_tea_       = {golden_DRAM['h10000+id*8+6][3:0], golden_DRAM['h10000+id*8+5]};
//     Milk_            = {golden_DRAM['h10000+id*8+3], golden_DRAM['h10000+id*8+2][7:4]};
//     Pineapple_juice_ = {golden_DRAM['h10000+id*8+2][3:0], golden_DRAM['h10000+id*8+1]};
//     Month_ = golden_DRAM['h10000+id*8+4];
//     Day_ = golden_DRAM['h10000+id*8];
//     out = {Black_tea_,Green_tea_,Month_,Milk_,Pineapple_juice_,Day_};
//     return out;
// endfunction
task Deduct_golden_ans_make_drink; begin//make
    // $display("data true = %h", {golden_DRAM[65536+myaddr*8+7], golden_DRAM[65536+myaddr*8+6][7:4],golden_DRAM[65536+myaddr*8+6][3:0], golden_DRAM[65536+myaddr*8+5],golden_DRAM[65536+myaddr*8+3], golden_DRAM[65536+myaddr*8+2][7:4],golden_DRAM[65536+myaddr*8+2][3:0], golden_DRAM[65536+myaddr*8+1],golden_DRAM[65536+myaddr*8+4],golden_DRAM[65536+myaddr*8]});
    if (expired_flag==1) begin
        golden_err=1;
        golden_complete=0;
    end
    else if (insuficent_material==1) begin
        golden_err=2;
        golden_complete=0;
    end
    else begin
        golden_err=0;
        golden_complete=1;
        //deduct
        Black_tea_y       = Black_tea_y - Black_tea_used;
        Green_tea_y       = Green_tea_y - Green_tea_used;
        Milk_y            = Milk_y - Milk_used;
        Pineapple_juice_y = Pineapple_juice_y - Pineapple_juice_used;
        //write back
        if(!insuficent_material&&!expired_flag)begin 
        {golden_DRAM[65536+myaddr*8+7], golden_DRAM[65536+myaddr*8+6][7:4]} = Black_tea_y;
        {golden_DRAM[65536+myaddr*8+6][3:0], golden_DRAM[65536+myaddr*8+5]} = Green_tea_y;
        {golden_DRAM[65536+myaddr*8+3], golden_DRAM[65536+myaddr*8+2][7:4]} = Milk_y;
        {golden_DRAM[65536+myaddr*8+2][3:0], golden_DRAM[65536+myaddr*8+1]} = Pineapple_juice_y;
        golden_DRAM[65536+myaddr*8+4] =Month_y;
        golden_DRAM[65536+myaddr*8] = Day_y;
    end
    end
end endtask 

task CHECK_ANS; begin 
    case(r_act_.act_c)//Make drink
    0://MAKE_DRINK
    begin
       // $display("your error = %b", inf.err_msg);
      //  $display("your complete = %b", inf.complete);
       //  $display(" golden expired = %b", expired_flag);
       // $display(" golden insuficent_material = %b", insuficent_material);
       // $display("golden err = %b", golden_err);
        //$display("golden complete = %b", golden_complete);
        //$display("golden day = %h", Day_y);
       // $display("golden month = %h", Month_y);
        //$display("data true = %h", {golden_DRAM[65536+myaddr*8+7], golden_DRAM[65536+myaddr*8+6][7:4],golden_DRAM[65536+myaddr*8+6][3:0], golden_DRAM[65536+myaddr*8+5],golden_DRAM[65536+myaddr*8+3], golden_DRAM[65536+myaddr*8+2][7:4],golden_DRAM[65536+myaddr*8+2][3:0], golden_DRAM[65536+myaddr*8+1],golden_DRAM[65536+myaddr*8+4],golden_DRAM[65536+myaddr*8]});
    if(inf.out_valid===1)begin 
        if(golden_err!==inf.err_msg) begin
            $display("");
            $display("");
            $display("__________________________________________________________________________");
            $display("");
            $display("                            Fail                                              ");
            $display("                        Wrong Answer                                          ");
            $display("");
            $display("");
            $display("__________________________________________________________________________    ");
            $finish;
        end
        if(golden_complete!==inf.complete) begin
            $display("");
            $display("");
            $display("__________________________________________________________________________");
            $display("");
            $display("                            Fail                                              ");
            $display("                        Wrong Answer                                          ");
            $display("");
            $display("");
            $display("__________________________________________________________________________    ");
            $finish;
        end
    end
    end 
    1://SUPPLY
    begin

    if(inf.out_valid===1)begin 
        if(golden_err!==inf.err_msg) begin
            $display("");
            $display("");
            $display("__________________________________________________________________________");
            $display("");
            $display("                            Fail                                              ");
            $display("                        Wrong Answer                                          ");
            $display("");
            $display("");
            $display("__________________________________________________________________________    ");
            $finish;
        end
        if(golden_complete!==inf.complete) begin
            $display("");
            $display("");
            $display("__________________________________________________________________________");
            $display("");
            $display("                            Fail                                              ");
            $display("                        Wrong Answer                                          ");
            $display("");
            $display("");
            $display("__________________________________________________________________________    ");
            $finish;
        end
    end
    end
    2://CHECK_VALID_DATE
    begin
    if(inf.out_valid===1)begin 
        if(golden_err!==inf.err_msg) begin
            $display("");
            $display("");
            $display("__________________________________________________________________________");
            $display("");
            $display("                            Fail                                              ");
            $display("                        Wrong Answer                                          ");
            $display("");
            $display("");
            $display("__________________________________________________________________________    ");
            $finish;
        end
        if(golden_complete!==inf.complete) begin
            $display("");
            $display("");
            $display("__________________________________________________________________________");
            $display("");
            $display("                            Fail                                              ");
            $display("                        Wrong Answer                                          ");
            $display("");
            $display("");
            $display("__________________________________________________________________________    ");
            $finish;
        end
    end
    end
    endcase
end 
endtask
task YOUPASS; begin
    $display("");
    $display("");
    $display("__________________________________________________________________________");
    $display("");
    $display("                            Congratulations                               ");
    $display("");
    $display("");
    $display("__________________________________________________________________________");
end endtask
endprogram