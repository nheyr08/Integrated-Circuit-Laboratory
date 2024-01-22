//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2023 ICLAB Fall Course
//   Lab03      : BRIDGE
//   Author     : Betsaleel Henry
//    
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : BRIDGE_encrypted.v
//   Module Name : BRIDGE
//   Release version : v1.0 (Release Date: Sep-2023)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module BRIDGE(
    // Input Signals
    clk,
    rst_n,
    in_valid,
    direction,
    addr_dram,
    addr_sd,
    // Output Signals
    out_valid,
    out_data,
    // DRAM Signals
    AR_VALID, AR_ADDR, R_READY, AW_VALID, AW_ADDR, W_VALID, W_DATA, B_READY,
	AR_READY, R_VALID, R_RESP, R_DATA, AW_READY, W_READY, B_VALID, B_RESP,
    // SD Signals
    MISO,
    MOSI
);

// Input Signals
    input clk, rst_n;
    input in_valid;
    input direction;
    input [12:0] addr_dram;
        input [15:0] addr_sd;   

    // Output Signals
    output reg out_valid;
    output reg [7:0] out_data;  

    // DRAM Signals
    // write address channel
    output reg [31:0] AW_ADDR;
    output reg AW_VALID;
    input AW_READY;
    // write data channel
    output reg W_VALID;
    output reg [63:0] W_DATA;
    input W_READY;
    // write response channel
    input B_VALID;
    input [1:0] B_RESP;
    output reg B_READY;
    // read address channel
    output reg [31:0] AR_ADDR;
    output reg AR_VALID;
    input AR_READY;
    // read data channel
    input [63:0] R_DATA;
    input R_VALID;
    input [1:0] R_RESP;
    output reg R_READY; 

    // SD Signals
    input MISO;
    output reg MOSI;

//==============================================//
    integer i,j,k;
    reg Direction_Flag;
    reg [31:0] Data_block;
    reg [7:0] Token_Data;
    reg [31:0] address_dram;
    reg [31:0] address_sd;
    reg AlreadysentAW;
    reg AlreadysentAR;
    reg [1:0]   State;
    reg [10:0]   ctr;
    reg [3:0] next_state, curr_state;
    reg [10:0] CtrPLUStwo;
    reg AlreadysentR;
    reg [1:0] R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15;
    reg [6:0] CRC_DATA;
    reg [15:0] CRC_16_DATA;
    reg [48:0]SENT_TO_SD;
    reg mosi_state, mosi_prev;
    reg [3:0] count_MISO_Zero;
    reg [87:0] DATA_Transfer;
    reg [63:0] READ_DATA;
    reg [63:0] Data1,Data2,Data3,Data4,Data5,Data6,Data7;
    parameter   IDLE    = 'd0,
                INPUT   = 'd1,
                READ    = 'd2,
                WRITE   = 'd3,
                SENDMOSI= 'd4,
                PREADSD = 'd5,
                PWRITESD= 'd6,
                OUT     = 'd8,
                WAIT    = 'd7,
                WAITLASTRESPONSE='d9,
                DATASD  = 'd10;
    wire Is_Write_Operation=(Direction_Flag==1);
    wire Is_Read_Operation=(Direction_Flag==0);
    wire AddressDramValid=(address_dram>0)&&(address_dram<8191);
    wire AddressSDValid=(address_sd>0)&&(address_sd<65535);
    wire CS_SENDMOSI=(curr_state==SENDMOSI);
    wire CS_PREADSD=(curr_state==PREADSD);
    wire CS_DATASD=(curr_state==DATASD);    
//==============================================//
//       parameter & integer declaration        //
//==============================================//
    wire CS_Read=(curr_state==READ);    
    wire CS_Write=(curr_state==WRITE);
    wire CS_Input=(curr_state==INPUT);
    wire CS_Idle=(curr_state==IDLE);
    wire CS_Out=(curr_state==OUT);
    wire CS_PWriteSD=(curr_state==PWRITESD);
    wire CS_WAIT=(curr_state==WAIT);
    wire DOneisdone=(ctr>87+8);
    wire [15:0] Index =(CS_PWriteSD)? (87)-ctr:1;
    wire CS_WAITLASTRESPONSE=(curr_state==WAITLASTRESPONSE);
    reg [2:0] lastresponse;
    




