//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2023/10
//		Version		: v1.0
//              Author       : Betsaleel Henry (henrybetsaleel@gmail.com)
//   	File Name   : HT_TOP.v
//   	Module Name : HT_TOP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
//`include "SORT_IP.v"
//synopsys translate_on

module HT_TOP(
    // Input signals
    clk,
	rst_n,
	in_valid,
    in_weight, 
	out_mode,
    // Output signals
    out_valid, 
	out_code
);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    // ===============================================================
    // Input & Output Declaration
    // ===============================================================
    input clk, rst_n, in_valid, out_mode;
    input [2:0] in_weight;
    output reg out_valid, out_code;
    reg [1:0] c_state, n_state;
    // ===============================================================
    // Reg & Wire Declaration
    // ===============================================================
    // reg [4:0] table_ [7:0];
    reg [4:0] ctr;
    reg [39:0] weights; 
    reg [31:0] characters,out_character; 
    reg mode_reg;
    reg  [3:0] i;
    reg  [2:0] ctr_1;
    reg  [2:0] offset;
    reg  [2:0] lenght_[7:0];//ap responsab kenbe stati varyab yo
    reg  [3:0] salfeyo [7:0];//salfeyo ap responsab anrejistre addressyo
    reg  [0:0] rezilta[7:0][6:0];//kenbe rezilta yo
    wire DOneisdone=(ctr>(lenght_[3]+lenght_[5]+lenght_[2]+lenght_[7]+lenght_[6])-1)&&(mode_reg==1)||(ctr>lenght_[3]+lenght_[2]+lenght_[1]+lenght_[0]+lenght_[4]-1)&&(mode_reg==0);
    reg  [4:0] array_k [15:0];//kenbe nouvo weight yo 
    parameter INPUT=1,IDLE=0, COMP=2, OUT=3, IP_WIDTH=8;
    wire CS_INPUT= (c_state==INPUT) ?1:0;
    wire CS_COMP = (c_state==COMP)  ?1:0;
    wire CS_OUT  = (c_state==OUT)   ?1:0;
    wire CS_IDLE = (c_state==IDLE)  ?1:0;
    wire [3:0] k1=out_character[3:0],k2=out_character[7:4],k3=out_character[11:8],k4=out_character[15:12],k5=out_character[19:16],k6=out_character[23:20],k7=out_character[27:24],k8=out_character[31:28];
    wire [4:0] SUM_= array_k[k1]+array_k[k2];
    genvar idx, jdx;


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FSM>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    always @(*) begin //n_state
        case(c_state)
            IDLE:
                if(in_valid)                          n_state = INPUT;
                else                                  n_state = IDLE;
            INPUT:
                if  (!in_valid)                       n_state = COMP;
                else                                  n_state = INPUT;
            COMP:
                if     (ctr==6)                       n_state = OUT;
                else                                  n_state = COMP;
            OUT:       if(DOneisdone)                 n_state = IDLE;
            else                                      n_state = OUT;
            default:                                  n_state = IDLE;
        endcase 
    end
    always @ (posedge clk or negedge rst_n) begin //c_state
        if(~rst_n) begin
            c_state <= 0;
        end else begin
            c_state <= n_state;
        end
    end
    always @(posedge clk or negedge rst_n) begin//ctr
        if (~rst_n) begin
            ctr <= 3'b0;
        end else begin
            case(c_state)
                    IDLE:
                        if(in_valid) begin
                            ctr <= ctr+1;
                        end else begin
                            ctr <= 0;
                        end
                    INPUT:
                        if(in_valid) begin
                            ctr <= ctr+1;
                        end else if(n_state==COMP) begin
                            ctr <=0;
                        end
                    COMP:
                        if(ctr!=6) begin
                            ctr <= ctr+1;
                        end else begin
                            ctr <= 0;
                        end
                    OUT:
                        if(DOneisdone) begin
                            ctr <= 0;
                        end else begin
                            ctr <= ctr+1;
                        end
                    default:
                        ctr <= 0;
                endcase 
        end
    end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>comp>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    always@(posedge clk or negedge rst_n) begin//mode_reg
        if(!rst_n) 
            mode_reg <= 0;
        else if( in_valid&&ctr==0) begin
            mode_reg <= out_mode;
        end else begin
            mode_reg <= mode_reg;
        end
    end    
    SORT_IP #(.IP_WIDTH(IP_WIDTH)) I_SORT_IP(.IN_character(characters), .IN_weight(weights), .OUT_character(out_character)); 
