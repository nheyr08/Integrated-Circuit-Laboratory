//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2023 ICLAB Fall Course
//   Lab03      : BRIDGE
//   Author     : Ting-Yu Chang
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : pseudo_SD.v
//   Module Name : pseudo_SD
//   Release version : v1.0 (Release Date: Sep-2023)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module pseudo_SD (
    clk,
    MOSI,
    MISO
);

input clk;
input MOSI;
output reg MISO; 
reg start_bit=0;

parameter SD_p_r = "../00_TESTBED/SD_init.dat";

reg [63:0] SD [0:65535];
initial $readmemh(SD_p_r, SD);
integer bit_count=0;
reg [7:0] command_flipped=0,received_data=0;

//////////////////////////////////////////////////////////////////////
// Write your own task here
//////////////////////////////////////////////////////////////////////

reg [6:0] counter;
integer i,t,T;
integer counter,count;
reg [31:0] Argument;
reg [5:0]  True_Command;
reg [1:0]  Start_bit;
reg [6:0]  CRC_data, CRC_data_flipped;
reg [63:0] Data_block;
reg [7:0]  Token_Data;
reg [15:0] CRC16_Data;
reg grima, grima2,EndBit;
integer signed j;
reg pull;
int Resp1, Resp2,kkk;

always begin
    MISO=1;
    Resp1=0;
    Resp2=0;
    pull=0;
    counter=0;
    Argument=0;
    count=0;
    grima=0;
    CRC_data=0;
    Token_Data=0;
    //CRC16_Data=0;
    Data_block=0;
    start_bit=0;
    grima2=0;
    EndBit=0;
    Start_bit=0;
        
        //3333333333333333333333333333333333333 Receive Command from HOST 33333333333333333338333333333333333333333333333333333//
        while(start_bit==0)begin//get start bit
            if(MOSI==0)begin
                start_bit=1;
            end
            @(negedge clk);
        end
        while(start_bit==1)begin//command flipped
            command_flipped <= {MOSI, command_flipped[7:1]};
            @(negedge clk);
            counter=counter+1;
            if(counter==7)
                break;
        end
        True_Command={command_flipped[2],command_flipped[3],command_flipped[4],
        command_flipped[5],command_flipped[6],command_flipped[7]};
        Start_bit=command_flipped[1];

        counter=31;
        while(start_bit==1)begin //argument
            Argument[counter] <=MOSI;
            @(negedge clk);
            if(counter==0)
                break;
            counter=counter-1;
        end

        counter=6;
        while(start_bit==1)begin//CRC_data 
            CRC_data[counter] <= MOSI;
            @(negedge clk);
            if(counter==0)
                break;
            counter=counter-1;;
        end
        //3333333333333333333333333333333333333 Send Response to HOST 33333333333333333338333333333333333333333333333333333//
        EndBit=MOSI;
        Check_Address_Range;
        Check_Command_Format;//: Command format should be correct
        Check_CRC7;
        WAIT_TIME;
        
        Send_Received_Response;//: Send the received response to the bridge
        T=$urandom_range(1,32);
        //3333333333333333333333333333333333333 Send Response to HOST 33333333333333333338333333333333333333333333333333333//
        count=0;
    if(True_Command==24)begin 
        WAIT_TIME;
        Token_Data =8'b11111111;
        while(grima2==0)begin//get start bit
                if(MOSI==0) begin 
                    grima2=1;
                    Token_Data[0]<=MOSI;
            end
            count=count+1;
        @(negedge clk);
        end
      //  $display("count= %d",count);
        if((count%8)!=0)begin 
           $display("SPEC SD-5 FAIL");
           $finish;
           count=0;
        end

        counter=63;
        while(grima2==1)begin //Datablock
            Data_block[counter] <=MOSI;
            @(negedge clk);
            if(counter==0)
                break;
            counter=counter-1;
        end
        counter = 15;
        while(grima2==1)begin //Datablock
            CRC16_Data[counter] <=MOSI;
            @(negedge clk);
            if(counter==0)
                break;
            counter=counter-1;
        end
        Check_CRC16_CCITT;
        t=$urandom_range(0,8);
            MISO=0;
            @(negedge clk);
            MISO=0;
            @(negedge clk);
            MISO=0;
            @(negedge clk);
            MISO=0;
            @(negedge clk);
            MISO=0;
            @(negedge clk);
            MISO=1;
            @(negedge clk);
            MISO=0;
            @(negedge clk);
            MISO=1;
        @(negedge clk);
        MISO=0;
        WAIT_TIME;
        SD[Argument] = Data_block;

        MISO=1;
        counter=0;
        Argument=0;
        grima=0;
        grima2=0;
        CRC_data=0;
        Token_Data=0;
     //   CRC16_Data=0;
        Data_block=0;
        start_bit = 0;
    end else if (True_Command==17) begin 
        t=$urandom_range(0,8);
        Token_Data=8'b11111110;
      //  $display("CRC16_Data= %h",CRC16_Data);
        Data_block=SD[Argument];
        CRC16_Data=CRC16_CCITT(Data_block);
        repeat(8*t)@(negedge clk);
    
        if(True_Command==17)begin
            //send data through the MISO to DRAM
            pull=1;
            for(i=0;i<8;i=i+1)begin
                MISO=Token_Data[7-i];
                @(negedge clk);
            end
            for(i=0;i<64;i=i+1)begin
                MISO=Data_block[63-i];
                @(negedge clk);
            end
            for(i=0;i<16;i=i+1)begin
                MISO=CRC16_Data[15-i];
                @(negedge clk);
         end
            MISO =1;
            @(negedge clk);
         end 
    end
        MISO=1;
        counter=0;
        Argument=0;
        grima=0;
        grima2=0;
        CRC_data=0;
        Token_Data=0;
        CRC16_Data=0;
        Data_block=0;
        start_bit = 0;
        Start_bit=0;
        EndBit=0;