always @(*) begin //next_state
    case(curr_state)
        IDLE:
            if(in_valid)                          next_state = INPUT;
            else                                  next_state = IDLE;
        INPUT:
            if  (Is_Write_Operation)              next_state = WRITE;
            else if(Is_Read_Operation)            next_state = READ;
            else                                  next_state = INPUT;
        READ:
            if     (R_VALID)                      next_state = SENDMOSI;
            else                                  next_state = READ;
        WRITE: 
            if     ((count_MISO_Zero==9))         next_state = DATASD;
            else                                  next_state = WRITE;
        SENDMOSI:
            if     (count_MISO_Zero==8)           next_state = WAIT;
            else                                  next_state = SENDMOSI;
        PREADSD:
            if     (B_VALID)                      next_state = OUT;
            else                                  next_state = PREADSD;
        DATASD: 
            if     (ctr==87)                      next_state = PREADSD;
            else                                  next_state = DATASD;
        PWRITESD:
            if     (Index==0)                     next_state = WAITLASTRESPONSE;
            else                                  next_state = PWRITESD;
        WAIT: 
            if     (ctr==5)                       next_state = PWRITESD;
            else                                  next_state = WAIT;
        WAITLASTRESPONSE: 
            if     (lastresponse==4)              next_state = OUT;
            else                                  next_state = WAITLASTRESPONSE;
        OUT:
            if     (ctr==7)                       next_state = IDLE; 
            else                                  next_state = OUT;
        default:                                  next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin//ctr
    if(!rst_n)  ctr <= 0;
    else begin 
        case(curr_state)
            IDLE:                                                ctr <= 0;
            INPUT: if(next_state==READ||next_state==WRITE)       ctr<=0;
                    else                                         ctr <= ctr + 1;
            READ:  if(next_state==SENDMOSI)                      ctr<=0;
                    else                                         ctr <= ctr + 1;
            WRITE: if(next_state==DATASD)                        ctr<=2;
                    else                                         ctr <= ctr + 1;
            PREADSD:if(next_state==OUT)                          ctr<=0;
                    else                                         ctr <= ctr + 1;
            SENDMOSI:if(next_state==WAIT)                        ctr<=0;
                    else                                         ctr <= ctr + 1;
            WAIT:   if(next_state==PWRITESD)                     ctr<=0;
                    else                                         ctr <= ctr + 1;
            OUT:    if(next_state==IDLE)                         ctr<=0;
                    else                                         ctr <= ctr + 1;
            DATASD: if(next_state==PREADSD)                      ctr<=0;
                    else                                         ctr <= ctr + 1;
            WAITLASTRESPONSE:if(next_state==OUT)                 ctr<=0;
                    else                                         ctr <= ctr + 1;
            PWRITESD:if(next_state==OUT)                         ctr<=0;
                    else                                         ctr <= ctr + 1;
            default:                                             ctr <= 0;
        endcase
    end
end
always @(posedge clk or negedge rst_n) begin//State
    if(!rst_n) curr_state <= IDLE;
    else       curr_state <= next_state;
end

//==============================================//
//           reg & wire declaration             //
//==============================================//
always@(posedge clk or negedge rst_n)begin      //save addresses
    if(!rst_n)begin 
        address_dram<=0;
        address_sd<=0;
    end else if(in_valid)begin 
        address_dram<=addr_dram;
        address_sd<=addr_sd;
    end else begin 
        address_dram<=address_dram;
        address_sd<=address_sd;
    end
end
always@(posedge clk or negedge rst_n)begin //save Direction
    if(!rst_n)begin 
        Direction_Flag<=0;
    end else if(in_valid)begin // (0) DRAM → SD card, out_data // (1) SD card → DRAM, in_data
        Direction_Flag<=direction; 
    end else begin 
        Direction_Flag<=Direction_Flag;
    end
end
///////////////////                     ///////////////////////

///////////////          READ PART        ////////////////////

///////////////////                     ///////////////////////

