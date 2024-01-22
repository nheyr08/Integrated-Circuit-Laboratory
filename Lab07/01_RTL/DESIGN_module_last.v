//>>>>>>>>>>>>>>>>>>>>>>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CLK1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@<<<<<<<<<<<<<<<<<<<
   
    module CLK_1_MODULE (
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Input signals<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        clk,
        rst_n,
        in_valid,
        seed_in,
        out_idle,
        out_valid,
        seed_out,

        clk1_handshake_flag1,
        clk1_handshake_flag2,
        clk1_handshake_flag3,
        clk1_handshake_flag4
        );

        input clk;
        input rst_n;
        input in_valid;
        input [31:0] seed_in;
        input out_idle;
        output reg out_valid;
        output reg [31:0] seed_out;

        // You can change the input / output of the custom flag ports
        input clk1_handshake_flag1;
        input clk1_handshake_flag2;
        output clk1_handshake_flag3;
        input clk1_handshake_flag4;
        wire whistlblower_1=clk1_handshake_flag4;//wistleblower for IDLE
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Handshake to tranfer seed<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        parameter IDLE = 'd0, INPUT = 'd1, HANDSHAKE = 'd2, OUT = 'd3, WAIT='d4;
        reg [2:0] c_state1, n_state;
        wire CS_HANDSHAKE = c_state1 == HANDSHAKE, CS_IDLE = c_state1 == IDLE, CS_OUT = c_state1 == OUT, CS_INPUT = c_state1 == INPUT;
        reg [7:0] ctr;
        reg [31:0] Seed_reg;
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        always@(posedge clk or negedge rst_n) begin//nstate
            if(!rst_n) c_state1 <= IDLE;
            else c_state1 <= n_state;
        end

        always@(*) begin//c_state1
            n_state = c_state1;
            case(c_state1)
                IDLE:         if(in_valid)            n_state = INPUT;
                INPUT:        if(!in_valid)           n_state = HANDSHAKE;
                HANDSHAKE:    if(ctr==3)              n_state = WAIT;//handshakedone
                WAIT:         if(whistlblower_1)      n_state = IDLE;
                default:                              n_state = IDLE;
            endcase
        end
        always @(posedge clk or negedge rst_n) begin//ccttr
            if (!rst_n) ctr <= 3'b0;
            else begin
                if (n_state != c_state1) ctr <= 8'b0;
                else begin
                    case (c_state1)
                        INPUT:      ctr <= ctr + 1;
                        HANDSHAKE:  ctr <= ctr + 1;
                        OUT:        ctr <= ctr + 1;
                        WAIT:       ctr <=     'b0;
                        default:    ctr <=     'b0;
                    endcase
                end
            end
        end
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Seed capture<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        always@(posedge clk or negedge rst_n) begin//seed
            if(!rst_n) begin
                Seed_reg<=0;    
            end
            else begin
                if(in_valid)
                    Seed_reg<=seed_in;
                else
                    Seed_reg<=Seed_reg;
            end
        end
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Handshake<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        assign clk1_handshake_flag3=CS_HANDSHAKE;
        always @(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                out_valid<=0;
                seed_out<=0;    
            end else begin
                if(CS_HANDSHAKE)begin 
                    out_valid<=1;
                    seed_out<=Seed_reg;
                end else begin 
                    out_valid<=0;
                    seed_out<=0;
                end
            end
        end
    endmodule
//>>>>>>>>>>>>>>>>>>>>>>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CLK2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@<<<<<<<<<<<<<<<<<<<
    module CLK_2_MODULE (
        clk,
        rst_n,
        in_valid,
        fifo_full,
        seed,
        out_valid,
        rand_num,
        busy,

        handshake_clk2_flag1,
        handshake_clk2_flag2,
        handshake_clk2_flag3,
        handshake_clk2_flag4,//wistleblower_2

        clk2_fifo_flag1,//wistleblower_1
        clk2_fifo_flag2,
        clk2_fifo_flag3,
        clk2_fifo_flag4
        );

        input clk;
        input rst_n;
        input in_valid;
        input fifo_full;
        input [31:0] seed;
        output reg out_valid;
        output reg [31:0] rand_num;
        output reg  busy;

        // You can change the input / output of the custom flag ports
        input handshake_clk2_flag1;//wistleblower clk1 data
        input handshake_clk2_flag2;
        output handshake_clk2_flag3;
        output handshake_clk2_flag4;

        input clk2_fifo_flag1;//Final whistlblower
        input clk2_fifo_flag2;
        input clk2_fifo_flag3;
        input clk2_fifo_flag4;
        wire wistleblower_2=clk2_fifo_flag1;
        assign handshake_clk2_flag4=wistleblower_2;
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>declaration input<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        integer k;
        parameter SHIFT_PARAM_A = 13;
        parameter SHIFT_PARAM_B = 17;
        parameter SHIFT_PARAM_C = 5;
        parameter MAX_INPUT_DELAY   = 3;
        reg unsigned [31:0] nord[1:256];
        reg unsigned [31:0] sud[1:256];
        reg unsigned [31:0] nordest[1:256];
        reg unsigned [31:0] piblo[1:256];
        reg unsigned [31:0] soti[1:256];
        reg unsigned [31:0] nordest2[0:255];
        parameter IDLE = 'd0, INPUT = 'd1, COMP = 'd2, OUT = 'd3,WAIT='d4,WAIT2=5;
        reg [2:0] c_state2, n_state;
        wire CS_COMP = c_state2 == COMP, CS_WAIT=c_state2==WAIT, 
        CS_IDLE = c_state2 == IDLE, CS_OUT = c_state2 == OUT, CS_INPUT = c_state2 == INPUT;
        reg [4:0] ctr;
        reg [3:0]ctr3;
        reg previous;
        reg [12:0] ctr_2;
        reg unsigned [31:0] plake,tempit,plake2,temp1,temp3,temp2,temp4;
        wire clkd=clk2_fifo_flag4;
        wire  start_output_flag=clk2_fifo_flag2;
        reg pot;
        wire gowait=clk2_fifo_flag3;
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>design<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        always@(*) begin //generate nbrs
            if(!rst_n) begin 
                for(k=1 ; k<=256 ; k=k+1) begin
                    nord [k] = 0;
                    sud[k] = 0;
                    nordest[k] = 0;
                    piblo[k] = 0;
                    soti[k] = 0;
                end
            end else begin 
                if(CS_OUT)begin 
                    if(ctr_2==1)begin 
                    nord [ctr_2] = plake;//temp2
                    sud[ctr_2] = nord [ctr_2] ^ (nord [ctr_2] << SHIFT_PARAM_A);//temp1
                    nordest[ctr_2] = sud[ctr_2] ^ (sud[ctr_2] >> SHIFT_PARAM_B); //tempt3
                    piblo[ctr_2] =nordest[ctr_2] ^ (nordest[ctr_2] << SHIFT_PARAM_C);
                    soti[ctr_2] = piblo[ctr_2];
                   // end else if(ctr_2==2)begin 
                     //piblo[ctr_2]=nordest2[1] ^ (nordest2[1] << SHIFT_PARAM_C);
                    end else begin 
                        nord [ctr_2] = soti[ctr_2-1];
                        sud[ctr_2] = nord [ctr_2] ^ (nord [ctr_2] << SHIFT_PARAM_A);
                        nordest[ctr_2] = sud[ctr_2] ^ (sud[ctr_2] >> SHIFT_PARAM_B);
                        piblo[ctr_2] = nordest[ctr_2] ^ (nordest[ctr_2] << SHIFT_PARAM_C);
                        soti[ctr_2] = piblo[ctr_2];
                       // $display(soti[ctr_2]," & ctr = %d",ctr_2);
                       // $display("ctr_2=%d",ctr_2);
                    end
                end
            end
        end 


 
         always@(posedge clk or negedge rst_n) begin //nstate
            if(!rst_n) for(k=0 ; k<=255 ; k=k+1) begin
                nordest2[k] = 0;
            end else begin 
                if(in_valid)begin 
                    tempit = seed ^ (seed << SHIFT_PARAM_A);
                    nordest2[0] = tempit ^ (tempit >> SHIFT_PARAM_B);
                    plake2=nordest2[0];
                end else begin 
                    if(CS_COMP)begin 
                        tempit = plake2 ^ (plake2 << SHIFT_PARAM_A);
                        nordest2[1] = tempit ^ (tempit >> SHIFT_PARAM_B);
                        plake2=nordest2[1];
                    end else if (CS_OUT)begin 
                        tempit = plake2 ^ (plake2 << SHIFT_PARAM_A);
                        nordest2[ctr_2+1] = tempit ^ (tempit >> SHIFT_PARAM_B);
                        plake2=nordest2[ctr_2+1];
                      //   $display("nordest2[%d]=%d",ctr_2+1,nordest2[ctr_2+1]);
                        // $display("tempit=%d",tempit);
                      end
                end
            end
        end


        // always@(posedge clk or negedge rst_n) begin 
        //     if(!rst_n) for(k=0 ; k<=255 ; k=k+1) begin
        //        temp1 = 0;
        //     end else begin 
        //         if(in_valid)begin 
        //             temp1 = 0;
        //             temp1<=seed ^ (seed << SHIFT_PARAM_A);
        //         end else begin 
        //             if(CS_COMP)begin 
        //                 temp2<=  temp1 ^ ( temp1 >> SHIFT_PARAM_B);
        //                 // temp2 = temp3 ^ (nor << SHIFT_PARAM_A);
        //             end else if (CS_OUT)begin 
        //                 temp_out<= temp2 ^ (temp2 << SHIFT_PARAM_C);
        //                  $display("nordest2[%d]=%d",ctr_2+1,nordest2[ctr_2+1]);
        //                  $display("tempit=%d",tempit);
        //               end
        //         end
        //     end
        // end
    
        always@(posedge clk or negedge rst_n) begin 
            if(!rst_n) 
               temp1 = 0;
            else begin 
                if(in_valid)begin 
                    temp2 = seed;
                    temp3 = seed;
                    temp1 <= seed;
                end else begin 
                    if(CS_COMP)begin 
                        temp2= temp1 ^ (temp1 << SHIFT_PARAM_A);
                       // temp1=  temp1;
                        temp3=  1;
                        // temp2 = temp3 ^ (nor << SHIFT_PARAM_A);
                    end else if (CS_OUT)begin 
                        temp4    =  temp2 ^ ( temp2 >> SHIFT_PARAM_B);
                        temp3    =  temp4 ^ (temp4 << SHIFT_PARAM_C);
                        temp1    <=  temp4 ^ (temp4 << SHIFT_PARAM_C);
                     //    $display("nordest2[%d]=%d",ctr_2+1,nordest2[ctr_2+1]);
                     //    $display("tempit=%d",tempit);
                        $monitor("temp1=%d",temp1);
                        $monitor("temp2=%d",temp2);
                        $monitor("temp3=%d",temp3);
                        $monitor("temp4=%d",temp4);
                        $display("ctr_2=%d",ctr_2);
                        $display("soti[%d]=%d",ctr_2,soti[ctr_2]);
                      end
                end
                        // $display("temp1=%d",temp1);
                        // $display("temp2=%d",temp2);
                        // $display("temp3=%d",temp3);
                        // $display("temp4=%d",temp4);
                        // $display("ctr_2=%d",ctr_2);
                        // $display("soti[%d]=%d",ctr_2,soti[ctr_2]);
            end
        end
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Seed capture<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        always@(posedge clk or negedge rst_n) begin//seed
            if(!rst_n) begin
                plake<=0;    
            end else begin
                if(in_valid)
                    plake<=seed;
                else
                    plake<=plake;
            end
        end



    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        always@(posedge clk or negedge rst_n) begin //nstate
            if(!rst_n) c_state2 <= IDLE;
            else c_state2 <= n_state;
        end
        always@(*) begin
            n_state = c_state2;
            case(c_state2)
                IDLE:      if(in_valid)                       n_state = COMP;
                COMP:                                         n_state = OUT;
                OUT:       if(gowait)                         n_state = WAIT;
                            else if(ctr_2==280)                n_state= IDLE;
                WAIT:      if(start_output_flag)              n_state = OUT;
                default:                                      n_state = IDLE;
            endcase
        end
        
        always @(posedge clk or negedge rst_n) begin//ccttr
            if (!rst_n) begin 
                ctr_2 <= 'b1;
                // ctr_2_freeze<='b1;
            end else begin
               // pot<=ctr_2%62==0;
                if ( n_state != WAIT&&n_state != OUT )begin   
                    ctr_2 <= 1;
                end else begin
                    case (c_state2)
                        OUT:                ctr_2 <= ctr_2+ 1;
                        COMP:               ctr_2 <=        1;
                        WAIT:               begin 
                            if(out_valid)   ctr_2 <= ctr_2-1;
                            else            ctr_2 <=ctr_2;
                        end
                        default:            ctr_2 <= 1;
                    endcase
                end
            end
        end
        

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OUT<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        reg [31:0]debake;
        always @(posedge clk or negedge rst_n) begin//output 
            if(!rst_n) begin
                out_valid=0;
                rand_num=0; 
                busy=0;   
            end else if(CS_OUT)begin 
                out_valid=1;
                rand_num=soti[ctr_2];
                busy=1;
            end else if(CS_WAIT)begin 
                out_valid=0;
                rand_num=0;
                busy=1;
            end  else begin
                out_valid=0;
                rand_num=0;
                busy=0;
            end
        end
    // always@(posedge clk or negedge rst_n)begin 
    //     debake=soti[ctr_2];
    // end
    endmodule
//>>>>>>>>>>>>>>>>>>>>>>@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@CLK3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@<<<<<<<<<<<<<<<<<<<

    module CLK_3_MODULE (
        clk,
        rst_n,
        fifo_empty,
        fifo_rdata,
        fifo_rinc,
        out_valid,
        rand_num,

        fifo_clk3_flag1,
        fifo_clk3_flag2,
        fifo_clk3_flag3,
        fifo_clk3_flag4
        );

        input clk;
        input rst_n;
        input fifo_empty;
        input [31:0] fifo_rdata;
        output fifo_rinc;
        output reg out_valid;
        output reg [31:0] rand_num;
             //   $display(soti[ctr_2]," & ctr = %d",ctr_2);
        // You can change the input / output of the custom flag ports
        input fifo_clk3_flag1;
        input fifo_clk3_flag2;
        output fifo_clk3_flag3;
        output fifo_clk3_flag4;
        assign fifo_rinc = fifo_empty ? 1'b0 : 1'b1;
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>declaration input<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        parameter IDLE = 'd0, INPUT = 'd1, COMP = 'd2, OUT = 'd3,EMPTY=6, WAIT3='d7;
        reg [31:0] flipp,flippnext;
        reg [8:0] ctr;
        reg [2:0] c_state3, n_state;
        wire CS_COMP3 = c_state3 == COMP, CS_IDLE3 = c_state3 == IDLE, CS_OUT = c_state3 == OUT, CS_INPUT = c_state3 == INPUT,CS_WAIT3=c_state3==WAIT3;
        wire whistlblower_3=c_state3==WAIT3;//reset everyting 
        assign fifo_clk3_flag3=whistlblower_3;
        
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        always@(posedge clk or negedge rst_n) begin//nstate
            if(!rst_n) c_state3 <= IDLE;
            else c_state3 <= n_state;
        end
        always@(*) begin//cstate
            n_state = c_state3;
            case(c_state3)
                IDLE:           if(~fifo_empty)     n_state= COMP;
                COMP:           if(ctr==2)          n_state=OUT;
                OUT:            if(ctr==255)        n_state = WAIT3;
                EMPTY:          if(ctr==0)         n_state=IDLE;
                WAIT3:          if(ctr==2)          n_state=EMPTY;
                default:                            n_state = IDLE;
            endcase
        end
        always @(posedge clk or negedge rst_n) begin//ctr
            if (!rst_n)begin 
                ctr <= 'b0;
            end else begin
                if (n_state != c_state3)
                    ctr <='b0;
                else 
                    case (c_state3)
                        IDLE,COMP,OUT,WAIT3:     ctr <= ctr+1;
                        EMPTY:                   ctr <= ctr+1;
                        default:                 ctr <= 'b0;
                    endcase
            end
        end
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OUT and FFs<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        always @(posedge clk or negedge rst_n) begin//flipp,patdone
            if (!rst_n)begin 
                flipp<=0;  
                flippnext<=0;
            end else begin
                flipp<=fifo_rdata;
                flippnext<=flipp;
            end
        end
        always@(posedge clk or negedge rst_n)begin 
            if(!rst_n) begin 
                out_valid<=0;
                rand_num<=0;
            end else if (CS_OUT)begin        
                    out_valid<=1;
                    rand_num<=flipp;
                  //  $display("%h",flippnext);
            end else begin
            // if(CS_IDLE)$display(flippnext); 
                out_valid<=0;
                rand_num<=0;
            end
        end
    endmodule 