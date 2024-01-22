module BEV(input clk, INF.BEV_inf inf);

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Variable Declaration >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    import usertype::*;
    // This file contains the definition of several state machines used in the BEV (Beverage) System RTL design.
    // The state machines are defined using SystemVerilog enumerated types.
    // The state machines are:
    // - state_t: used to represent the overall state of the BEV system
    //
    // Each enumerated type defines a set of named states that the corresponding process can be in.
    typedef enum logic [1:0]{
        IDLE,
        MAKE_DRINK,
        SUPPLY,
        CHECK_DATE
    } state_t;
    logic [2:0] act_capture;
    logic [12:0] Ingredient_box[3:0];//start from Blacktea to pineapple juice
    typedef enum logic [2:0]{
        IDLE_M,
        WAIT_READY,
        WAIT_VALID,
        MODE_WRITE,
        OUTPUT
    } state_p;
    // REGISTERS
    state_t state, nstate;
    state_p make_state, make_nstate;
    Data D_receive;
    logic [5:0] ctr;
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< FSM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    always_ff @( posedge clk or negedge inf.rst_n) begin : TOP_FSM_SEQ
        if (!inf.rst_n) state <= IDLE;
        else state <= nstate;
    end

    always_comb begin : TOP_FSM_COMB
        case(state)
            IDLE: begin
                if (inf.sel_action_valid)
                begin
                    case(inf.D.d_act[0])
                        Make_drink: nstate = MAKE_DRINK;
                        Supply: nstate = SUPPLY;
                        Check_Valid_Date: nstate = CHECK_DATE;
                        default: nstate = IDLE;
                    endcase
                end
                else
                begin
                    nstate = IDLE;
                end
            end
            default: nstate = IDLE;
        endcase
    end

    always_ff @( posedge clk or negedge inf.rst_n) begin : MAKE_DRINK_FSM_SEQ
        if (!inf.rst_n) make_state <= IDLE_M;
        else make_state <= make_nstate;
    end
    always_ff @( posedge clk or negedge inf.rst_n) begin 
        if (!inf.rst_n) ctr<=0;
        else if(make_nstate==MODE_WRITE) ctr <= ctr + 1;
        else ctr<=0;
    end
        logic passedCoutvalid;
    always_comb begin : MAKE_DRINK_FSM_COMB
        make_nstate=IDLE_M;
        case(make_state)
            IDLE_M: begin
                if (inf.sel_action_valid)
                begin
                    case(inf.D.d_act[1:0])
                        Black_Tea: make_nstate = WAIT_READY;
                        Milk_Tea: make_nstate = WAIT_READY;
                        Extra_Milk_Tea: make_nstate = WAIT_READY;
                        Green_Tea: make_nstate = WAIT_READY;
                        Green_Milk_Tea: make_nstate = WAIT_READY;
                        Pineapple_Juice: make_nstate = WAIT_READY;
                        Super_Pineapple_Tea: make_nstate = WAIT_READY;
                        Super_Pineapple_Milk_Tea: make_nstate = WAIT_READY;
                        default: make_nstate = IDLE_M;
                    endcase
                end
                else
                begin
                    make_nstate = IDLE_M;
                end
            end
            WAIT_READY: begin
                if (inf.box_no_valid)
                begin
                    make_nstate = WAIT_VALID;
                end
                else
                begin
                    make_nstate = WAIT_READY;
                end
            end
            WAIT_VALID: begin
                if (inf.C_out_valid&&act_capture==2)begin
                    make_nstate = OUTPUT;
                end else if(inf.C_out_valid&&act_capture==1)begin
                    make_nstate = MODE_WRITE; 
                end else if(act_capture==0&&inf.C_out_valid) begin 
                    make_nstate = MODE_WRITE;
                end else begin 
                    make_nstate=WAIT_VALID;
                end
            end
            MODE_WRITE: begin 
                if(inf.C_out_valid&&(act_capture==1||act_capture==0)&&ctr>4)begin 
                    make_nstate=OUTPUT;
                end else if((act_capture==1||act_capture==0)&&~inf.C_out_valid)begin
                    make_nstate=MODE_WRITE;
                end else if(act_capture==2) begin  
                    make_nstate=OUTPUT;
                end 
                end
            OUTPUT: begin
                begin
                    make_nstate = IDLE_M;
                end
            end
            default: make_nstate = IDLE_M;
        endcase
    end