always @(*)begin //ARvalid ARaddr
        case(curr_state)            
            READ: begin
             if(!AlreadysentAR) begin 
                AR_VALID=1;
                AR_ADDR=address_dram;
             end else if (AlreadysentAR)  begin
                AR_VALID=0;
                AR_ADDR=0;
             end else begin
                AR_VALID=0;
                AR_ADDR=0;
             end 
            end
            default: begin
              AR_VALID=0; 
              AR_ADDR=0;
            end 
        endcase
end
always@(posedge clk or negedge rst_n)begin //R1 follows ARvalid
    if(!rst_n)begin 
        R1<=0;
    end else begin
        case(curr_state)
        READ:begin 
            if(AR_READY) begin 
                R1<=1;
            end else if (R_VALID) begin 
                R1<=0;
            end  else begin 
                R1<=R1;
            end
        end
        endcase
    end
end
always@(posedge clk or negedge rst_n)begin //R3 follows ARvalid
    if(!rst_n)begin 
        R3<=0;
    end else begin
        case(curr_state)
        WRITE:begin 
            if(AW_READY) begin 
                R3<=1;
            end else if (W_VALID) begin 
                R3<=0;
            end  else begin 
                R3<=R3;
            end
        end
        endcase
    end
end
always@(posedge clk or negedge rst_n)begin //R2 follows Rvalid
    if(!rst_n)begin 
        R2<=0;
    end else begin
        case(curr_state)
        READ:begin 
             if (R_VALID) begin 
                R2<=1;
            end  else begin 
                R2<=R2;
            end
        end
        endcase
    end
end
always @(posedge clk or negedge rst_n)begin //R_ready
    if(!rst_n)begin
        R_READY<=0;
    end else begin 
        case(curr_state)            
            READ: begin
                if(/*AR_READY||AlreadysentAR&&ctr>CtrPLUStwo R_VALID||AlreadysentR*/
                   // AR_READY||
                   // AlreadysentR)
                    R1!=0)
                    begin 
                    R_READY<=1;
                    end else if(R1==0)begin 
                    R_READY<=0;
                end else   begin
                    R_READY<=0;
                end 
            end
            default: begin
              R_READY<=0; 
            end 
        endcase
    end
end
always@(posedge clk or negedge rst_n)begin //R3 follows ARvalid
    if(!rst_n)begin 
        W_VALID<=0;
        W_DATA<=0;
    end else begin
        case(curr_state)
        PREADSD:begin 
            if(AW_VALID&&AW_READY) begin 
                W_VALID<=1;
                W_DATA<=DATA_Transfer[87:23];
            end else if (W_READY) begin 
                W_VALID<=0;
                W_DATA<=0;
            end  else begin 
                W_VALID<=W_VALID;
                W_DATA<=W_DATA;
            end
        end
        endcase
    end
end

