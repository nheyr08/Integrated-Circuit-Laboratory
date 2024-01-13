//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab01 Exercise		: Supper MOSFET Calculator
//   Author     		: Betsaleel Henry (henrybetsaleeel@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SMC.v
//   Module Name : SMC
//   Release version : V1.0 (Release Date: 2023-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module SMC(
  // Input signals
    mode,
    W_0, V_GS_0, V_DS_0,
    W_1, V_GS_1, V_DS_1,
    W_2, V_GS_2, V_DS_2,
    W_3, V_GS_3, V_DS_3,
    W_4, V_GS_4, V_DS_4,
    W_5, V_GS_5, V_DS_5,   
  // Output signals
    out_n
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [2:0] W_0, V_GS_0, V_DS_0;
input [2:0] W_1, V_GS_1, V_DS_1;
input [2:0] W_2, V_GS_2, V_DS_2;
input [2:0] W_3, V_GS_3, V_DS_3;
input [2:0] W_4, V_GS_4, V_DS_4;
input [2:0] W_5, V_GS_5, V_DS_5;
input [1:0] mode;
output [7:0]  out_n;         					// use this if using continuous assignment for out_n  // Ex: assign out_n = XXX;
//output reg [7:0] out_n; 						// use this if using procedure assignment for out_n   // Ex: always@(*) begin out_n = XXX; end
//================================================================
//    Wire & Registers 
//================================================================
wire is_triode_mode_0,is_triode_mode_1,is_triode_mode_2,
is_triode_mode_3,is_triode_mode_4,is_triode_mode_5;
wire [2:0] Vov0,Vov1,Vov2,Vov3,Vov4,Vov5;
wire  [7:0] a0,a1,a2,a3,a4,a5,b0,b1,b2,b3,
c3,c4,c5,c1,d0,d1,d2,d3,f0,f1,f2,c0,g1,g2,
f3,f4,f5,g0,
g3,g4,g5,c2,
pot0,  pot1,
pot2;
reg  [7:0]  Idn  [5:0];
wire [8:0] out_0,out_1;

//================================================================
//    DESIGN
//================================================================
assign Vov0=(V_GS_0==3)?2:((V_GS_0==4)?3:(V_GS_0==5)?4:(V_GS_0==6)?5:(V_GS_0==7)?6:(V_GS_0==2)?1:0);    
assign Vov1=(V_GS_1==3)?2:((V_GS_1==4)?3:(V_GS_1==5)?4:(V_GS_1==6)?5:(V_GS_1==7)?6:(V_GS_1==2)?1:0);
assign Vov2=(V_GS_2==3)?2:((V_GS_2==4)?3:(V_GS_2==5)?4:(V_GS_2==6)?5:(V_GS_2==7)?6:(V_GS_2==2)?1:0);
assign Vov3=(V_GS_3==3)?2:((V_GS_3==4)?3:(V_GS_3==5)?4:(V_GS_3==6)?5:(V_GS_3==7)?6:(V_GS_3==2)?1:0);
assign Vov4=(V_GS_4==3)?2:((V_GS_4==4)?3:(V_GS_4==5)?4:(V_GS_4==6)?5:(V_GS_4==7)?6:(V_GS_4==2)?1:0);
assign Vov5=(V_GS_5==3)?2:((V_GS_5==4)?3:(V_GS_5==5)?4:(V_GS_5==6)?5:(V_GS_5==7)?6:(V_GS_5==2)?1:0);

assign is_triode_mode_0= (V_DS_0<=(Vov0));
assign is_triode_mode_1= (V_DS_1<=(Vov1));
assign is_triode_mode_2= (V_DS_2<=(Vov2));
assign is_triode_mode_3= (V_DS_3<=(Vov3));
assign is_triode_mode_4= (V_DS_4<=(Vov4));
assign is_triode_mode_5= (V_DS_5<=(Vov5));

// --------------------------------------------------
// write your design here
// --------------------------------------------------

/*Calculate Id or gm*/
IDN_ id_n0 (.V_GS(Vov0),.V_DS(V_DS_0),.is_triode_mode(is_triode_mode_0),.mode(mode[0]),.Idn(Idn[0]));
IDN_ id_n1 (.V_GS(Vov1),.V_DS(V_DS_1),.is_triode_mode(is_triode_mode_1),.mode(mode[0]),.Idn(Idn[1]));
IDN_ id_n2 (.V_GS(Vov2),.V_DS(V_DS_2),.is_triode_mode(is_triode_mode_2),.mode(mode[0]),.Idn(Idn[2]));
IDN_ id_n3 (.V_GS(Vov3),.V_DS(V_DS_3),.is_triode_mode(is_triode_mode_3),.mode(mode[0]),.Idn(Idn[3]));
IDN_ id_n4 (.V_GS(Vov4),.V_DS(V_DS_4),.is_triode_mode(is_triode_mode_4),.mode(mode[0]),.Idn(Idn[4]));
IDN_ id_n5 (.V_GS(Vov5),.V_DS(V_DS_5),.is_triode_mode(is_triode_mode_5),.mode(mode[0]),.Idn(Idn[5]));
/*Sort*/
BlOCK bl0  (.in0(W_0*(Idn[0])),.in1(W_1*(Idn[1])),.out0(a0),.out1(a1));
BlOCK bl1  (.in0(W_2*(Idn[2])),.in1(W_3*(Idn[3])),.out0(a2),.out1(a3));
BlOCK bl2  (.in0(W_4*(Idn[4])),.in1(W_5*(Idn[5])),.out0(a4),.out1(a5));