//<<<<<<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<< Data Capture >>>>>>>>>>>>>>><<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //varaible declaration
    //!remember to change back  parameter Large=0,Medium=1,Small=3;
        parameter Large=2'b00,Medium=2'b01,Small=2'b11;//960 ,720,480
        parameter Small_size=360,Medium_size=360,Large_size=480;
        logic [63:0] box_num;
        logic [8:0] date_capture;
        logic [8:0] addr;
        logic [8:0] Action_capture; //checkvalid,make suply
        logic [15:0] box_no; 
        logic [3:0] type_capture,Bev_size_capture;
        logic [7:0] date_state[1:0];
        wire  [11:0] Milk_box= box_num[31:20];//{box_num[39:32],box_num[47:44]};
        wire  [11:0] Pineapple_juice_box=box_num[19:8]; //{box_num[55:48],box_num[43:40]};
        wire  [11:0] Black_tea_box=box_num[63:52]; //{box_num[7:0],box_num[15:12]};
        wire  [11:0]  Green_tea_box=box_num[51:40]; //{box_num[11:8],box_num[23:16]};
        wire  [7:0]  day=box_num[7:0];
        wire  [7:0]  month=box_num[39:32];
        wire  Element_overflow=(Milk_box+Ingredient_box[1])>4095||(Pineapple_juice_box+Ingredient_box[0])>4095||(Black_tea_box+Ingredient_box[3])>4095||(Green_tea_box+Ingredient_box[2])>4095;
        //we write back the data + supplies to dram
    
        wire [11:0] Pineapple_Juice_sum= ((Pineapple_juice_box+Ingredient_box[0])>=4095)? 4095: Pineapple_juice_box+Ingredient_box[0];
        wire [11:0] Milk_sum=            ((Milk_box+Ingredient_box[1])>=4095)? 4095 : Milk_box+Ingredient_box[1] ;
        wire [11:0] Green_Tea_sum=       ((Green_tea_box+Ingredient_box[2])>=4095)? 4095: Green_tea_box+Ingredient_box[2];
        wire [11:0] Black_Tea_sum=       ((Black_tea_box+Ingredient_box[3])>=4095)? 4095: Black_tea_box+Ingredient_box[3];
        //^^^^^^^^^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&&&&&& Make drink wires &&&&&&&&&&&&&&&&^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^       
        logic [11:0] Black_tea_used; //=(Ingredient_box[3]-Black_tea_box)>0?Ingredient_box[3]-Black_tea_box:Ingredient_box[3];
        logic [11:0] Green_tea_used;//=(Ingredient_box[2]-Green_tea_box)>0?Ingredient_box[2]-Green_tea_box:Ingredient_box[2];
        logic [11:0] Milk_used;//=(Ingredient_box[1]-Milk_box)>0?Ingredient_box[1]-Milk_box:Ingredient_box[1];
        logic [11:0] Pineapple_juice_used;//=(Ingredient_box[0]-Pineapple_juice_box)>0?Ingredient_box[0]-Pineapple_juice_box:Ingredient_box[0];

        wire insuficient_Pineaple= (Pineapple_juice_box<Pineapple_juice_used);  //(Bev_size_capture==Large&&Pineapple_juice_box<Large_size)||(Bev_size_capture==Medium&&Pineapple_juice_box<Medium_size)||(Bev_size_capture==Small&&Pineapple_juice_box<Small_size);
        wire insuficient_Milk= (Milk_box<Milk_used);                //(Bev_size_capture==Large&&Milk_box<Large_size)||(Bev_size_capture==Medium&&Milk_box<Medium_size)||(Bev_size_capture==Small&&Milk_box<Small_size);
        wire insuficient_Green_Tea= (Green_tea_box<Green_tea_used);       //(Bev_size_capture==Large&&Green_tea_box<Large_size)||(Bev_size_capture==Medium&&Green_tea_box<Medium_size)||(Bev_size_capture==Small&&Green_tea_box<Small_size);
        wire insuficient_Black_Tea= (Black_tea_box<Black_tea_used);      //(Bev_size_capture==Large&&Black_tea_box<Large_size)||(Bev_size_capture==Medium&&Black_tea_box<Medium_size)||(Bev_size_capture==Small&&Black_tea_box<Small_size);
        
        wire [11:0] Pineapple_left= (Pineapple_juice_box <Pineapple_juice_used) ? Pineapple_juice_box: Pineapple_juice_box-Pineapple_juice_used;
        wire [11:0] Milk_left= (Milk_box <Milk_used) ?  Milk_box: Milk_box-Milk_used;
        wire [11:0] Green_tea_left= (Green_tea_box <Green_tea_used) ? Green_tea_box: Green_tea_box-Green_tea_used;
        wire [11:0] Black_tea_left= (Black_tea_box <Black_tea_used) ? Black_tea_box: Black_tea_box-Black_tea_used;
        wire is_this_address= (inf.C_addr==183);
        wire insufient_material=insuficient_Black_Tea||insuficient_Milk||insuficient_Green_Tea||insuficient_Pineaple;
    // always_comb begin 
    //     case(type_capture)
    //         0:begin //black tea
    //             insufient_material=insuficient_Black_Tea;
    //         end
    //         1:begin //milk tea
    //          insufient_material=((Bev_size_capture==Large&&Black_tea_box*3<Large_size)||(Bev_size_capture==Medium&&Black_tea_box*3<Medium_size)||(Bev_size_capture==Small&&Black_tea_box*3<Small_size))||insuficient_Milk;
    //         end 
    //         2: begin//Extra milk tea
    //          insufient_material=insuficient_Black_Tea||insuficient_Milk;
    //         end
    //         3: begin//green tea
    //             insufient_material=insuficient_Green_Tea;
    //         end
    //         4:begin//green milk tea
    //             insufient_material=insuficient_Green_Tea||insuficient_Milk;
    //         end
    //         5: begin //pineaple juice
    //             insufient_material=insuficient_Pineaple;
    //         end
    //         6: begin //super pineaple tea
    //             insufient_material=insuficient_Pineaple||insuficient_Black_Tea;
    //         end
    //         7:begin //super Pineaple milk tea
    //             insufient_material=insuficient_Pineaple||insuficient_Milk||(Bev_size_capture==Large&&Black_tea_box*2<Large_size)||(Bev_size_capture==Medium&&Black_tea_box*2<Medium_size)||(Bev_size_capture==Small&&Black_tea_box*2<Small_size);
    //         end
    //     endcase
    // end
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Data Capture Drink manager  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    parameter Black_Tea_=0;
    parameter Milk_Tea_=1;
    parameter Extra_Milk_Tea_=2;
    parameter Green_Tea_=3;
    parameter Green_Milk_Tea_=4;
    parameter Pineapple_Juice_=5;
    parameter Super_Pineapple_Tea_=6;
    parameter Super_Pineapple_Milk_Tea_=7;
    always_comb begin
            Black_tea_used = 0;
            Green_tea_used = 0;
            Milk_used = 0;
            Pineapple_juice_used= 0;
          //  $monitor("Black_tea_box=%h,Green_tea_box=%h,Milk_box=%h,Pineapple_juice_box=%h",Black_tea_box,Green_tea_box,Milk_box,Pineapple_juice_box);
            //$display("Black_tea_left=%h,Green_tea_left=%h,Milk_left=%h,Pineapple_left=%h",Black_tea_left,Green_tea_left,Milk_left,Pineapple_left);
            //$display("Black_tea_box=%h,Green_tea_box=%h,Milk_box=%h,Pineapple_juice_box=%h",Black_tea_box,Green_tea_box,Milk_box,Pineapple_juice_box);
            case(type_capture)   
            Black_Tea_: begin
                case(Bev_size_capture)
                Large: Black_tea_used = 960;
                Medium: Black_tea_used = 720;
                Small: Black_tea_used = 480;
                endcase
            end    	    
            Milk_Tea_: begin
                case(Bev_size_capture)
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
                case(Bev_size_capture)
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
                case(Bev_size_capture)
                Large: Green_tea_used = 960;
                Medium: Green_tea_used = 720;
                Small: Green_tea_used = 480;
                endcase
            end    	 	           
            Green_Milk_Tea_: begin
                case(Bev_size_capture)
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
                case(Bev_size_capture)
                Large: Pineapple_juice_used= 960;
                Medium: Pineapple_juice_used= 720;
                Small: Pineapple_juice_used= 480;
                endcase
            end    	 	            
            Super_Pineapple_Tea_: begin
                case(Bev_size_capture)
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
                case(Bev_size_capture)
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
                        //$display("Black_tea_used=%h,Green_tea_used=%h,Milk_used=%h,Pineapple_juice_used=%h",Black_tea_used,Green_tea_used,Milk_used,Pineapple_juice_used);

        end
    always_ff@(posedge clk or negedge inf.rst_n) begin //d_received 
        if(!inf.rst_n) begin 
            D_receive.d_act<=0;
            D_receive.d_box_no<=0;
            D_receive.d_date<=0;
        end
        else begin 
            if(inf.sel_action_valid) begin 
                D_receive.d_act<=inf.D.d_act;
            end else if(inf.date_valid) begin
                D_receive.d_date<=inf.D.d_date;
            end else if(inf.box_no_valid) begin
                D_receive.d_box_no<=inf.D.d_box_no;
            end
        end
    end
    always_ff@(posedge clk or negedge inf.rst_n) begin //Action_capture not in use
        if(!inf.rst_n) begin 
            Action_capture<=0;
        end
        else begin 
            if(inf.sel_action_valid) begin
                Action_capture<=inf.D.d_act[0]; 
            end else begin 
                Action_capture<=Action_capture;
            end
        end
    end
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
    always_ff@(posedge clk or negedge inf.rst_n) begin //type_capture
        if(!inf.rst_n) begin 
          type_capture<=0;
        end
        else begin 
            if(inf.type_valid) begin
                type_capture<=inf.D.d_type;
            end else begin 
                type_capture<=type_capture;
            end
        end
    end
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
    always_ff@(posedge clk or negedge inf.rst_n) begin //Bev_size_capture for make drink
        if(!inf.rst_n) begin 
          Bev_size_capture<=0;
        end
        else begin 
            if(inf.size_valid) begin
                Bev_size_capture<=inf.D.d_type;
            end else begin 
                Bev_size_capture<=Bev_size_capture;
            end
        end
    end
    always_ff@(posedge clk or negedge inf.rst_n) begin //ingredient box for supply
        if(!inf.rst_n) begin 
            Ingredient_box[0]<=0;
            Ingredient_box[1]<=0;
            Ingredient_box[2]<=0;
            Ingredient_box[3]<=0;
        end
        else begin 
            if(inf.box_sup_valid) begin 
                Ingredient_box[0]<=inf.D.d_ing[0];
                Ingredient_box[1]<=Ingredient_box[0];
                Ingredient_box[2]<=Ingredient_box[1];
                Ingredient_box[3]<=Ingredient_box[2];
            end
        end
    end
    always_ff@(posedge clk or negedge inf.rst_n) begin //act capture
        if(!inf.rst_n) begin 
            act_capture<=0;
        end
        else begin 
            if(inf.sel_action_valid) begin 
                act_capture<=inf.D.d_act[1:0];
            end else begin 
                act_capture<=act_capture;
            end
        end
    end
    logic[8:0] address;
    
    always_ff@(posedge clk or negedge inf.rst_n) begin //address capture
        if(!inf.rst_n) begin 
            passedCoutvalid<=0;
        end
        else begin 
            case(make_state)
                MODE_WRITE: begin 
                    if(inf.C_out_valid) begin 
                        passedCoutvalid<=1;
                    end else begin 
                        passedCoutvalid<=passedCoutvalid;
                    end
                end
                IDLE_M: begin 
                    passedCoutvalid<=0;
                end
                default: begin 
                    passedCoutvalid<=passedCoutvalid;
                end
            endcase
        end
    end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WRITE READ DRAM <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    wire dating =(day < date_state[0]&&month==date_state[1]) || month < date_state[1];
    always_ff@(posedge clk or negedge inf.rst_n) begin //C_r_wb to write/read to dram 
        if(!inf.rst_n) begin 
            inf.C_in_valid=0;
            inf.C_addr =0;
            inf.C_r_wb=0;
            address=0;
        end
        else begin 
            
            if(inf.box_no_valid)begin 
                inf.C_addr = inf.D.d_box_no;
                address=inf.D.d_box_no;
                inf.C_in_valid=1;
                inf.C_r_wb=1;//(inf.D.d_act[0]==Make_drink)?0:1;//can use 
                    //$display("address=%d",address);
            end else if(make_nstate==MODE_WRITE&&act_capture==1&&ctr==8)begin //make
                inf.C_in_valid=1;
                inf.C_addr = address;
                inf.C_r_wb =0;//mode write //
                inf.C_data_w={Black_Tea_sum,Green_Tea_sum,date_state[1],Milk_sum,Pineapple_Juice_sum,date_state[0]};//add the supplies if bigger than 4095 just write 4095
                address=address;
            end else if(make_nstate==MODE_WRITE&&act_capture==0&&ctr==8)begin //supply
                inf.C_in_valid=1;
                inf.C_addr = address;
                inf.C_r_wb=0;//mode write 
               
                if(insufient_material||dating) begin
                    inf.C_data_w=box_num; //{Black_tea_box,Milk_box,month,Pineapple_juice_box,Green_tea_box,day};//change to minus the ingredient used
                end else begin 
                    inf.C_data_w={Black_tea_left,Green_tea_left,month,Milk_left,Pineapple_left,day};//change to minus the ingredient used
                end
                //$display("Cdataw=%h",inf.C_data_w);
                address=address;
            end else begin 
                inf.C_in_valid=0;
                inf.C_addr = 0;
                inf.C_r_wb=0;
                //address=address;
            end 
            
            end
    end
    always_ff@(posedge clk or negedge inf.rst_n) begin//box_num capture dram val
        if(!inf.rst_n) begin 
            box_num<=0;
        end
        else begin 
            if(inf.C_out_valid&&make_nstate==MODE_WRITE&&(act_capture==1||act_capture==0))begin 
                box_num<=inf.C_data_r;
                //$display("Cdatar=%h",inf.C_data_r);
            end else  if(inf.C_out_valid&&act_capture==2)begin 
                box_num<=inf.C_data_r;
            end else if(inf.C_out_valid&&make_nstate==MODE_WRITE&&act_capture==0)begin 
                box_num<=inf.C_data_r;
            end else begin 
                box_num<=box_num;
            end 
        end
    end