//><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<design<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

always@(posedge clk or negedge rst_n)begin
    if(~rst_n)begin 
        weights<=0;
        characters=0;
         offset='d7;
        for(i=0;i<15;i=i+1)begin 
            array_k[i]=0;
        end 
    end else begin 
        if (in_valid&&ctr<8) begin
            array_k[0]=31;
            array_k[15-ctr]=in_weight;
            weights<={array_k[15],array_k[14],array_k[13],array_k[12],array_k[11],array_k[10],array_k[9],array_k[8]};
            characters = {4'd15, 4'd14, 4'd13, 4'd12, 4'd11, 4'd10, 4'd9, 4'd8};  
        end else if(CS_COMP) begin
            array_k[7-ctr]=SUM_;
            characters = {offset,k3, k4, k5, k6, k7, k8 ,4'b0000};  
            weights<={SUM_,array_k[k3],array_k[k4],array_k[k5],array_k[k6],array_k[k7],array_k[k8],5'b11111}; 
            offset=offset-1;
        end  else if(CS_IDLE)begin 
                for(i=0;i<15;i=i+1)begin 
                    array_k[i]=0;
                end 
                    weights<=0;
                    characters=0;
                    offset='d7;
        end else begin 
            weights<=weights;
            characters=characters;
            offset=offset;
            for(i=0;i<15;i=i+1)begin 
                array_k[i]= array_k[i];
            end
        end
    end 
end
 always@(posedge clk or negedge rst_n)begin 
            if (~rst_n)begin 
                for(i=0;i<8;i++)begin 
                    lenght_[i]=0;
                    salfeyo[i]=0;  
                end
            end else begin 
                if(in_valid&&ctr<8)begin
                    salfeyo[7-ctr]=15-ctr;
                end else if(CS_COMP)begin 
                    rezilta[k1][lenght_[k1]]=1; 
                    rezilta[k2][lenght_[k2]]=0; 
                        for(i=0;i<8;i++)begin 
                            if(k1== salfeyo[i]) begin
                                rezilta[i][lenght_[i]]=1; 
                                lenght_[i]=lenght_[i]+1;
                                salfeyo[i]=4'd7-ctr;
                            end else if(salfeyo[i]==k2)begin
                                rezilta[i][lenght_[i]]=0; 
                                salfeyo[i]=4'd7-ctr;
                                lenght_[i]=lenght_[i]+1;
                            end
                        end
                   
                end else if(CS_IDLE)begin 
                     for(i=0;i<8;i++)begin 
                        lenght_[i]=0;
                        salfeyo[i]=0;  
                        rezilta[i][0]=0; 
                        rezilta[i][1]=0;
                        rezilta[i][2]=0;
                        rezilta[i][3]=0;
                    end
                end
            end

        end
//><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<out<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin 
            out_valid=0;
            out_code=0;
            ctr_1=1;
        end else begin 
        case(c_state)
            OUT: begin
                if(mode_reg==1)begin
                    out_valid=1;
                    if(ctr<lenght_[3])begin          
                        out_code=rezilta[3][lenght_[3]-ctr_1];
                       // $display("outcode: %b, ctr: %d , kati= %b, ctr_1= %d",out_code,ctr,kati,ctr_1);
                     end else if(ctr<lenght_[3]+lenght_[5])begin          
                        out_code=rezilta[5][lenght_[5]-ctr_1];
                       // $display("outcode: %b, ctr: %d , kati= %b, ctr_1= %d",out_code,ctr,kati,ctr_1);
                    end  else if(ctr<lenght_[3]+lenght_[5]+lenght_[2])begin 
                        out_code=rezilta[2][lenght_[2]-ctr_1];
                       // $display("outcode: %b, ctr: %d , kati= %b, ctr_1= %d",out_code,ctr,kati,ctr_1);
                      end else if(ctr<lenght_[3]+lenght_[5]+lenght_[2]+lenght_[7])begin 
                        out_code=rezilta[7][lenght_[7]-ctr_1];
                        //$display("outcode: %b, ctr: %d , kati= %b, ctr_1= %d",out_code,ctr,kati,ctr_1);
                     end else if(ctr<lenght_[3]+lenght_[5]+lenght_[2]+lenght_[7]+lenght_[6])begin 
                        out_code=rezilta[6][lenght_[6]-ctr_1];
                       // $display("outcode: %b, ctr: %d , kati= %b, ctr_1= %d",out_code,ctr,kati,ctr_1);
                     end else begin 
                        out_code=0;
                     end 

                    if(ctr==lenght_[3]-1)begin          
                        ctr_1=1;
                     end else if(ctr==lenght_[3]+lenght_[5]-1)begin          
                        ctr_1=1;
                    end else if(ctr==lenght_[3]+lenght_[5]+lenght_[2]-1)begin 
                        ctr_1=1;
                     end else if(ctr==lenght_[3]+lenght_[5]+lenght_[2]+lenght_[7]-1)begin 
                        ctr_1=1;
                     end else if(ctr==lenght_[3]+lenght_[5]+lenght_[2]+lenght_[7]+lenght_[6]-1)begin 
                        ctr_1=1;
                     end else begin 
                        ctr_1=ctr_1+1;
                     end 
                if(DOneisdone) begin 
                out_code=0;
                out_valid=0;
                end
           //     out_code=tableloid[1][7-ctr];
                 //   $display("outcode: %b, ctr: %d , kati= %b, ctr_1= %d",out_code,ctr,kati,ctr_1);
        end  else if(mode_reg==0) begin 
               out_valid=1;
                    if(ctr<lenght_[3])begin          
                        out_code=rezilta[3][lenght_[3]-ctr_1];
                     end else if(ctr<lenght_[3]+lenght_[2])begin          
                        out_code=rezilta[2][lenght_[2]-ctr_1];
                    end  else if(ctr<lenght_[3]+lenght_[2]+lenght_[1])begin 
                        out_code=rezilta[1][lenght_[1]-ctr_1];
                      end else if(ctr<lenght_[3]+lenght_[2]+lenght_[1]+lenght_[0])begin 
                        out_code=rezilta[0][lenght_[0]-ctr_1];
                     end else if(ctr<lenght_[3]+lenght_[2]+lenght_[1]+lenght_[0]+lenght_[4])begin 
                        out_code=rezilta[4][lenght_[4]-ctr_1];
                     end else begin 
                        out_code=0;
                     end 
   
                 if(ctr==lenght_[3]-1)begin          
                        ctr_1=1;
                     end else if(ctr==lenght_[3]+lenght_[2]-1)begin          
                        ctr_1=1;
                    end else if(ctr==lenght_[3]+lenght_[2]+lenght_[1]-1)begin 
                        ctr_1=1;
                     end else if(ctr==lenght_[3]+lenght_[2]+lenght_[1]+lenght_[0]-1)begin 
                        ctr_1=1;
                     end else if(ctr==lenght_[3]+lenght_[2]+lenght_[1]+lenght_[0]+lenght_[4]-1)begin 
                        ctr_1=1;
                     end else begin 
                        ctr_1=ctr_1+1;
                     end 

               if(DOneisdone) begin 
                out_code=0;
                out_valid=0;
                end
                end 
        end 
        default:begin 
                    out_valid=0;
                    out_code=0;
                    ctr_1=1;
                end
        endcase
        end
    end
endmodule