BlOCK bl4  (.in0(a1),.in1(a2),.out0(b0),.out1(b1));
BlOCK bl5  (.in0(a3),.in1(a4),.out0(b2),.out1(b3));
BlOCK bl6  (.in0(a0),.in1(b0),.out0(c0),.out1(c1));
BlOCK bl7  (.in0(b1),.in1(b2),.out0(c2),.out1(c3));
BlOCK bl8  (.in0(b3),.in1(a5),.out0(c4),.out1(c5));
BlOCK bl9  (.in0(c1),.in1(c2),.out0(d0),.out1(d1));
BlOCK bl10 (.in0(c3),.in1(c4),.out0(d2),.out1(d3));
BlOCK bl11 (.in0(c0),.in1(d0),.out0(g0),.out1(g1));
BlOCK bl12 (.in0(d1),.in1(d2),.out0(g2),.out1(g3));
BlOCK bl13 (.in0(d3),.in1(c5),.out0(g4),.out1(g5));
BlOCK bl14 (.in0(g1),.in1(g2),.out0(f1),.out1(f2));
BlOCK bl15 (.in0(g3),.in1(g4),.out0(f3),.out1(f4));
assign f0=g0;
assign f5=g5;

/*Divider*/
Divider_3 div3_0 (.mac((mode==0|mode==1)?f2:f5),.pot(pot0));
Divider_3 div3_1 (.mac((mode==0|mode==1)?f1:f4),.pot(pot1));
Divider_3 div3_2 (.mac((mode==0|mode==1)?f0:f3),.pot(pot2));

/*Out*/
assign out_0= ((4*pot1+5*pot2+3*pot0)/4);
assign out_1= (pot0+pot1+pot2)/3;
assign out_n= (mode[0]==1) ?
              out_0/3: 
              out_1; 
endmodule

module IDN_ ( 
  //inputs 
  V_GS,
  V_DS,
  is_triode_mode,
  mode,
  //output 
  Idn 
  );
  input [2:0] V_GS,V_DS;
  input mode,is_triode_mode;
  output [7:0] Idn;
  assign Idn = (mode==0) ? ((is_triode_mode==1)?(V_DS):(V_GS))*2:((is_triode_mode==1)? (2*(V_GS)*V_DS-V_DS*V_DS):(V_GS)*(V_GS));
endmodule

module BlOCK (
  //inputs
  in0,
  in1,
  //outputs
  out0,
  out1
  );
  input [7:0] in0,in1;
  output[7:0] out0,out1;
  assign out0 = (in0 <= in1) ? in0 : in1;
  assign out1 = (in1 <= in0) ? in0 : in1;
endmodule

module Divider_3 (
  //inpu5
  mac,
  //output
  pot) ;
  input [7:0] mac;
  output reg [7:0] pot;
  always@(*) begin
    case(mac[7:0])
      0,1,2: pot=0;
      3,4,5: pot=1;
      6,7,8: pot=2;
      9,10,11: pot=3;
      12,13,14: pot=4;
      15,16,17: pot=5;
      18,19,20: pot=6;
      21,22,23: pot=7;
      24,25,26: pot=8;
      27,28,29: pot=9;
      30,31,32: pot=10;
      33,34,35: pot=11;
      36,37,38: pot=12;
      39,40,41: pot=13;
      42,43,44: pot=14;
      45,46,47: pot=15;
      48,49,50: pot=16; 
      51,52,53: pot=17;
      54,55,56: pot=18;
      57,58,59: pot=19;
      60,61,62: pot=20;
      63,64,65: pot=21;
      66,67,68: pot=22;
      69,70,71: pot=23;
      72,73,74: pot=24;
      75,76,77: pot=25;
      78,79,80: pot=26;
      81,82,83: pot=27;
      84,85,86: pot=28;
      87,88,89: pot=29;
      90,91,92: pot=30;
      93,94,95: pot=31;
      96,97,98: pot=32;
      99,100,101: pot=33;
      102,103,104: pot=34;
      105,106,107: pot=35;
      108,109,110: pot=36;
      111,112,113: pot=37;
      114,115,116: pot=38;
      117,118,119: pot=39;
      120,121,122: pot=40;
      123,124,125: pot=41;
      126,127,128: pot=42;
      129,130,131: pot=43;
      132,133,134: pot=44;
      135,136,137: pot=45;
      138,139,140: pot=46;
      141,142,143: pot=47;
      144,145,146: pot=48;
      147,148,149: pot=49;
      150,151,152: pot=50;
      153,154,155: pot=51;
      156,157,158: pot=52;
      159,160,161: pot=53;
      162,163,164: pot=54;
      165,166,167: pot=55;
      168,169,170: pot=56;
      171,172,173: pot=57;
      174,175,176: pot=58;
      177,178,179: pot=59;
      180,181,182: pot=60;
      183,184,185: pot=61;
      186,187,188: pot=62;
      189,190,191: pot=63;
      192,193,194: pot=64;
      195,196,197: pot=65;
      198,199,200: pot=66;
      201,202,203: pot=67;
      204,205,206: pot=68;
      207,208,209: pot=69;
      210,211,212: pot=70;
      213,214,215: pot=71;
      216,217,218: pot=72;
      219,220,221: pot=73;
      222,223,224: pot=74;
      225,226,227: pot=75;
      228,229,230: pot=76;
      231,232,233: pot=77;
      234,235,236: pot=78;
      237,238,239: pot=79;
      240,241,242: pot=80;
      243,244,245: pot=81;
      246,247,248: pot=82;
      249,250,251: pot=83;
      252,253,254: pot=84;
      255: pot=85;
    endcase
  end
endmodule