//<<<<<<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<< OUT >>>>><<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //compare dates with what we have
    //for suply 1. check date 2. check tot not overflow. 3.write back to dram
    //wire toolate=((day < D_receive.d_date[4:0] &&month<=D_receive.d_date[8:5]));
    // (date_state[1] <= 12 && date_state[0] <= 31 && date_state[1] <= 12 && date_state[0] <= 31) &&
    //                 ((date_state[1] < month) || (date_state[1] == month && date_state[0] <= day)) ;
    
     wire toolate= (month <= 12 && day <= 31 && date_state[1] <= 12 && date_state[0] <= 31) &&
            ((month < date_state[1]) || (month == date_state[1] && day <= date_state[0]));
 

    always_ff@(posedge clk or negedge inf.rst_n) begin 
        if(!inf.rst_n) begin 
            inf.out_valid <= 0;
            inf.err_msg <= 0;
            inf.complete <= 0;
        end  else begin 
            if(make_state==OUTPUT) begin 
                inf.out_valid <= 1;
                case (act_capture)
                    2: begin
                        if ((day < date_state[0]&&month==date_state[1]) || month < date_state[1]) begin
                            inf.err_msg <= 1;
                            inf.complete <= 0;
                        end else begin
                            inf.err_msg <= 0;
                            inf.complete <= 1;
                        end
                    end
                    1: begin
                        if (Element_overflow) begin
                            inf.err_msg <= 3;
                            inf.complete <= 0;
                        // end else if(((day < date_state[0]&&month==date_state[1]) || month < date_state[1])) begin
                        //     inf.err_msg <= 1;
                        //     inf.complete <= 0;
                        end else begin
                            inf.err_msg <= 0;
                            inf.complete <= 1;
                        end
                    end
                    0: begin
                        if((day < date_state[0]&&month==date_state[1]) || month < date_state[1]) begin
                            inf.err_msg <= 1;
                            inf.complete <= 0;

                        end else if(insufient_material) begin
                            inf.err_msg <= 2;
                            inf.complete <= 0;
                        end else begin
                            inf.err_msg <= 0;
                            inf.complete <= 1;
                        end
                    end
                    default: begin
                        inf.err_msg <= 0;
                        inf.complete <= 0;
                    end
                endcase
            end else begin 
                inf.out_valid <= 0;
                inf.err_msg <= 0;
                inf.complete <= 0;
            end
        end
    end

endmodule