end 


///////////////////////////////////////////////////////////////////////////////////////////
task YOU_FAIL_task; begin
    $display("*                              FAIL!                                    *");
    $display("*                 Error message from pseudo_SD.v                        *");
end endtask


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

function automatic [16-1:0] CRC16_CCITT;  // Return 7-bit result
    input [64-1:0] data;  // 40-bit data input
    reg [16-1:0] crc;
    integer i;
    reg data_in, data_out;
    parameter polynomial = 16'h1021;  // x^7 + x^3 + 1

    begin
         //   $display("IN PSEUDO CRC16_CCITT(data)= %h",data);
        crc = 16'd0;
        for (i = 0; i < 64; i = i + 1) begin
            data_in = data[63-i];
            data_out = crc[15];
            crc = crc << 1;  // Shift the CRC
            if (data_in ^ data_out) begin
                crc = crc ^ polynomial; 
            //    $display("IN PSEUDO CRC16_CCITT(crc and i)= %h,%d",crc,i);
            end
        end
        CRC16_CCITT = crc;
       //$display("IN PSEUDO CRC16_CCITT(final)= %h,",CRC16_CCITT);
    end
endfunction
task Check_Command_Format; begin
 if((True_Command!==17&&True_Command!==24)||(Start_bit!=2'b01)||(EndBit!=1'b1)) begin
  $display("SPEC SD-1 FAIL");
  $finish;
 end
end endtask

task Check_Address_Range; begin 
    if(Argument>65535||Argument<0)begin 
    $display("SPEC SD-2 FAIL");
    $finish;
    end
end endtask

task Check_CRC7; begin//done
 if(CRC7({Start_bit,True_Command,Argument}) !== CRC_data) begin 
        $display("SPEC SD-3 FAIL");
        $finish;
 end
end endtask

task Check_CRC16_CCITT; begin//done
 if(CRC16_CCITT(Data_block) !== CRC16_Data) begin 
        $display("SPEC SD-4 FAIL");
        $finish;
 end
end endtask

task Time_between_transmision; begin//only integer time is allowed
  $display("SPEC SD-5 FAIL");
  $finish;
end endtask
task WAIT_TIME; begin 
    repeat(8)@(negedge clk);
end endtask
task  Send_Received_Response;begin 
       repeat(1)@(negedge clk);
        MISO=0;
        WAIT_TIME;
        MISO=1;
end endtask

endmodule
//############################################################################