always@(posedge clk or negedge rst_n)begin//SENT_TO_SD
    if(!rst_n)begin 
        SENT_TO_SD=0;
    end else begin 
                if(R_VALID) 
                    SENT_TO_SD={2'b01,6'd24,address_sd,CRC7({2'b01,6'd24,address_sd}),1'b1};
                else if (CS_Write&&ctr==0)                 
                   SENT_TO_SD={2'b01,6'd17,address_sd,CRC7({2'b01,6'd17,address_sd}),1'b1};
                else 
                   SENT_TO_SD=SENT_TO_SD;
    end
end
always@(posedge clk or negedge rst_n)begin //CTRPLUStwo
    if(!rst_n)begin 
     CtrPLUStwo<=0;
    end else begin 
        if(AR_READY)begin 
            CtrPLUStwo<=ctr+3;
        end else begin 
            CtrPLUStwo<=CtrPLUStwo;
        end
    end
end
always@(posedge clk or negedge rst_n)begin //Readata during invalid
    if(!rst_n)begin 
        READ_DATA<=0;
    end else begin 
        if(R_VALID)begin 
            READ_DATA<=R_DATA;
        end else begin 
            READ_DATA<=READ_DATA;
        end
    end
end
always@(posedge clk or negedge rst_n)begin //MISO
    if(!rst_n)begin 
        MOSI<=1;
    end else begin 
         if(CS_SENDMOSI&&ctr<47&&count_MISO_Zero==0) MOSI<=SENT_TO_SD[47-ctr];
         else if(CS_WAIT)MOSI<=1;
         else if ((CS_PWriteSD&&count_MISO_Zero==8)&&ctr<88) MOSI<=DATA_Transfer[Index];  
         else if( CS_Write&&ctr<47) if(ctr==0)MOSI<=0; else MOSI<=SENT_TO_SD[47-ctr]; 
         else MOSI<=1;
    end
end

///////////////////                     ///////////////////////

///////////////          WRITE PART        ////////////////////

///////////////////                     ///////////////////////

always @(*)begin //AWvalid AWaddr
        case(curr_state)            
            PREADSD: begin
             if(!AlreadysentAW) begin 
                AW_VALID=1; 
                AW_ADDR=address_dram;            
             end else  begin
                AW_VALID=0;
                AW_ADDR=0;
             end 
            end
            default: begin
              AW_VALID=0; 
              AW_ADDR=0;
            end 
        endcase
end
always @(posedge clk or negedge rst_n)begin //AWvalid AWaddr
    if(!rst_n)begin
     B_READY=0;
    end else begin 
            case(curr_state)            
                PREADSD: begin
                        if(AlreadysentAW||(B_VALID)) begin 
                            B_READY=1; 
                        end else begin 
                            B_READY=B_READY;
                        end
                    end
                default: begin
                    B_READY=B_READY;
                end 
            endcase
    end
end

always @(posedge clk or negedge rst_n)begin //CRC data
        if(!rst_n)begin 
            CRC_16_DATA=0;
        end else begin
                if(count_MISO_Zero==1)begin
                    CRC_16_DATA=CRC16_CCITT(READ_DATA);
                end else begin 
                    CRC_16_DATA=CRC_16_DATA;
                end
        end
end
always @(posedge clk or negedge rst_n)begin //CRC data
        if(!rst_n)begin 
            CRC_DATA=0;
        end else begin
                if(R_VALID)begin
                    CRC_DATA=CRC7({2'b01,6'd24,address_sd});
                    $display("CRC_DATA= %h",CRC_DATA);
                end else begin 
                    CRC_DATA=CRC_DATA;
                end
        end
end
always@(posedge clk or negedge rst_n)begin //alreadysentAWready
    if(!rst_n)begin 
        AlreadysentAW<=0;
    end else begin
        case(curr_state)
            PREADSD: begin
                   if((AW_READY==1))
                     AlreadysentAW<=1;
                     else
                     AlreadysentAW<=AlreadysentAW;
            end
            default: AlreadysentAW<=0;
        endcase
    end
end
//already sent bvalid
// always@(posedge clk or negedge rst_n)begin //alreadysentBVALID
//     if(!rst_n)begin 
//         AlreadysentB<=0;
//     end else begin
//         case(curr_state)
//             PREADSD: begin
//                    if((B_VALID==1)&&AlreadysentB)
//                      AlreadysentB<=0;
//                      else if((B_VALID==0))
//                      AlreadysentB<=1;
//             end
//             default: AlreadysentB<=0;
//         endcase
//     end
// end
always@(posedge clk or negedge rst_n)begin //alreadysentARready
    if(!rst_n)begin 
        AlreadysentAR<=0;
    end else begin
        case(curr_state)
            READ: begin
                   if((AR_READY==1)&&(curr_state==READ))
                     AlreadysentAR<=1;
                     else
                     AlreadysentAR<=AlreadysentAR;
            end
            default: AlreadysentAR<=0;
        endcase
    end
end


always@(posedge clk or negedge rst_n)begin //alreadysentRvalid
    if(!rst_n)begin 
        AlreadysentR<=0;
    end else begin
        case(curr_state)
            READ: begin
                   if((R_VALID==1)&&(curr_state==READ))
                     AlreadysentR<=1;
                     else
                     AlreadysentR<=AlreadysentR;
            end
            default: AlreadysentR<=0;
        endcase
    end
end 

function automatic [6:0] CRC7;  // Return 7-bit result
    input [39:0] data;  // 40-bit data input
    reg [6:0] crc;
    integer i;
    reg data_in, data_out;
    parameter polynomial = 7'h9;  // x^7 + x^3 + 1

    begin
        crc = 7'd0;
        for (i = 0; i < 40; i = i + 1) begin
            data_in = data[39-i];
            data_out = crc[6];
            crc = crc << 1;  // Shift the CRC
            if (data_in ^ data_out) begin
                crc = crc ^ polynomial;
            end
        end
        CRC7 = crc;
    end
endfunction

function automatic [15:0] CRC16_CCITT;  // Return 7-bit result
    input [63:0] data;  // 40-bit data input
    reg [15:0] crc;
    integer i;
    reg data_in, data_out;
    parameter polynomial = 16'h1021;  // x^7 + x^3 + 1

    begin
       //     $display("In bridge CRC16_CCITT(data)= %h",data);

        crc = 16'd0;
        for (i = 0; i < 64; i = i + 1) begin
            data_in = data[63-i];
            data_out = crc[15];
            crc = crc << 1;  // Shift the CRC
            if (data_in ^ data_out) begin
                crc = crc ^ polynomial; 
            end
        end
        CRC16_CCITT = crc;
    end
endfunction

always@(posedge clk or negedge rst_n)begin //count_MISO_Zero
    if(!rst_n)begin 
        count_MISO_Zero<=0;
    end else 
    if((CS_SENDMOSI)&&(MISO==0)||(CS_Write&&MISO==0))begin 
        count_MISO_Zero<=count_MISO_Zero+1;
    end else if(in_valid) begin 
        count_MISO_Zero<=0;
    end else  begin
        count_MISO_Zero<=count_MISO_Zero;
    end
end
always@(posedge clk or negedge rst_n)begin //DATA_Transfer
    if(rst_n==0)begin 
    DATA_Transfer=0;
    end else begin 
        if(count_MISO_Zero==5&&!CS_Write)begin 
            DATA_Transfer={8'hFE,READ_DATA[63:0],CRC_16_DATA[15:0]};
        end else if  (CS_DATASD&&ctr<87-2)begin
            DATA_Transfer[87-ctr]=MISO;
        end else if  (CS_Write&&count_MISO_Zero==9)begin
            DATA_Transfer[86]=MISO;
        end else if  (CS_Write&&count_MISO_Zero==8)begin
            DATA_Transfer[87]=MISO;
        end else if(in_valid) begin 
            DATA_Transfer=0;
        end else begin 
            DATA_Transfer=DATA_Transfer;
        end
    end
end
always@(posedge clk or negedge rst_n) begin//out_valid
    if(!rst_n) 
        out_valid <= 0; /* remember to reset */
    else if(CS_Out)begin
        out_valid <= 1;
    end else begin
        out_valid <= 0;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin 
        lastresponse<=0;
    end else begin 
        if((CS_WAITLASTRESPONSE)&&(MISO))
            lastresponse<=lastresponse+1;
         else begin 
            lastresponse<=lastresponse;
        end
    end
end

always@(posedge clk or negedge rst_n) begin //out_data
    if(!rst_n)begin 
        out_data<=0;
    end else if(CS_Out)begin
         if(!Direction_Flag)begin 
        case(ctr)
        0: out_data<=READ_DATA[63:56];
        1: out_data<=READ_DATA[55:48];
        2: out_data<=READ_DATA[47:40];
        3: out_data<=READ_DATA[39:32];
        4: out_data<=READ_DATA[31:24];
        5: out_data<=READ_DATA[23:16];
        6: out_data<=READ_DATA[15:8];
        7: out_data<=READ_DATA[7:0];
        default: out_data <= 8'b0; // Handle any other case
        endcase
         end else begin 
        case (ctr)
        0: out_data <= DATA_Transfer[87:87-8];
        1: out_data <= DATA_Transfer[79:79-8];
        2: out_data <= DATA_Transfer[71:71-8];
        3: out_data <= DATA_Transfer[63:63-8];
        4: out_data <= DATA_Transfer[55:55-8];
        5: out_data <= DATA_Transfer[47:47-8];
        6: out_data <= DATA_Transfer[39:39-8];
        7: out_data <= DATA_Transfer[31:31-8];
        default: out_data <= 8'b0; // Handle any other case
        endcase
        end
    end else begin
        out_data<=0;
    end
end 


endmodule
//############################################################################