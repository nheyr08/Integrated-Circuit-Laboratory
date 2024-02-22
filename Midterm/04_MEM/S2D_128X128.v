/*******************************************************************************

             Synchronous Dual Port SRAM Compiler 

                   UMC 0.18um Generic Logic Process 
   __________________________________________________________________________


       (C) Copyright 2002-2009 Faraday Technology Corp. All Rights Reserved.

     This source code is an unpublished work belongs to Faraday Technology
     Corp.  It is considered a trade secret and is not to be divulged or
     used by parties who have not received written authorization from
     Faraday Technology Corp.

     Faraday's home page can be found at:
     http://www.faraday-tech.com/
    
________________________________________________________________________________

      Module Name       :  S2D_128X128  
      Word              :  128          
      Bit               :  128          
      Byte              :  1            
      Mux               :  1            
      Power Ring Type   :  port         
      Power Ring Width  :  2 (um)       
      Output Loading    :  0.05 (pf)    
      Input Data Slew   :  0.02 (ns)    
      Input Clock Slew  :  0.02 (ns)    

________________________________________________________________________________

      Library          : FSA0M_A
      Memaker          : 200901.2.1
      Date             : 2023/11/11 18:13:30

________________________________________________________________________________


   Notice on usage: Fixed delay or timing data are given in this model.
                    It supports SDF back-annotation, please generate SDF file
                    by EDA tools to get the accurate timing.

 |-----------------------------------------------------------------------------|

   Warning : If customer's design viloate the set-up time or hold time criteria 
   of synchronous SRAM, it's possible to hit the meta-stable point of 
   latch circuit in the decoder and cause the data loss in the memory bitcell.
   So please follow the memory IP's spec to design your product.

 |-----------------------------------------------------------------------------|

                Library          : FSA0M_A
                Memaker          : 200901.2.1
                Date             : 2023/11/11 18:13:30

 *******************************************************************************/

`resetall
`timescale 10ps/1ps


module S2D_128X128 (A0,A1,A2,A3,A4,A5,A6,B0,B1,B2,B3,B4,B5,B6,DOA0,DOA1,
                    DOA2,DOA3,DOA4,DOA5,DOA6,DOA7,DOA8,DOA9,
                    DOA10,DOA11,DOA12,DOA13,DOA14,DOA15,DOA16,
                    DOA17,DOA18,DOA19,DOA20,DOA21,DOA22,DOA23,
                    DOA24,DOA25,DOA26,DOA27,DOA28,DOA29,DOA30,
                    DOA31,DOA32,DOA33,DOA34,DOA35,DOA36,DOA37,
                    DOA38,DOA39,DOA40,DOA41,DOA42,DOA43,DOA44,
                    DOA45,DOA46,DOA47,DOA48,DOA49,DOA50,DOA51,
                    DOA52,DOA53,DOA54,DOA55,DOA56,DOA57,DOA58,
                    DOA59,DOA60,DOA61,DOA62,DOA63,DOA64,DOA65,
                    DOA66,DOA67,DOA68,DOA69,DOA70,DOA71,DOA72,
                    DOA73,DOA74,DOA75,DOA76,DOA77,DOA78,DOA79,
                    DOA80,DOA81,DOA82,DOA83,DOA84,DOA85,DOA86,
                    DOA87,DOA88,DOA89,DOA90,DOA91,DOA92,DOA93,
                    DOA94,DOA95,DOA96,DOA97,DOA98,DOA99,DOA100,
                    DOA101,DOA102,DOA103,DOA104,DOA105,DOA106,
                    DOA107,DOA108,DOA109,DOA110,DOA111,DOA112,
                    DOA113,DOA114,DOA115,DOA116,DOA117,DOA118,
                    DOA119,DOA120,DOA121,DOA122,DOA123,DOA124,
                    DOA125,DOA126,DOA127,DOB0,DOB1,DOB2,
                    DOB3,DOB4,DOB5,DOB6,DOB7,DOB8,DOB9,DOB10,
                    DOB11,DOB12,DOB13,DOB14,DOB15,DOB16,DOB17,
                    DOB18,DOB19,DOB20,DOB21,DOB22,DOB23,DOB24,
                    DOB25,DOB26,DOB27,DOB28,DOB29,DOB30,DOB31,
                    DOB32,DOB33,DOB34,DOB35,DOB36,DOB37,DOB38,
                    DOB39,DOB40,DOB41,DOB42,DOB43,DOB44,DOB45,
                    DOB46,DOB47,DOB48,DOB49,DOB50,DOB51,DOB52,
                    DOB53,DOB54,DOB55,DOB56,DOB57,DOB58,DOB59,
                    DOB60,DOB61,DOB62,DOB63,DOB64,DOB65,DOB66,
                    DOB67,DOB68,DOB69,DOB70,DOB71,DOB72,DOB73,
                    DOB74,DOB75,DOB76,DOB77,DOB78,DOB79,DOB80,
                    DOB81,DOB82,DOB83,DOB84,DOB85,DOB86,DOB87,
                    DOB88,DOB89,DOB90,DOB91,DOB92,DOB93,DOB94,
                    DOB95,DOB96,DOB97,DOB98,DOB99,DOB100,DOB101,
                    DOB102,DOB103,DOB104,DOB105,DOB106,DOB107,
                    DOB108,DOB109,DOB110,DOB111,DOB112,DOB113,
                    DOB114,DOB115,DOB116,DOB117,DOB118,DOB119,
                    DOB120,DOB121,DOB122,DOB123,DOB124,DOB125,
                    DOB126,DOB127,DIA0,DIA1,DIA2,DIA3,DIA4,
                    DIA5,DIA6,DIA7,DIA8,DIA9,DIA10,DIA11,DIA12,
                    DIA13,DIA14,DIA15,DIA16,DIA17,DIA18,DIA19,
                    DIA20,DIA21,DIA22,DIA23,DIA24,DIA25,DIA26,
                    DIA27,DIA28,DIA29,DIA30,DIA31,DIA32,DIA33,
                    DIA34,DIA35,DIA36,DIA37,DIA38,DIA39,DIA40,
                    DIA41,DIA42,DIA43,DIA44,DIA45,DIA46,DIA47,
                    DIA48,DIA49,DIA50,DIA51,DIA52,DIA53,DIA54,
                    DIA55,DIA56,DIA57,DIA58,DIA59,DIA60,DIA61,
                    DIA62,DIA63,DIA64,DIA65,DIA66,DIA67,DIA68,
                    DIA69,DIA70,DIA71,DIA72,DIA73,DIA74,DIA75,
                    DIA76,DIA77,DIA78,DIA79,DIA80,DIA81,DIA82,
                    DIA83,DIA84,DIA85,DIA86,DIA87,DIA88,DIA89,
                    DIA90,DIA91,DIA92,DIA93,DIA94,DIA95,DIA96,
                    DIA97,DIA98,DIA99,DIA100,DIA101,DIA102,
                    DIA103,DIA104,DIA105,DIA106,DIA107,DIA108,
                    DIA109,DIA110,DIA111,DIA112,DIA113,DIA114,
                    DIA115,DIA116,DIA117,DIA118,DIA119,DIA120,
                    DIA121,DIA122,DIA123,DIA124,DIA125,DIA126,
                    DIA127,DIB0,DIB1,DIB2,DIB3,DIB4,DIB5,
                    DIB6,DIB7,DIB8,DIB9,DIB10,DIB11,DIB12,DIB13,
                    DIB14,DIB15,DIB16,DIB17,DIB18,DIB19,DIB20,
                    DIB21,DIB22,DIB23,DIB24,DIB25,DIB26,DIB27,
                    DIB28,DIB29,DIB30,DIB31,DIB32,DIB33,DIB34,
                    DIB35,DIB36,DIB37,DIB38,DIB39,DIB40,DIB41,
                    DIB42,DIB43,DIB44,DIB45,DIB46,DIB47,DIB48,
                    DIB49,DIB50,DIB51,DIB52,DIB53,DIB54,DIB55,
                    DIB56,DIB57,DIB58,DIB59,DIB60,DIB61,DIB62,
                    DIB63,DIB64,DIB65,DIB66,DIB67,DIB68,DIB69,
                    DIB70,DIB71,DIB72,DIB73,DIB74,DIB75,DIB76,
                    DIB77,DIB78,DIB79,DIB80,DIB81,DIB82,DIB83,
                    DIB84,DIB85,DIB86,DIB87,DIB88,DIB89,DIB90,
                    DIB91,DIB92,DIB93,DIB94,DIB95,DIB96,DIB97,
                    DIB98,DIB99,DIB100,DIB101,DIB102,DIB103,
                    DIB104,DIB105,DIB106,DIB107,DIB108,DIB109,
                    DIB110,DIB111,DIB112,DIB113,DIB114,DIB115,
                    DIB116,DIB117,DIB118,DIB119,DIB120,DIB121,
                    DIB122,DIB123,DIB124,DIB125,DIB126,DIB127,
                    WEAN,WEBN,CKA,CKB,CSA,CSB,OEA,OEB);

  `define    TRUE                 (1'b1)              
  `define    FALSE                (1'b0)              

  parameter  SYN_CS               = `TRUE;            
  parameter  NO_SER_TOH           = `TRUE;            
  parameter  AddressSize          = 7;                
  parameter  Bits                 = 128;              
  parameter  Words                = 128;              
  parameter  Bytes                = 1;                
  parameter  AspectRatio          = 1;                
  parameter  Tr2w                 = (172:251:410);    
  parameter  Tw2r                 = (138:195:315);    
  parameter  TOH                  = (57:84:137);      

  output     DOA0,DOA1,DOA2,DOA3,DOA4,DOA5,DOA6,DOA7,DOA8,
             DOA9,DOA10,DOA11,DOA12,DOA13,DOA14,DOA15,DOA16,DOA17,DOA18,
             DOA19,DOA20,DOA21,DOA22,DOA23,DOA24,DOA25,DOA26,DOA27,DOA28,
             DOA29,DOA30,DOA31,DOA32,DOA33,DOA34,DOA35,DOA36,DOA37,DOA38,
             DOA39,DOA40,DOA41,DOA42,DOA43,DOA44,DOA45,DOA46,DOA47,DOA48,
             DOA49,DOA50,DOA51,DOA52,DOA53,DOA54,DOA55,DOA56,DOA57,DOA58,
             DOA59,DOA60,DOA61,DOA62,DOA63,DOA64,DOA65,DOA66,DOA67,DOA68,
             DOA69,DOA70,DOA71,DOA72,DOA73,DOA74,DOA75,DOA76,DOA77,DOA78,
             DOA79,DOA80,DOA81,DOA82,DOA83,DOA84,DOA85,DOA86,DOA87,DOA88,
             DOA89,DOA90,DOA91,DOA92,DOA93,DOA94,DOA95,DOA96,DOA97,DOA98,
             DOA99,DOA100,DOA101,DOA102,DOA103,DOA104,DOA105,DOA106,DOA107,DOA108,
             DOA109,DOA110,DOA111,DOA112,DOA113,DOA114,DOA115,DOA116,DOA117,DOA118,
             DOA119,DOA120,DOA121,DOA122,DOA123,DOA124,DOA125,DOA126,DOA127;
  output     DOB0,DOB1,DOB2,DOB3,DOB4,DOB5,DOB6,DOB7,DOB8,
             DOB9,DOB10,DOB11,DOB12,DOB13,DOB14,DOB15,DOB16,DOB17,DOB18,
             DOB19,DOB20,DOB21,DOB22,DOB23,DOB24,DOB25,DOB26,DOB27,DOB28,
             DOB29,DOB30,DOB31,DOB32,DOB33,DOB34,DOB35,DOB36,DOB37,DOB38,
             DOB39,DOB40,DOB41,DOB42,DOB43,DOB44,DOB45,DOB46,DOB47,DOB48,
             DOB49,DOB50,DOB51,DOB52,DOB53,DOB54,DOB55,DOB56,DOB57,DOB58,
             DOB59,DOB60,DOB61,DOB62,DOB63,DOB64,DOB65,DOB66,DOB67,DOB68,
             DOB69,DOB70,DOB71,DOB72,DOB73,DOB74,DOB75,DOB76,DOB77,DOB78,
             DOB79,DOB80,DOB81,DOB82,DOB83,DOB84,DOB85,DOB86,DOB87,DOB88,
             DOB89,DOB90,DOB91,DOB92,DOB93,DOB94,DOB95,DOB96,DOB97,DOB98,
             DOB99,DOB100,DOB101,DOB102,DOB103,DOB104,DOB105,DOB106,DOB107,DOB108,
             DOB109,DOB110,DOB111,DOB112,DOB113,DOB114,DOB115,DOB116,DOB117,DOB118,
             DOB119,DOB120,DOB121,DOB122,DOB123,DOB124,DOB125,DOB126,DOB127;
  input      DIA0,DIA1,DIA2,DIA3,DIA4,DIA5,DIA6,DIA7,DIA8,
             DIA9,DIA10,DIA11,DIA12,DIA13,DIA14,DIA15,DIA16,DIA17,DIA18,
             DIA19,DIA20,DIA21,DIA22,DIA23,DIA24,DIA25,DIA26,DIA27,DIA28,
             DIA29,DIA30,DIA31,DIA32,DIA33,DIA34,DIA35,DIA36,DIA37,DIA38,
             DIA39,DIA40,DIA41,DIA42,DIA43,DIA44,DIA45,DIA46,DIA47,DIA48,
             DIA49,DIA50,DIA51,DIA52,DIA53,DIA54,DIA55,DIA56,DIA57,DIA58,
             DIA59,DIA60,DIA61,DIA62,DIA63,DIA64,DIA65,DIA66,DIA67,DIA68,
             DIA69,DIA70,DIA71,DIA72,DIA73,DIA74,DIA75,DIA76,DIA77,DIA78,
             DIA79,DIA80,DIA81,DIA82,DIA83,DIA84,DIA85,DIA86,DIA87,DIA88,
             DIA89,DIA90,DIA91,DIA92,DIA93,DIA94,DIA95,DIA96,DIA97,DIA98,
             DIA99,DIA100,DIA101,DIA102,DIA103,DIA104,DIA105,DIA106,DIA107,DIA108,
             DIA109,DIA110,DIA111,DIA112,DIA113,DIA114,DIA115,DIA116,DIA117,DIA118,
             DIA119,DIA120,DIA121,DIA122,DIA123,DIA124,DIA125,DIA126,DIA127;
  input      DIB0,DIB1,DIB2,DIB3,DIB4,DIB5,DIB6,DIB7,DIB8,
             DIB9,DIB10,DIB11,DIB12,DIB13,DIB14,DIB15,DIB16,DIB17,DIB18,
             DIB19,DIB20,DIB21,DIB22,DIB23,DIB24,DIB25,DIB26,DIB27,DIB28,
             DIB29,DIB30,DIB31,DIB32,DIB33,DIB34,DIB35,DIB36,DIB37,DIB38,
             DIB39,DIB40,DIB41,DIB42,DIB43,DIB44,DIB45,DIB46,DIB47,DIB48,
             DIB49,DIB50,DIB51,DIB52,DIB53,DIB54,DIB55,DIB56,DIB57,DIB58,
             DIB59,DIB60,DIB61,DIB62,DIB63,DIB64,DIB65,DIB66,DIB67,DIB68,
             DIB69,DIB70,DIB71,DIB72,DIB73,DIB74,DIB75,DIB76,DIB77,DIB78,
             DIB79,DIB80,DIB81,DIB82,DIB83,DIB84,DIB85,DIB86,DIB87,DIB88,
             DIB89,DIB90,DIB91,DIB92,DIB93,DIB94,DIB95,DIB96,DIB97,DIB98,
             DIB99,DIB100,DIB101,DIB102,DIB103,DIB104,DIB105,DIB106,DIB107,DIB108,
             DIB109,DIB110,DIB111,DIB112,DIB113,DIB114,DIB115,DIB116,DIB117,DIB118,
             DIB119,DIB120,DIB121,DIB122,DIB123,DIB124,DIB125,DIB126,DIB127;
  input      A0,A1,A2,A3,A4,A5,A6;
  input      B0,B1,B2,B3,B4,B5,B6;
  input      OEA;                                     
  input      OEB;                                     
  input      WEAN;                                    
  input      WEBN;                                    
  input      CKA;                                     
  input      CKB;                                     
  input      CSA;                                     
  input      CSB;                                     

`protect
  reg        [Bits-1:0]           Memory [Words-1:0];           

  wire       [Bytes*Bits-1:0]     DOA_;               
  wire       [Bytes*Bits-1:0]     DOB_;               
  wire       [AddressSize-1:0]    A_;                 
  wire       [AddressSize-1:0]    B_;                 
  wire                            OEA_;               
  wire                            OEB_;               
  wire       [Bits-1:0]           DIA_;               
  wire       [Bits-1:0]           DIB_;               
  wire                            WEBN_;              
  wire                            WEAN_;              
  wire                            CKA_;               
  wire                            CKB_;               
  wire                            CSA_;               
  wire                            CSB_;               

  wire                            con_A;              
  wire                            con_B;              
  wire                            con_DIA;            
  wire                            con_DIB;            
  wire                            con_CKA;            
  wire                            con_CKB;            
  wire                            con_WEBN;           
  wire                            con_WEAN;           

  reg        [AddressSize-1:0]    Latch_A;            
  reg        [AddressSize-1:0]    Latch_B;            
  reg        [Bits-1:0]           Latch_DIA;          
  reg        [Bits-1:0]           Latch_DIB;          
  reg                             Latch_WEAN;         
  reg                             Latch_WEBN;         
  reg                             Latch_CSA;          
  reg                             Latch_CSB;          
  reg        [AddressSize-1:0]    LastCycleAAddress;  
  reg        [AddressSize-1:0]    LastCycleBAddress;  

  reg        [AddressSize-1:0]    A_i;                
  reg        [AddressSize-1:0]    B_i;                
  reg        [Bits-1:0]           DIA_i;              
  reg        [Bits-1:0]           DIB_i;              
  reg                             WEAN_i;             
  reg                             WEBN_i;             
  reg                             CSA_i;              
  reg                             CSB_i;              

  reg                             n_flag_A0;          
  reg                             n_flag_A1;          
  reg                             n_flag_A2;          
  reg                             n_flag_A3;          
  reg                             n_flag_A4;          
  reg                             n_flag_A5;          
  reg                             n_flag_A6;          
  reg                             n_flag_B0;          
  reg                             n_flag_B1;          
  reg                             n_flag_B2;          
  reg                             n_flag_B3;          
  reg                             n_flag_B4;          
  reg                             n_flag_B5;          
  reg                             n_flag_B6;          
  reg                             n_flag_DIA0;        
  reg                             n_flag_DIB0;        
  reg                             n_flag_DIA1;        
  reg                             n_flag_DIB1;        
  reg                             n_flag_DIA2;        
  reg                             n_flag_DIB2;        
  reg                             n_flag_DIA3;        
  reg                             n_flag_DIB3;        
  reg                             n_flag_DIA4;        
  reg                             n_flag_DIB4;        
  reg                             n_flag_DIA5;        
  reg                             n_flag_DIB5;        
  reg                             n_flag_DIA6;        
  reg                             n_flag_DIB6;        
  reg                             n_flag_DIA7;        
  reg                             n_flag_DIB7;        
  reg                             n_flag_DIA8;        
  reg                             n_flag_DIB8;        
  reg                             n_flag_DIA9;        
  reg                             n_flag_DIB9;        
  reg                             n_flag_DIA10;       
  reg                             n_flag_DIB10;       
  reg                             n_flag_DIA11;       
  reg                             n_flag_DIB11;       
  reg                             n_flag_DIA12;       
  reg                             n_flag_DIB12;       
  reg                             n_flag_DIA13;       
  reg                             n_flag_DIB13;       
  reg                             n_flag_DIA14;       
  reg                             n_flag_DIB14;       
  reg                             n_flag_DIA15;       
  reg                             n_flag_DIB15;       
  reg                             n_flag_DIA16;       
  reg                             n_flag_DIB16;       
  reg                             n_flag_DIA17;       
  reg                             n_flag_DIB17;       
  reg                             n_flag_DIA18;       
  reg                             n_flag_DIB18;       
  reg                             n_flag_DIA19;       
  reg                             n_flag_DIB19;       
  reg                             n_flag_DIA20;       
  reg                             n_flag_DIB20;       
  reg                             n_flag_DIA21;       
  reg                             n_flag_DIB21;       
  reg                             n_flag_DIA22;       
  reg                             n_flag_DIB22;       
  reg                             n_flag_DIA23;       
  reg                             n_flag_DIB23;       
  reg                             n_flag_DIA24;       
  reg                             n_flag_DIB24;       
  reg                             n_flag_DIA25;       
  reg                             n_flag_DIB25;       
  reg                             n_flag_DIA26;       
  reg                             n_flag_DIB26;       
  reg                             n_flag_DIA27;       
  reg                             n_flag_DIB27;       
  reg                             n_flag_DIA28;       
  reg                             n_flag_DIB28;       
  reg                             n_flag_DIA29;       
  reg                             n_flag_DIB29;       
  reg                             n_flag_DIA30;       
  reg                             n_flag_DIB30;       
  reg                             n_flag_DIA31;       
  reg                             n_flag_DIB31;       
  reg                             n_flag_DIA32;       
  reg                             n_flag_DIB32;       
  reg                             n_flag_DIA33;       
  reg                             n_flag_DIB33;       
  reg                             n_flag_DIA34;       
  reg                             n_flag_DIB34;       
  reg                             n_flag_DIA35;       
  reg                             n_flag_DIB35;       
  reg                             n_flag_DIA36;       
  reg                             n_flag_DIB36;       
  reg                             n_flag_DIA37;       
  reg                             n_flag_DIB37;       
  reg                             n_flag_DIA38;       
  reg                             n_flag_DIB38;       
  reg                             n_flag_DIA39;       
  reg                             n_flag_DIB39;       
  reg                             n_flag_DIA40;       
  reg                             n_flag_DIB40;       
  reg                             n_flag_DIA41;       
  reg                             n_flag_DIB41;       
  reg                             n_flag_DIA42;       
  reg                             n_flag_DIB42;       
  reg                             n_flag_DIA43;       
  reg                             n_flag_DIB43;       
  reg                             n_flag_DIA44;       
  reg                             n_flag_DIB44;       
  reg                             n_flag_DIA45;       
  reg                             n_flag_DIB45;       
  reg                             n_flag_DIA46;       
  reg                             n_flag_DIB46;       
  reg                             n_flag_DIA47;       
  reg                             n_flag_DIB47;       
  reg                             n_flag_DIA48;       
  reg                             n_flag_DIB48;       
  reg                             n_flag_DIA49;       
  reg                             n_flag_DIB49;       
  reg                             n_flag_DIA50;       
  reg                             n_flag_DIB50;       
  reg                             n_flag_DIA51;       
  reg                             n_flag_DIB51;       
  reg                             n_flag_DIA52;       
  reg                             n_flag_DIB52;       
  reg                             n_flag_DIA53;       
  reg                             n_flag_DIB53;       
  reg                             n_flag_DIA54;       
  reg                             n_flag_DIB54;       
  reg                             n_flag_DIA55;       
  reg                             n_flag_DIB55;       
  reg                             n_flag_DIA56;       
  reg                             n_flag_DIB56;       
  reg                             n_flag_DIA57;       
  reg                             n_flag_DIB57;       
  reg                             n_flag_DIA58;       
  reg                             n_flag_DIB58;       
  reg                             n_flag_DIA59;       
  reg                             n_flag_DIB59;       
  reg                             n_flag_DIA60;       
  reg                             n_flag_DIB60;       
  reg                             n_flag_DIA61;       
  reg                             n_flag_DIB61;       
  reg                             n_flag_DIA62;       
  reg                             n_flag_DIB62;       
  reg                             n_flag_DIA63;       
  reg                             n_flag_DIB63;       
  reg                             n_flag_DIA64;       
  reg                             n_flag_DIB64;       
  reg                             n_flag_DIA65;       
  reg                             n_flag_DIB65;       
  reg                             n_flag_DIA66;       
  reg                             n_flag_DIB66;       
  reg                             n_flag_DIA67;       
  reg                             n_flag_DIB67;       
  reg                             n_flag_DIA68;       
  reg                             n_flag_DIB68;       
  reg                             n_flag_DIA69;       
  reg                             n_flag_DIB69;       
  reg                             n_flag_DIA70;       
  reg                             n_flag_DIB70;       
  reg                             n_flag_DIA71;       
  reg                             n_flag_DIB71;       
  reg                             n_flag_DIA72;       
  reg                             n_flag_DIB72;       
  reg                             n_flag_DIA73;       
  reg                             n_flag_DIB73;       
  reg                             n_flag_DIA74;       
  reg                             n_flag_DIB74;       
  reg                             n_flag_DIA75;       
  reg                             n_flag_DIB75;       
  reg                             n_flag_DIA76;       
  reg                             n_flag_DIB76;       
  reg                             n_flag_DIA77;       
  reg                             n_flag_DIB77;       
  reg                             n_flag_DIA78;       
  reg                             n_flag_DIB78;       
  reg                             n_flag_DIA79;       
  reg                             n_flag_DIB79;       
  reg                             n_flag_DIA80;       
  reg                             n_flag_DIB80;       
  reg                             n_flag_DIA81;       
  reg                             n_flag_DIB81;       
  reg                             n_flag_DIA82;       
  reg                             n_flag_DIB82;       
  reg                             n_flag_DIA83;       
  reg                             n_flag_DIB83;       
  reg                             n_flag_DIA84;       
  reg                             n_flag_DIB84;       
  reg                             n_flag_DIA85;       
  reg                             n_flag_DIB85;       
  reg                             n_flag_DIA86;       
  reg                             n_flag_DIB86;       
  reg                             n_flag_DIA87;       
  reg                             n_flag_DIB87;       
  reg                             n_flag_DIA88;       
  reg                             n_flag_DIB88;       
  reg                             n_flag_DIA89;       
  reg                             n_flag_DIB89;       
  reg                             n_flag_DIA90;       
  reg                             n_flag_DIB90;       
  reg                             n_flag_DIA91;       
  reg                             n_flag_DIB91;       
  reg                             n_flag_DIA92;       
  reg                             n_flag_DIB92;       
  reg                             n_flag_DIA93;       
  reg                             n_flag_DIB93;       
  reg                             n_flag_DIA94;       
  reg                             n_flag_DIB94;       
  reg                             n_flag_DIA95;       
  reg                             n_flag_DIB95;       
  reg                             n_flag_DIA96;       
  reg                             n_flag_DIB96;       
  reg                             n_flag_DIA97;       
  reg                             n_flag_DIB97;       
  reg                             n_flag_DIA98;       
  reg                             n_flag_DIB98;       
  reg                             n_flag_DIA99;       
  reg                             n_flag_DIB99;       
  reg                             n_flag_DIA100;      
  reg                             n_flag_DIB100;      
  reg                             n_flag_DIA101;      
  reg                             n_flag_DIB101;      
  reg                             n_flag_DIA102;      
  reg                             n_flag_DIB102;      
  reg                             n_flag_DIA103;      
  reg                             n_flag_DIB103;      
  reg                             n_flag_DIA104;      
  reg                             n_flag_DIB104;      
  reg                             n_flag_DIA105;      
  reg                             n_flag_DIB105;      
  reg                             n_flag_DIA106;      
  reg                             n_flag_DIB106;      
  reg                             n_flag_DIA107;      
  reg                             n_flag_DIB107;      
  reg                             n_flag_DIA108;      
  reg                             n_flag_DIB108;      
  reg                             n_flag_DIA109;      
  reg                             n_flag_DIB109;      
  reg                             n_flag_DIA110;      
  reg                             n_flag_DIB110;      
  reg                             n_flag_DIA111;      
  reg                             n_flag_DIB111;      
  reg                             n_flag_DIA112;      
  reg                             n_flag_DIB112;      
  reg                             n_flag_DIA113;      
  reg                             n_flag_DIB113;      
  reg                             n_flag_DIA114;      
  reg                             n_flag_DIB114;      
  reg                             n_flag_DIA115;      
  reg                             n_flag_DIB115;      
  reg                             n_flag_DIA116;      
  reg                             n_flag_DIB116;      
  reg                             n_flag_DIA117;      
  reg                             n_flag_DIB117;      
  reg                             n_flag_DIA118;      
  reg                             n_flag_DIB118;      
  reg                             n_flag_DIA119;      
  reg                             n_flag_DIB119;      
  reg                             n_flag_DIA120;      
  reg                             n_flag_DIB120;      
  reg                             n_flag_DIA121;      
  reg                             n_flag_DIB121;      
  reg                             n_flag_DIA122;      
  reg                             n_flag_DIB122;      
  reg                             n_flag_DIA123;      
  reg                             n_flag_DIB123;      
  reg                             n_flag_DIA124;      
  reg                             n_flag_DIB124;      
  reg                             n_flag_DIA125;      
  reg                             n_flag_DIB125;      
  reg                             n_flag_DIA126;      
  reg                             n_flag_DIB126;      
  reg                             n_flag_DIA127;      
  reg                             n_flag_DIB127;      
  reg                             n_flag_WEAN;        
  reg                             n_flag_WEBN;        
  reg                             n_flag_CSA;         
  reg                             n_flag_CSB;         
  reg                             n_flag_CKA_PER;     
  reg                             n_flag_CKA_MINH;    
  reg                             n_flag_CKA_MINL;    
  reg                             n_flag_CKB_PER;     
  reg                             n_flag_CKB_MINH;    
  reg                             n_flag_CKB_MINL;    
  reg                             LAST_n_flag_WEAN;   
  reg                             LAST_n_flag_WEBN;   
  reg                             LAST_n_flag_CSA;    
  reg                             LAST_n_flag_CSB;    
  reg                             LAST_n_flag_CKA_PER;
  reg                             LAST_n_flag_CKA_MINH;
  reg                             LAST_n_flag_CKA_MINL;
  reg                             LAST_n_flag_CKB_PER;
  reg                             LAST_n_flag_CKB_MINH;
  reg                             LAST_n_flag_CKB_MINL;
  reg        [AddressSize-1:0]    NOT_BUS_B;          
  reg        [AddressSize-1:0]    LAST_NOT_BUS_B;     
  reg        [AddressSize-1:0]    NOT_BUS_A;          
  reg        [AddressSize-1:0]    LAST_NOT_BUS_A;     
  reg        [Bits-1:0]           NOT_BUS_DIA;        
  reg        [Bits-1:0]           NOT_BUS_DIB;        
  reg        [Bits-1:0]           LAST_NOT_BUS_DIA;   
  reg        [Bits-1:0]           LAST_NOT_BUS_DIB;   

  reg        [AddressSize-1:0]    last_A;             
  reg        [AddressSize-1:0]    latch_last_A;       
  reg        [AddressSize-1:0]    last_B;             
  reg        [AddressSize-1:0]    latch_last_B;       

  reg        [Bits-1:0]           last_DIA;           
  reg        [Bits-1:0]           latch_last_DIA;     
  reg        [Bits-1:0]           last_DIB;           
  reg        [Bits-1:0]           latch_last_DIB;     

  reg        [Bits-1:0]           DOA_i;              
  reg        [Bits-1:0]           DOB_i;              

  reg                             LastClkAEdge;       
  reg                             LastClkBEdge;       

  reg                             Last_WEAN_i;        
  reg                             Last_WEBN_i;        

  reg                             flag_A_x;           
  reg                             flag_B_x;           
  reg                             flag_CSA_x;         
  reg                             flag_CSB_x;         
  reg                             NODELAYA;           
  reg                             NODELAYB;           
  reg        [Bits-1:0]           DOA_tmp;            
  reg        [Bits-1:0]           DOB_tmp;            
  event                           EventTOHDOA;        
  event                           EventTOHDOB;        

  time                            Last_tc_ClkA_PosEdge;
  time                            Last_tc_ClkB_PosEdge;

  assign     DOA_                 = {DOA_i};
  assign     DOB_                 = {DOB_i};
  assign     con_A                = CSA_;
  assign     con_B                = CSB_;
  assign     con_DIA              = CSA_ & (!WEAN_);
  assign     con_DIB              = CSB_ & (!WEBN_);
  assign     con_WEAN             = CSA_;
  assign     con_WEBN             = CSB_;
  assign     con_CKA              = CSA_;
  assign     con_CKB              = CSB_;

  bufif1     idoa0           (DOA0, DOA_[0], OEA_);        
  bufif1     idob0           (DOB0, DOB_[0], OEB_);        
  bufif1     idoa1           (DOA1, DOA_[1], OEA_);        
  bufif1     idob1           (DOB1, DOB_[1], OEB_);        
  bufif1     idoa2           (DOA2, DOA_[2], OEA_);        
  bufif1     idob2           (DOB2, DOB_[2], OEB_);        
  bufif1     idoa3           (DOA3, DOA_[3], OEA_);        
  bufif1     idob3           (DOB3, DOB_[3], OEB_);        
  bufif1     idoa4           (DOA4, DOA_[4], OEA_);        
  bufif1     idob4           (DOB4, DOB_[4], OEB_);        
  bufif1     idoa5           (DOA5, DOA_[5], OEA_);        
  bufif1     idob5           (DOB5, DOB_[5], OEB_);        
  bufif1     idoa6           (DOA6, DOA_[6], OEA_);        
  bufif1     idob6           (DOB6, DOB_[6], OEB_);        
  bufif1     idoa7           (DOA7, DOA_[7], OEA_);        
  bufif1     idob7           (DOB7, DOB_[7], OEB_);        
  bufif1     idoa8           (DOA8, DOA_[8], OEA_);        
  bufif1     idob8           (DOB8, DOB_[8], OEB_);        
  bufif1     idoa9           (DOA9, DOA_[9], OEA_);        
  bufif1     idob9           (DOB9, DOB_[9], OEB_);        
  bufif1     idoa10          (DOA10, DOA_[10], OEA_);      
  bufif1     idob10          (DOB10, DOB_[10], OEB_);      
  bufif1     idoa11          (DOA11, DOA_[11], OEA_);      
  bufif1     idob11          (DOB11, DOB_[11], OEB_);      
  bufif1     idoa12          (DOA12, DOA_[12], OEA_);      
  bufif1     idob12          (DOB12, DOB_[12], OEB_);      
  bufif1     idoa13          (DOA13, DOA_[13], OEA_);      
  bufif1     idob13          (DOB13, DOB_[13], OEB_);      
  bufif1     idoa14          (DOA14, DOA_[14], OEA_);      
  bufif1     idob14          (DOB14, DOB_[14], OEB_);      
  bufif1     idoa15          (DOA15, DOA_[15], OEA_);      
  bufif1     idob15          (DOB15, DOB_[15], OEB_);      
  bufif1     idoa16          (DOA16, DOA_[16], OEA_);      
  bufif1     idob16          (DOB16, DOB_[16], OEB_);      
  bufif1     idoa17          (DOA17, DOA_[17], OEA_);      
  bufif1     idob17          (DOB17, DOB_[17], OEB_);      
  bufif1     idoa18          (DOA18, DOA_[18], OEA_);      
  bufif1     idob18          (DOB18, DOB_[18], OEB_);      
  bufif1     idoa19          (DOA19, DOA_[19], OEA_);      
  bufif1     idob19          (DOB19, DOB_[19], OEB_);      
  bufif1     idoa20          (DOA20, DOA_[20], OEA_);      
  bufif1     idob20          (DOB20, DOB_[20], OEB_);      
  bufif1     idoa21          (DOA21, DOA_[21], OEA_);      
  bufif1     idob21          (DOB21, DOB_[21], OEB_);      
  bufif1     idoa22          (DOA22, DOA_[22], OEA_);      
  bufif1     idob22          (DOB22, DOB_[22], OEB_);      
  bufif1     idoa23          (DOA23, DOA_[23], OEA_);      
  bufif1     idob23          (DOB23, DOB_[23], OEB_);      
  bufif1     idoa24          (DOA24, DOA_[24], OEA_);      
  bufif1     idob24          (DOB24, DOB_[24], OEB_);      
  bufif1     idoa25          (DOA25, DOA_[25], OEA_);      
  bufif1     idob25          (DOB25, DOB_[25], OEB_);      
  bufif1     idoa26          (DOA26, DOA_[26], OEA_);      
  bufif1     idob26          (DOB26, DOB_[26], OEB_);      
  bufif1     idoa27          (DOA27, DOA_[27], OEA_);      
  bufif1     idob27          (DOB27, DOB_[27], OEB_);      
  bufif1     idoa28          (DOA28, DOA_[28], OEA_);      
  bufif1     idob28          (DOB28, DOB_[28], OEB_);      
  bufif1     idoa29          (DOA29, DOA_[29], OEA_);      
  bufif1     idob29          (DOB29, DOB_[29], OEB_);      
  bufif1     idoa30          (DOA30, DOA_[30], OEA_);      
  bufif1     idob30          (DOB30, DOB_[30], OEB_);      
  bufif1     idoa31          (DOA31, DOA_[31], OEA_);      
  bufif1     idob31          (DOB31, DOB_[31], OEB_);      
  bufif1     idoa32          (DOA32, DOA_[32], OEA_);      
  bufif1     idob32          (DOB32, DOB_[32], OEB_);      
  bufif1     idoa33          (DOA33, DOA_[33], OEA_);      
  bufif1     idob33          (DOB33, DOB_[33], OEB_);      
  bufif1     idoa34          (DOA34, DOA_[34], OEA_);      
  bufif1     idob34          (DOB34, DOB_[34], OEB_);      
  bufif1     idoa35          (DOA35, DOA_[35], OEA_);      
  bufif1     idob35          (DOB35, DOB_[35], OEB_);      
  bufif1     idoa36          (DOA36, DOA_[36], OEA_);      
  bufif1     idob36          (DOB36, DOB_[36], OEB_);      
  bufif1     idoa37          (DOA37, DOA_[37], OEA_);      
  bufif1     idob37          (DOB37, DOB_[37], OEB_);      
  bufif1     idoa38          (DOA38, DOA_[38], OEA_);      
  bufif1     idob38          (DOB38, DOB_[38], OEB_);      
  bufif1     idoa39          (DOA39, DOA_[39], OEA_);      
  bufif1     idob39          (DOB39, DOB_[39], OEB_);      
  bufif1     idoa40          (DOA40, DOA_[40], OEA_);      
  bufif1     idob40          (DOB40, DOB_[40], OEB_);      
  bufif1     idoa41          (DOA41, DOA_[41], OEA_);      
  bufif1     idob41          (DOB41, DOB_[41], OEB_);      
  bufif1     idoa42          (DOA42, DOA_[42], OEA_);      
  bufif1     idob42          (DOB42, DOB_[42], OEB_);      
  bufif1     idoa43          (DOA43, DOA_[43], OEA_);      
  bufif1     idob43          (DOB43, DOB_[43], OEB_);      
  bufif1     idoa44          (DOA44, DOA_[44], OEA_);      
  bufif1     idob44          (DOB44, DOB_[44], OEB_);      
  bufif1     idoa45          (DOA45, DOA_[45], OEA_);      
  bufif1     idob45          (DOB45, DOB_[45], OEB_);      
  bufif1     idoa46          (DOA46, DOA_[46], OEA_);      
  bufif1     idob46          (DOB46, DOB_[46], OEB_);      
  bufif1     idoa47          (DOA47, DOA_[47], OEA_);      
  bufif1     idob47          (DOB47, DOB_[47], OEB_);      
  bufif1     idoa48          (DOA48, DOA_[48], OEA_);      
  bufif1     idob48          (DOB48, DOB_[48], OEB_);      
  bufif1     idoa49          (DOA49, DOA_[49], OEA_);      
  bufif1     idob49          (DOB49, DOB_[49], OEB_);      
  bufif1     idoa50          (DOA50, DOA_[50], OEA_);      
  bufif1     idob50          (DOB50, DOB_[50], OEB_);      
  bufif1     idoa51          (DOA51, DOA_[51], OEA_);      
  bufif1     idob51          (DOB51, DOB_[51], OEB_);      
  bufif1     idoa52          (DOA52, DOA_[52], OEA_);      
  bufif1     idob52          (DOB52, DOB_[52], OEB_);      
  bufif1     idoa53          (DOA53, DOA_[53], OEA_);      
  bufif1     idob53          (DOB53, DOB_[53], OEB_);      
  bufif1     idoa54          (DOA54, DOA_[54], OEA_);      
  bufif1     idob54          (DOB54, DOB_[54], OEB_);      
  bufif1     idoa55          (DOA55, DOA_[55], OEA_);      
  bufif1     idob55          (DOB55, DOB_[55], OEB_);      
  bufif1     idoa56          (DOA56, DOA_[56], OEA_);      
  bufif1     idob56          (DOB56, DOB_[56], OEB_);      
  bufif1     idoa57          (DOA57, DOA_[57], OEA_);      
  bufif1     idob57          (DOB57, DOB_[57], OEB_);      
  bufif1     idoa58          (DOA58, DOA_[58], OEA_);      
  bufif1     idob58          (DOB58, DOB_[58], OEB_);      
  bufif1     idoa59          (DOA59, DOA_[59], OEA_);      
  bufif1     idob59          (DOB59, DOB_[59], OEB_);      
  bufif1     idoa60          (DOA60, DOA_[60], OEA_);      
  bufif1     idob60          (DOB60, DOB_[60], OEB_);      
  bufif1     idoa61          (DOA61, DOA_[61], OEA_);      
  bufif1     idob61          (DOB61, DOB_[61], OEB_);      
  bufif1     idoa62          (DOA62, DOA_[62], OEA_);      
  bufif1     idob62          (DOB62, DOB_[62], OEB_);      
  bufif1     idoa63          (DOA63, DOA_[63], OEA_);      
  bufif1     idob63          (DOB63, DOB_[63], OEB_);      
  bufif1     idoa64          (DOA64, DOA_[64], OEA_);      
  bufif1     idob64          (DOB64, DOB_[64], OEB_);      
  bufif1     idoa65          (DOA65, DOA_[65], OEA_);      
  bufif1     idob65          (DOB65, DOB_[65], OEB_);      
  bufif1     idoa66          (DOA66, DOA_[66], OEA_);      
  bufif1     idob66          (DOB66, DOB_[66], OEB_);      
  bufif1     idoa67          (DOA67, DOA_[67], OEA_);      
  bufif1     idob67          (DOB67, DOB_[67], OEB_);      
  bufif1     idoa68          (DOA68, DOA_[68], OEA_);      
  bufif1     idob68          (DOB68, DOB_[68], OEB_);      
  bufif1     idoa69          (DOA69, DOA_[69], OEA_);      
  bufif1     idob69          (DOB69, DOB_[69], OEB_);      
  bufif1     idoa70          (DOA70, DOA_[70], OEA_);      
  bufif1     idob70          (DOB70, DOB_[70], OEB_);      
  bufif1     idoa71          (DOA71, DOA_[71], OEA_);      
  bufif1     idob71          (DOB71, DOB_[71], OEB_);      
  bufif1     idoa72          (DOA72, DOA_[72], OEA_);      
  bufif1     idob72          (DOB72, DOB_[72], OEB_);      
  bufif1     idoa73          (DOA73, DOA_[73], OEA_);      
  bufif1     idob73          (DOB73, DOB_[73], OEB_);      
  bufif1     idoa74          (DOA74, DOA_[74], OEA_);      
  bufif1     idob74          (DOB74, DOB_[74], OEB_);      
  bufif1     idoa75          (DOA75, DOA_[75], OEA_);      
  bufif1     idob75          (DOB75, DOB_[75], OEB_);      
  bufif1     idoa76          (DOA76, DOA_[76], OEA_);      
  bufif1     idob76          (DOB76, DOB_[76], OEB_);      
  bufif1     idoa77          (DOA77, DOA_[77], OEA_);      
  bufif1     idob77          (DOB77, DOB_[77], OEB_);      
  bufif1     idoa78          (DOA78, DOA_[78], OEA_);      
  bufif1     idob78          (DOB78, DOB_[78], OEB_);      
  bufif1     idoa79          (DOA79, DOA_[79], OEA_);      
  bufif1     idob79          (DOB79, DOB_[79], OEB_);      
  bufif1     idoa80          (DOA80, DOA_[80], OEA_);      
  bufif1     idob80          (DOB80, DOB_[80], OEB_);      
  bufif1     idoa81          (DOA81, DOA_[81], OEA_);      
  bufif1     idob81          (DOB81, DOB_[81], OEB_);      
  bufif1     idoa82          (DOA82, DOA_[82], OEA_);      
  bufif1     idob82          (DOB82, DOB_[82], OEB_);      
  bufif1     idoa83          (DOA83, DOA_[83], OEA_);      
  bufif1     idob83          (DOB83, DOB_[83], OEB_);      
  bufif1     idoa84          (DOA84, DOA_[84], OEA_);      
  bufif1     idob84          (DOB84, DOB_[84], OEB_);      
  bufif1     idoa85          (DOA85, DOA_[85], OEA_);      
  bufif1     idob85          (DOB85, DOB_[85], OEB_);      
  bufif1     idoa86          (DOA86, DOA_[86], OEA_);      
  bufif1     idob86          (DOB86, DOB_[86], OEB_);      
  bufif1     idoa87          (DOA87, DOA_[87], OEA_);      
  bufif1     idob87          (DOB87, DOB_[87], OEB_);      
  bufif1     idoa88          (DOA88, DOA_[88], OEA_);      
  bufif1     idob88          (DOB88, DOB_[88], OEB_);      
  bufif1     idoa89          (DOA89, DOA_[89], OEA_);      
  bufif1     idob89          (DOB89, DOB_[89], OEB_);      
  bufif1     idoa90          (DOA90, DOA_[90], OEA_);      
  bufif1     idob90          (DOB90, DOB_[90], OEB_);      
  bufif1     idoa91          (DOA91, DOA_[91], OEA_);      
  bufif1     idob91          (DOB91, DOB_[91], OEB_);      
  bufif1     idoa92          (DOA92, DOA_[92], OEA_);      
  bufif1     idob92          (DOB92, DOB_[92], OEB_);      
  bufif1     idoa93          (DOA93, DOA_[93], OEA_);      
  bufif1     idob93          (DOB93, DOB_[93], OEB_);      
  bufif1     idoa94          (DOA94, DOA_[94], OEA_);      
  bufif1     idob94          (DOB94, DOB_[94], OEB_);      
  bufif1     idoa95          (DOA95, DOA_[95], OEA_);      
  bufif1     idob95          (DOB95, DOB_[95], OEB_);      
  bufif1     idoa96          (DOA96, DOA_[96], OEA_);      
  bufif1     idob96          (DOB96, DOB_[96], OEB_);      
  bufif1     idoa97          (DOA97, DOA_[97], OEA_);      
  bufif1     idob97          (DOB97, DOB_[97], OEB_);      
  bufif1     idoa98          (DOA98, DOA_[98], OEA_);      
  bufif1     idob98          (DOB98, DOB_[98], OEB_);      
  bufif1     idoa99          (DOA99, DOA_[99], OEA_);      
  bufif1     idob99          (DOB99, DOB_[99], OEB_);      
  bufif1     idoa100         (DOA100, DOA_[100], OEA_);    
  bufif1     idob100         (DOB100, DOB_[100], OEB_);    
  bufif1     idoa101         (DOA101, DOA_[101], OEA_);    
  bufif1     idob101         (DOB101, DOB_[101], OEB_);    
  bufif1     idoa102         (DOA102, DOA_[102], OEA_);    
  bufif1     idob102         (DOB102, DOB_[102], OEB_);    
  bufif1     idoa103         (DOA103, DOA_[103], OEA_);    
  bufif1     idob103         (DOB103, DOB_[103], OEB_);    
  bufif1     idoa104         (DOA104, DOA_[104], OEA_);    
  bufif1     idob104         (DOB104, DOB_[104], OEB_);    
  bufif1     idoa105         (DOA105, DOA_[105], OEA_);    
  bufif1     idob105         (DOB105, DOB_[105], OEB_);    
  bufif1     idoa106         (DOA106, DOA_[106], OEA_);    
  bufif1     idob106         (DOB106, DOB_[106], OEB_);    
  bufif1     idoa107         (DOA107, DOA_[107], OEA_);    
  bufif1     idob107         (DOB107, DOB_[107], OEB_);    
  bufif1     idoa108         (DOA108, DOA_[108], OEA_);    
  bufif1     idob108         (DOB108, DOB_[108], OEB_);    
  bufif1     idoa109         (DOA109, DOA_[109], OEA_);    
  bufif1     idob109         (DOB109, DOB_[109], OEB_);    
  bufif1     idoa110         (DOA110, DOA_[110], OEA_);    
  bufif1     idob110         (DOB110, DOB_[110], OEB_);    
  bufif1     idoa111         (DOA111, DOA_[111], OEA_);    
  bufif1     idob111         (DOB111, DOB_[111], OEB_);    
  bufif1     idoa112         (DOA112, DOA_[112], OEA_);    
  bufif1     idob112         (DOB112, DOB_[112], OEB_);    
  bufif1     idoa113         (DOA113, DOA_[113], OEA_);    
  bufif1     idob113         (DOB113, DOB_[113], OEB_);    
  bufif1     idoa114         (DOA114, DOA_[114], OEA_);    
  bufif1     idob114         (DOB114, DOB_[114], OEB_);    
  bufif1     idoa115         (DOA115, DOA_[115], OEA_);    
  bufif1     idob115         (DOB115, DOB_[115], OEB_);    
  bufif1     idoa116         (DOA116, DOA_[116], OEA_);    
  bufif1     idob116         (DOB116, DOB_[116], OEB_);    
  bufif1     idoa117         (DOA117, DOA_[117], OEA_);    
  bufif1     idob117         (DOB117, DOB_[117], OEB_);    
  bufif1     idoa118         (DOA118, DOA_[118], OEA_);    
  bufif1     idob118         (DOB118, DOB_[118], OEB_);    
  bufif1     idoa119         (DOA119, DOA_[119], OEA_);    
  bufif1     idob119         (DOB119, DOB_[119], OEB_);    
  bufif1     idoa120         (DOA120, DOA_[120], OEA_);    
  bufif1     idob120         (DOB120, DOB_[120], OEB_);    
  bufif1     idoa121         (DOA121, DOA_[121], OEA_);    
  bufif1     idob121         (DOB121, DOB_[121], OEB_);    
  bufif1     idoa122         (DOA122, DOA_[122], OEA_);    
  bufif1     idob122         (DOB122, DOB_[122], OEB_);    
  bufif1     idoa123         (DOA123, DOA_[123], OEA_);    
  bufif1     idob123         (DOB123, DOB_[123], OEB_);    
  bufif1     idoa124         (DOA124, DOA_[124], OEA_);    
  bufif1     idob124         (DOB124, DOB_[124], OEB_);    
  bufif1     idoa125         (DOA125, DOA_[125], OEA_);    
  bufif1     idob125         (DOB125, DOB_[125], OEB_);    
  bufif1     idoa126         (DOA126, DOA_[126], OEA_);    
  bufif1     idob126         (DOB126, DOB_[126], OEB_);    
  bufif1     idoa127         (DOA127, DOA_[127], OEA_);    
  bufif1     idob127         (DOB127, DOB_[127], OEB_);    
  buf        ia0             (A_[0], A0);                  
  buf        ia1             (A_[1], A1);                  
  buf        ia2             (A_[2], A2);                  
  buf        ia3             (A_[3], A3);                  
  buf        ia4             (A_[4], A4);                  
  buf        ia5             (A_[5], A5);                  
  buf        ia6             (A_[6], A6);                  
  buf        ib0             (B_[0], B0);                  
  buf        ib1             (B_[1], B1);                  
  buf        ib2             (B_[2], B2);                  
  buf        ib3             (B_[3], B3);                  
  buf        ib4             (B_[4], B4);                  
  buf        ib5             (B_[5], B5);                  
  buf        ib6             (B_[6], B6);                  
  buf        idia_0          (DIA_[0], DIA0);              
  buf        idib_0          (DIB_[0], DIB0);              
  buf        idia_1          (DIA_[1], DIA1);              
  buf        idib_1          (DIB_[1], DIB1);              
  buf        idia_2          (DIA_[2], DIA2);              
  buf        idib_2          (DIB_[2], DIB2);              
  buf        idia_3          (DIA_[3], DIA3);              
  buf        idib_3          (DIB_[3], DIB3);              
  buf        idia_4          (DIA_[4], DIA4);              
  buf        idib_4          (DIB_[4], DIB4);              
  buf        idia_5          (DIA_[5], DIA5);              
  buf        idib_5          (DIB_[5], DIB5);              
  buf        idia_6          (DIA_[6], DIA6);              
  buf        idib_6          (DIB_[6], DIB6);              
  buf        idia_7          (DIA_[7], DIA7);              
  buf        idib_7          (DIB_[7], DIB7);              
  buf        idia_8          (DIA_[8], DIA8);              
  buf        idib_8          (DIB_[8], DIB8);              
  buf        idia_9          (DIA_[9], DIA9);              
  buf        idib_9          (DIB_[9], DIB9);              
  buf        idia_10         (DIA_[10], DIA10);            
  buf        idib_10         (DIB_[10], DIB10);            
  buf        idia_11         (DIA_[11], DIA11);            
  buf        idib_11         (DIB_[11], DIB11);            
  buf        idia_12         (DIA_[12], DIA12);            
  buf        idib_12         (DIB_[12], DIB12);            
  buf        idia_13         (DIA_[13], DIA13);            
  buf        idib_13         (DIB_[13], DIB13);            
  buf        idia_14         (DIA_[14], DIA14);            
  buf        idib_14         (DIB_[14], DIB14);            
  buf        idia_15         (DIA_[15], DIA15);            
  buf        idib_15         (DIB_[15], DIB15);            
  buf        idia_16         (DIA_[16], DIA16);            
  buf        idib_16         (DIB_[16], DIB16);            
  buf        idia_17         (DIA_[17], DIA17);            
  buf        idib_17         (DIB_[17], DIB17);            
  buf        idia_18         (DIA_[18], DIA18);            
  buf        idib_18         (DIB_[18], DIB18);            
  buf        idia_19         (DIA_[19], DIA19);            
  buf        idib_19         (DIB_[19], DIB19);            
  buf        idia_20         (DIA_[20], DIA20);            
  buf        idib_20         (DIB_[20], DIB20);            
  buf        idia_21         (DIA_[21], DIA21);            
  buf        idib_21         (DIB_[21], DIB21);            
  buf        idia_22         (DIA_[22], DIA22);            
  buf        idib_22         (DIB_[22], DIB22);            
  buf        idia_23         (DIA_[23], DIA23);            
  buf        idib_23         (DIB_[23], DIB23);            
  buf        idia_24         (DIA_[24], DIA24);            
  buf        idib_24         (DIB_[24], DIB24);            
  buf        idia_25         (DIA_[25], DIA25);            
  buf        idib_25         (DIB_[25], DIB25);            
  buf        idia_26         (DIA_[26], DIA26);            
  buf        idib_26         (DIB_[26], DIB26);            
  buf        idia_27         (DIA_[27], DIA27);            
  buf        idib_27         (DIB_[27], DIB27);            
  buf        idia_28         (DIA_[28], DIA28);            
  buf        idib_28         (DIB_[28], DIB28);            
  buf        idia_29         (DIA_[29], DIA29);            
  buf        idib_29         (DIB_[29], DIB29);            
  buf        idia_30         (DIA_[30], DIA30);            
  buf        idib_30         (DIB_[30], DIB30);            
  buf        idia_31         (DIA_[31], DIA31);            
  buf        idib_31         (DIB_[31], DIB31);            
  buf        idia_32         (DIA_[32], DIA32);            
  buf        idib_32         (DIB_[32], DIB32);            
  buf        idia_33         (DIA_[33], DIA33);            
  buf        idib_33         (DIB_[33], DIB33);            
  buf        idia_34         (DIA_[34], DIA34);            
  buf        idib_34         (DIB_[34], DIB34);            
  buf        idia_35         (DIA_[35], DIA35);            
  buf        idib_35         (DIB_[35], DIB35);            
  buf        idia_36         (DIA_[36], DIA36);            
  buf        idib_36         (DIB_[36], DIB36);            
  buf        idia_37         (DIA_[37], DIA37);            
  buf        idib_37         (DIB_[37], DIB37);            
  buf        idia_38         (DIA_[38], DIA38);            
  buf        idib_38         (DIB_[38], DIB38);            
  buf        idia_39         (DIA_[39], DIA39);            
  buf        idib_39         (DIB_[39], DIB39);            
  buf        idia_40         (DIA_[40], DIA40);            
  buf        idib_40         (DIB_[40], DIB40);            
  buf        idia_41         (DIA_[41], DIA41);            
  buf        idib_41         (DIB_[41], DIB41);            
  buf        idia_42         (DIA_[42], DIA42);            
  buf        idib_42         (DIB_[42], DIB42);            
  buf        idia_43         (DIA_[43], DIA43);            
  buf        idib_43         (DIB_[43], DIB43);            
  buf        idia_44         (DIA_[44], DIA44);            
  buf        idib_44         (DIB_[44], DIB44);            
  buf        idia_45         (DIA_[45], DIA45);            
  buf        idib_45         (DIB_[45], DIB45);            
  buf        idia_46         (DIA_[46], DIA46);            
  buf        idib_46         (DIB_[46], DIB46);            
  buf        idia_47         (DIA_[47], DIA47);            
  buf        idib_47         (DIB_[47], DIB47);            
  buf        idia_48         (DIA_[48], DIA48);            
  buf        idib_48         (DIB_[48], DIB48);            
  buf        idia_49         (DIA_[49], DIA49);            
  buf        idib_49         (DIB_[49], DIB49);            
  buf        idia_50         (DIA_[50], DIA50);            
  buf        idib_50         (DIB_[50], DIB50);            
  buf        idia_51         (DIA_[51], DIA51);            
  buf        idib_51         (DIB_[51], DIB51);            
  buf        idia_52         (DIA_[52], DIA52);            
  buf        idib_52         (DIB_[52], DIB52);            
  buf        idia_53         (DIA_[53], DIA53);            
  buf        idib_53         (DIB_[53], DIB53);            
  buf        idia_54         (DIA_[54], DIA54);            
  buf        idib_54         (DIB_[54], DIB54);            
  buf        idia_55         (DIA_[55], DIA55);            
  buf        idib_55         (DIB_[55], DIB55);            
  buf        idia_56         (DIA_[56], DIA56);            
  buf        idib_56         (DIB_[56], DIB56);            
  buf        idia_57         (DIA_[57], DIA57);            
  buf        idib_57         (DIB_[57], DIB57);            
  buf        idia_58         (DIA_[58], DIA58);            
  buf        idib_58         (DIB_[58], DIB58);            
  buf        idia_59         (DIA_[59], DIA59);            
  buf        idib_59         (DIB_[59], DIB59);            
  buf        idia_60         (DIA_[60], DIA60);            
  buf        idib_60         (DIB_[60], DIB60);            
  buf        idia_61         (DIA_[61], DIA61);            
  buf        idib_61         (DIB_[61], DIB61);            
  buf        idia_62         (DIA_[62], DIA62);            
  buf        idib_62         (DIB_[62], DIB62);            
  buf        idia_63         (DIA_[63], DIA63);            
  buf        idib_63         (DIB_[63], DIB63);            
  buf        idia_64         (DIA_[64], DIA64);            
  buf        idib_64         (DIB_[64], DIB64);            
  buf        idia_65         (DIA_[65], DIA65);            
  buf        idib_65         (DIB_[65], DIB65);            
  buf        idia_66         (DIA_[66], DIA66);            
  buf        idib_66         (DIB_[66], DIB66);            
  buf        idia_67         (DIA_[67], DIA67);            
  buf        idib_67         (DIB_[67], DIB67);            
  buf        idia_68         (DIA_[68], DIA68);            
  buf        idib_68         (DIB_[68], DIB68);            
  buf        idia_69         (DIA_[69], DIA69);            
  buf        idib_69         (DIB_[69], DIB69);            
  buf        idia_70         (DIA_[70], DIA70);            
  buf        idib_70         (DIB_[70], DIB70);            
  buf        idia_71         (DIA_[71], DIA71);            
  buf        idib_71         (DIB_[71], DIB71);            
  buf        idia_72         (DIA_[72], DIA72);            
  buf        idib_72         (DIB_[72], DIB72);            
  buf        idia_73         (DIA_[73], DIA73);            
  buf        idib_73         (DIB_[73], DIB73);            
  buf        idia_74         (DIA_[74], DIA74);            
  buf        idib_74         (DIB_[74], DIB74);            
  buf        idia_75         (DIA_[75], DIA75);            
  buf        idib_75         (DIB_[75], DIB75);            
  buf        idia_76         (DIA_[76], DIA76);            
  buf        idib_76         (DIB_[76], DIB76);            
  buf        idia_77         (DIA_[77], DIA77);            
  buf        idib_77         (DIB_[77], DIB77);            
  buf        idia_78         (DIA_[78], DIA78);            
  buf        idib_78         (DIB_[78], DIB78);            
  buf        idia_79         (DIA_[79], DIA79);            
  buf        idib_79         (DIB_[79], DIB79);            
  buf        idia_80         (DIA_[80], DIA80);            
  buf        idib_80         (DIB_[80], DIB80);            
  buf        idia_81         (DIA_[81], DIA81);            
  buf        idib_81         (DIB_[81], DIB81);            
  buf        idia_82         (DIA_[82], DIA82);            
  buf        idib_82         (DIB_[82], DIB82);            
  buf        idia_83         (DIA_[83], DIA83);            
  buf        idib_83         (DIB_[83], DIB83);            
  buf        idia_84         (DIA_[84], DIA84);            
  buf        idib_84         (DIB_[84], DIB84);            
  buf        idia_85         (DIA_[85], DIA85);            
  buf        idib_85         (DIB_[85], DIB85);            
  buf        idia_86         (DIA_[86], DIA86);            
  buf        idib_86         (DIB_[86], DIB86);            
  buf        idia_87         (DIA_[87], DIA87);            
  buf        idib_87         (DIB_[87], DIB87);            
  buf        idia_88         (DIA_[88], DIA88);            
  buf        idib_88         (DIB_[88], DIB88);            
  buf        idia_89         (DIA_[89], DIA89);            
  buf        idib_89         (DIB_[89], DIB89);            
  buf        idia_90         (DIA_[90], DIA90);            
  buf        idib_90         (DIB_[90], DIB90);            
  buf        idia_91         (DIA_[91], DIA91);            
  buf        idib_91         (DIB_[91], DIB91);            
  buf        idia_92         (DIA_[92], DIA92);            
  buf        idib_92         (DIB_[92], DIB92);            
  buf        idia_93         (DIA_[93], DIA93);            
  buf        idib_93         (DIB_[93], DIB93);            
  buf        idia_94         (DIA_[94], DIA94);            
  buf        idib_94         (DIB_[94], DIB94);            
  buf        idia_95         (DIA_[95], DIA95);            
  buf        idib_95         (DIB_[95], DIB95);            
  buf        idia_96         (DIA_[96], DIA96);            
  buf        idib_96         (DIB_[96], DIB96);            
  buf        idia_97         (DIA_[97], DIA97);            
  buf        idib_97         (DIB_[97], DIB97);            
  buf        idia_98         (DIA_[98], DIA98);            
  buf        idib_98         (DIB_[98], DIB98);            
  buf        idia_99         (DIA_[99], DIA99);            
  buf        idib_99         (DIB_[99], DIB99);            
  buf        idia_100        (DIA_[100], DIA100);          
  buf        idib_100        (DIB_[100], DIB100);          
  buf        idia_101        (DIA_[101], DIA101);          
  buf        idib_101        (DIB_[101], DIB101);          
  buf        idia_102        (DIA_[102], DIA102);          
  buf        idib_102        (DIB_[102], DIB102);          
  buf        idia_103        (DIA_[103], DIA103);          
  buf        idib_103        (DIB_[103], DIB103);          
  buf        idia_104        (DIA_[104], DIA104);          
  buf        idib_104        (DIB_[104], DIB104);          
  buf        idia_105        (DIA_[105], DIA105);          
  buf        idib_105        (DIB_[105], DIB105);          
  buf        idia_106        (DIA_[106], DIA106);          
  buf        idib_106        (DIB_[106], DIB106);          
  buf        idia_107        (DIA_[107], DIA107);          
  buf        idib_107        (DIB_[107], DIB107);          
  buf        idia_108        (DIA_[108], DIA108);          
  buf        idib_108        (DIB_[108], DIB108);          
  buf        idia_109        (DIA_[109], DIA109);          
  buf        idib_109        (DIB_[109], DIB109);          
  buf        idia_110        (DIA_[110], DIA110);          
  buf        idib_110        (DIB_[110], DIB110);          
  buf        idia_111        (DIA_[111], DIA111);          
  buf        idib_111        (DIB_[111], DIB111);          
  buf        idia_112        (DIA_[112], DIA112);          
  buf        idib_112        (DIB_[112], DIB112);          
  buf        idia_113        (DIA_[113], DIA113);          
  buf        idib_113        (DIB_[113], DIB113);          
  buf        idia_114        (DIA_[114], DIA114);          
  buf        idib_114        (DIB_[114], DIB114);          
  buf        idia_115        (DIA_[115], DIA115);          
  buf        idib_115        (DIB_[115], DIB115);          
  buf        idia_116        (DIA_[116], DIA116);          
  buf        idib_116        (DIB_[116], DIB116);          
  buf        idia_117        (DIA_[117], DIA117);          
  buf        idib_117        (DIB_[117], DIB117);          
  buf        idia_118        (DIA_[118], DIA118);          
  buf        idib_118        (DIB_[118], DIB118);          
  buf        idia_119        (DIA_[119], DIA119);          
  buf        idib_119        (DIB_[119], DIB119);          
  buf        idia_120        (DIA_[120], DIA120);          
  buf        idib_120        (DIB_[120], DIB120);          
  buf        idia_121        (DIA_[121], DIA121);          
  buf        idib_121        (DIB_[121], DIB121);          
  buf        idia_122        (DIA_[122], DIA122);          
  buf        idib_122        (DIB_[122], DIB122);          
  buf        idia_123        (DIA_[123], DIA123);          
  buf        idib_123        (DIB_[123], DIB123);          
  buf        idia_124        (DIA_[124], DIA124);          
  buf        idib_124        (DIB_[124], DIB124);          
  buf        idia_125        (DIA_[125], DIA125);          
  buf        idib_125        (DIB_[125], DIB125);          
  buf        idia_126        (DIA_[126], DIA126);          
  buf        idib_126        (DIB_[126], DIB126);          
  buf        idia_127        (DIA_[127], DIA127);          
  buf        idib_127        (DIB_[127], DIB127);          
  buf        icka            (CKA_, CKA);                  
  buf        ickb            (CKB_, CKB);                  
  buf        icsa            (CSA_, CSA);                  
  buf        icsb            (CSB_, CSB);                  
  buf        ioea            (OEA_, OEA);                  
  buf        ioeb            (OEB_, OEB);                  
  buf        iwea0           (WEAN_, WEAN);                
  buf        iweb0           (WEBN_, WEBN);                

  initial begin
    $timeformat (-12, 0, " ps", 20);
    flag_A_x = `FALSE;
    flag_B_x = `FALSE;
    NODELAYA = 1'b0;
    NODELAYB = 1'b0;
  end


  always @(CKA_) begin
    casez ({LastClkAEdge,CKA_})
      2'b01:
         begin
           last_A = latch_last_A;
           last_DIA = latch_last_DIA;
           CSA_monitor;
           pre_latch_dataA;
           memory_functionA;
           if (CSA_==1'b1) Last_tc_ClkA_PosEdge = $time;
           latch_last_A = A_;
           latch_last_DIA = DIA_;
         end
      2'b?x:
         begin
           ErrorMessage(0);
           if (CSA_ !== 0) begin
              if (WEAN_ !== 1'b1) begin
                 all_core_xA(9999,1);
              end else begin
                 #0 disable TOHDOA;
                 NODELAYA = 1'b1;
                 DOA_i = {Bits{1'bX}};
              end
           end
         end
    endcase
    LastClkAEdge = CKA_;
  end

  always @(CKB_) begin
    casez ({LastClkBEdge,CKB_})
      2'b01:
         begin
           last_B = latch_last_B;
           last_DIB = latch_last_DIB;
           CSB_monitor;
           pre_latch_dataB;
           memory_functionB;
           if (CSB_==1'b1) Last_tc_ClkB_PosEdge = $time;
           latch_last_B = B_;
           latch_last_DIB = DIB_;
         end
      2'b?x:
         begin
           ErrorMessage(0);
           if (CSB_ !== 0) begin
              if (WEBN_ !== 1'b1) begin
                 all_core_xB(9999,1);
              end else begin
                 #0 disable TOHDOB;
                 NODELAYB = 1'b1;
                 DOB_i = {Bits{1'bX}};
              end
           end
         end
    endcase
    LastClkBEdge = CKB_;
  end

  always @(
           n_flag_A0 or
           n_flag_A1 or
           n_flag_A2 or
           n_flag_A3 or
           n_flag_A4 or
           n_flag_A5 or
           n_flag_A6 or
           n_flag_DIA0 or
           n_flag_DIA1 or
           n_flag_DIA2 or
           n_flag_DIA3 or
           n_flag_DIA4 or
           n_flag_DIA5 or
           n_flag_DIA6 or
           n_flag_DIA7 or
           n_flag_DIA8 or
           n_flag_DIA9 or
           n_flag_DIA10 or
           n_flag_DIA11 or
           n_flag_DIA12 or
           n_flag_DIA13 or
           n_flag_DIA14 or
           n_flag_DIA15 or
           n_flag_DIA16 or
           n_flag_DIA17 or
           n_flag_DIA18 or
           n_flag_DIA19 or
           n_flag_DIA20 or
           n_flag_DIA21 or
           n_flag_DIA22 or
           n_flag_DIA23 or
           n_flag_DIA24 or
           n_flag_DIA25 or
           n_flag_DIA26 or
           n_flag_DIA27 or
           n_flag_DIA28 or
           n_flag_DIA29 or
           n_flag_DIA30 or
           n_flag_DIA31 or
           n_flag_DIA32 or
           n_flag_DIA33 or
           n_flag_DIA34 or
           n_flag_DIA35 or
           n_flag_DIA36 or
           n_flag_DIA37 or
           n_flag_DIA38 or
           n_flag_DIA39 or
           n_flag_DIA40 or
           n_flag_DIA41 or
           n_flag_DIA42 or
           n_flag_DIA43 or
           n_flag_DIA44 or
           n_flag_DIA45 or
           n_flag_DIA46 or
           n_flag_DIA47 or
           n_flag_DIA48 or
           n_flag_DIA49 or
           n_flag_DIA50 or
           n_flag_DIA51 or
           n_flag_DIA52 or
           n_flag_DIA53 or
           n_flag_DIA54 or
           n_flag_DIA55 or
           n_flag_DIA56 or
           n_flag_DIA57 or
           n_flag_DIA58 or
           n_flag_DIA59 or
           n_flag_DIA60 or
           n_flag_DIA61 or
           n_flag_DIA62 or
           n_flag_DIA63 or
           n_flag_DIA64 or
           n_flag_DIA65 or
           n_flag_DIA66 or
           n_flag_DIA67 or
           n_flag_DIA68 or
           n_flag_DIA69 or
           n_flag_DIA70 or
           n_flag_DIA71 or
           n_flag_DIA72 or
           n_flag_DIA73 or
           n_flag_DIA74 or
           n_flag_DIA75 or
           n_flag_DIA76 or
           n_flag_DIA77 or
           n_flag_DIA78 or
           n_flag_DIA79 or
           n_flag_DIA80 or
           n_flag_DIA81 or
           n_flag_DIA82 or
           n_flag_DIA83 or
           n_flag_DIA84 or
           n_flag_DIA85 or
           n_flag_DIA86 or
           n_flag_DIA87 or
           n_flag_DIA88 or
           n_flag_DIA89 or
           n_flag_DIA90 or
           n_flag_DIA91 or
           n_flag_DIA92 or
           n_flag_DIA93 or
           n_flag_DIA94 or
           n_flag_DIA95 or
           n_flag_DIA96 or
           n_flag_DIA97 or
           n_flag_DIA98 or
           n_flag_DIA99 or
           n_flag_DIA100 or
           n_flag_DIA101 or
           n_flag_DIA102 or
           n_flag_DIA103 or
           n_flag_DIA104 or
           n_flag_DIA105 or
           n_flag_DIA106 or
           n_flag_DIA107 or
           n_flag_DIA108 or
           n_flag_DIA109 or
           n_flag_DIA110 or
           n_flag_DIA111 or
           n_flag_DIA112 or
           n_flag_DIA113 or
           n_flag_DIA114 or
           n_flag_DIA115 or
           n_flag_DIA116 or
           n_flag_DIA117 or
           n_flag_DIA118 or
           n_flag_DIA119 or
           n_flag_DIA120 or
           n_flag_DIA121 or
           n_flag_DIA122 or
           n_flag_DIA123 or
           n_flag_DIA124 or
           n_flag_DIA125 or
           n_flag_DIA126 or
           n_flag_DIA127 or
           n_flag_WEAN or
           n_flag_CSA or
           n_flag_CKA_PER or
           n_flag_CKA_MINH or
           n_flag_CKA_MINL
          )
     begin
       timingcheck_violationA;
     end

  always @(
           n_flag_B0 or
           n_flag_B1 or
           n_flag_B2 or
           n_flag_B3 or
           n_flag_B4 or
           n_flag_B5 or
           n_flag_B6 or
           n_flag_DIB0 or
           n_flag_DIB1 or
           n_flag_DIB2 or
           n_flag_DIB3 or
           n_flag_DIB4 or
           n_flag_DIB5 or
           n_flag_DIB6 or
           n_flag_DIB7 or
           n_flag_DIB8 or
           n_flag_DIB9 or
           n_flag_DIB10 or
           n_flag_DIB11 or
           n_flag_DIB12 or
           n_flag_DIB13 or
           n_flag_DIB14 or
           n_flag_DIB15 or
           n_flag_DIB16 or
           n_flag_DIB17 or
           n_flag_DIB18 or
           n_flag_DIB19 or
           n_flag_DIB20 or
           n_flag_DIB21 or
           n_flag_DIB22 or
           n_flag_DIB23 or
           n_flag_DIB24 or
           n_flag_DIB25 or
           n_flag_DIB26 or
           n_flag_DIB27 or
           n_flag_DIB28 or
           n_flag_DIB29 or
           n_flag_DIB30 or
           n_flag_DIB31 or
           n_flag_DIB32 or
           n_flag_DIB33 or
           n_flag_DIB34 or
           n_flag_DIB35 or
           n_flag_DIB36 or
           n_flag_DIB37 or
           n_flag_DIB38 or
           n_flag_DIB39 or
           n_flag_DIB40 or
           n_flag_DIB41 or
           n_flag_DIB42 or
           n_flag_DIB43 or
           n_flag_DIB44 or
           n_flag_DIB45 or
           n_flag_DIB46 or
           n_flag_DIB47 or
           n_flag_DIB48 or
           n_flag_DIB49 or
           n_flag_DIB50 or
           n_flag_DIB51 or
           n_flag_DIB52 or
           n_flag_DIB53 or
           n_flag_DIB54 or
           n_flag_DIB55 or
           n_flag_DIB56 or
           n_flag_DIB57 or
           n_flag_DIB58 or
           n_flag_DIB59 or
           n_flag_DIB60 or
           n_flag_DIB61 or
           n_flag_DIB62 or
           n_flag_DIB63 or
           n_flag_DIB64 or
           n_flag_DIB65 or
           n_flag_DIB66 or
           n_flag_DIB67 or
           n_flag_DIB68 or
           n_flag_DIB69 or
           n_flag_DIB70 or
           n_flag_DIB71 or
           n_flag_DIB72 or
           n_flag_DIB73 or
           n_flag_DIB74 or
           n_flag_DIB75 or
           n_flag_DIB76 or
           n_flag_DIB77 or
           n_flag_DIB78 or
           n_flag_DIB79 or
           n_flag_DIB80 or
           n_flag_DIB81 or
           n_flag_DIB82 or
           n_flag_DIB83 or
           n_flag_DIB84 or
           n_flag_DIB85 or
           n_flag_DIB86 or
           n_flag_DIB87 or
           n_flag_DIB88 or
           n_flag_DIB89 or
           n_flag_DIB90 or
           n_flag_DIB91 or
           n_flag_DIB92 or
           n_flag_DIB93 or
           n_flag_DIB94 or
           n_flag_DIB95 or
           n_flag_DIB96 or
           n_flag_DIB97 or
           n_flag_DIB98 or
           n_flag_DIB99 or
           n_flag_DIB100 or
           n_flag_DIB101 or
           n_flag_DIB102 or
           n_flag_DIB103 or
           n_flag_DIB104 or
           n_flag_DIB105 or
           n_flag_DIB106 or
           n_flag_DIB107 or
           n_flag_DIB108 or
           n_flag_DIB109 or
           n_flag_DIB110 or
           n_flag_DIB111 or
           n_flag_DIB112 or
           n_flag_DIB113 or
           n_flag_DIB114 or
           n_flag_DIB115 or
           n_flag_DIB116 or
           n_flag_DIB117 or
           n_flag_DIB118 or
           n_flag_DIB119 or
           n_flag_DIB120 or
           n_flag_DIB121 or
           n_flag_DIB122 or
           n_flag_DIB123 or
           n_flag_DIB124 or
           n_flag_DIB125 or
           n_flag_DIB126 or
           n_flag_DIB127 or
           n_flag_WEBN or
           n_flag_CSB or
           n_flag_CKB_PER or
           n_flag_CKB_MINH or
           n_flag_CKB_MINL
          )
     begin
       timingcheck_violationB;
     end


  always @(EventTOHDOA) 
    begin:TOHDOA 
      #TOH 
      NODELAYA <= 1'b0; 
      DOA_i              =  {Bits{1'bX}}; 
      DOA_i              <= DOA_tmp; 
  end 

  always @(EventTOHDOB) 
    begin:TOHDOB 
      #TOH 
      NODELAYB <= 1'b0; 
      DOB_i              =  {Bits{1'bX}}; 
      DOB_i              <= DOB_tmp; 
  end 


  task timingcheck_violationA;
    integer i;
    begin
      // PORT A
      if ((n_flag_CKA_PER  !== LAST_n_flag_CKA_PER)  ||
          (n_flag_CKA_MINH !== LAST_n_flag_CKA_MINH) ||
          (n_flag_CKA_MINL !== LAST_n_flag_CKA_MINL)) begin
          if (CSA_ !== 1'b0) begin
             if (WEAN_ !== 1'b1) begin
                all_core_xA(9999,1);
             end
             else begin
                #0 disable TOHDOA;
                NODELAYA = 1'b1;
                DOA_i = {Bits{1'bX}};
             end
          end
      end
      else begin
          NOT_BUS_A  = {
                         n_flag_A6,
                         n_flag_A5,
                         n_flag_A4,
                         n_flag_A3,
                         n_flag_A2,
                         n_flag_A1,
                         n_flag_A0};

          NOT_BUS_DIA  = {
                         n_flag_DIA127,
                         n_flag_DIA126,
                         n_flag_DIA125,
                         n_flag_DIA124,
                         n_flag_DIA123,
                         n_flag_DIA122,
                         n_flag_DIA121,
                         n_flag_DIA120,
                         n_flag_DIA119,
                         n_flag_DIA118,
                         n_flag_DIA117,
                         n_flag_DIA116,
                         n_flag_DIA115,
                         n_flag_DIA114,
                         n_flag_DIA113,
                         n_flag_DIA112,
                         n_flag_DIA111,
                         n_flag_DIA110,
                         n_flag_DIA109,
                         n_flag_DIA108,
                         n_flag_DIA107,
                         n_flag_DIA106,
                         n_flag_DIA105,
                         n_flag_DIA104,
                         n_flag_DIA103,
                         n_flag_DIA102,
                         n_flag_DIA101,
                         n_flag_DIA100,
                         n_flag_DIA99,
                         n_flag_DIA98,
                         n_flag_DIA97,
                         n_flag_DIA96,
                         n_flag_DIA95,
                         n_flag_DIA94,
                         n_flag_DIA93,
                         n_flag_DIA92,
                         n_flag_DIA91,
                         n_flag_DIA90,
                         n_flag_DIA89,
                         n_flag_DIA88,
                         n_flag_DIA87,
                         n_flag_DIA86,
                         n_flag_DIA85,
                         n_flag_DIA84,
                         n_flag_DIA83,
                         n_flag_DIA82,
                         n_flag_DIA81,
                         n_flag_DIA80,
                         n_flag_DIA79,
                         n_flag_DIA78,
                         n_flag_DIA77,
                         n_flag_DIA76,
                         n_flag_DIA75,
                         n_flag_DIA74,
                         n_flag_DIA73,
                         n_flag_DIA72,
                         n_flag_DIA71,
                         n_flag_DIA70,
                         n_flag_DIA69,
                         n_flag_DIA68,
                         n_flag_DIA67,
                         n_flag_DIA66,
                         n_flag_DIA65,
                         n_flag_DIA64,
                         n_flag_DIA63,
                         n_flag_DIA62,
                         n_flag_DIA61,
                         n_flag_DIA60,
                         n_flag_DIA59,
                         n_flag_DIA58,
                         n_flag_DIA57,
                         n_flag_DIA56,
                         n_flag_DIA55,
                         n_flag_DIA54,
                         n_flag_DIA53,
                         n_flag_DIA52,
                         n_flag_DIA51,
                         n_flag_DIA50,
                         n_flag_DIA49,
                         n_flag_DIA48,
                         n_flag_DIA47,
                         n_flag_DIA46,
                         n_flag_DIA45,
                         n_flag_DIA44,
                         n_flag_DIA43,
                         n_flag_DIA42,
                         n_flag_DIA41,
                         n_flag_DIA40,
                         n_flag_DIA39,
                         n_flag_DIA38,
                         n_flag_DIA37,
                         n_flag_DIA36,
                         n_flag_DIA35,
                         n_flag_DIA34,
                         n_flag_DIA33,
                         n_flag_DIA32,
                         n_flag_DIA31,
                         n_flag_DIA30,
                         n_flag_DIA29,
                         n_flag_DIA28,
                         n_flag_DIA27,
                         n_flag_DIA26,
                         n_flag_DIA25,
                         n_flag_DIA24,
                         n_flag_DIA23,
                         n_flag_DIA22,
                         n_flag_DIA21,
                         n_flag_DIA20,
                         n_flag_DIA19,
                         n_flag_DIA18,
                         n_flag_DIA17,
                         n_flag_DIA16,
                         n_flag_DIA15,
                         n_flag_DIA14,
                         n_flag_DIA13,
                         n_flag_DIA12,
                         n_flag_DIA11,
                         n_flag_DIA10,
                         n_flag_DIA9,
                         n_flag_DIA8,
                         n_flag_DIA7,
                         n_flag_DIA6,
                         n_flag_DIA5,
                         n_flag_DIA4,
                         n_flag_DIA3,
                         n_flag_DIA2,
                         n_flag_DIA1,
                         n_flag_DIA0};

          for (i=0; i<AddressSize; i=i+1) begin
             Latch_A[i] = (NOT_BUS_A[i] !== LAST_NOT_BUS_A[i]) ? 1'bx : Latch_A[i];
          end
          for (i=0; i<Bits; i=i+1) begin
             Latch_DIA[i] = (NOT_BUS_DIA[i] !== LAST_NOT_BUS_DIA[i]) ? 1'bx : Latch_DIA[i];
          end
          Latch_CSA  =  (n_flag_CSA  !== LAST_n_flag_CSA)  ? 1'bx : Latch_CSA;
          Latch_WEAN = (n_flag_WEAN !== LAST_n_flag_WEAN)  ? 1'bx : Latch_WEAN;
          memory_functionA;
      end

      LAST_NOT_BUS_A                 = NOT_BUS_A;
      LAST_NOT_BUS_DIA               = NOT_BUS_DIA;
      LAST_n_flag_WEAN               = n_flag_WEAN;
      LAST_n_flag_CSA                = n_flag_CSA;
      LAST_n_flag_CKA_PER            = n_flag_CKA_PER;
      LAST_n_flag_CKA_MINH           = n_flag_CKA_MINH;
      LAST_n_flag_CKA_MINL           = n_flag_CKA_MINL;
    end
  endtask // end timingcheck_violationA;

  task timingcheck_violationB;
    integer i;
    begin
      // PORT B
      if ((n_flag_CKB_PER  !== LAST_n_flag_CKB_PER)  ||
          (n_flag_CKB_MINH !== LAST_n_flag_CKB_MINH) ||
          (n_flag_CKB_MINL !== LAST_n_flag_CKB_MINL)) begin
          if (CSB_ !== 1'b0) begin
             if (WEBN_ !== 1'b1) begin
                all_core_xB(9999,1);
             end
             else begin
                #0 disable TOHDOB;
                NODELAYB = 1'b1;
                DOB_i = {Bits{1'bX}};
             end
          end
      end
      else begin
          NOT_BUS_B  = {
                         n_flag_B6,
                         n_flag_B5,
                         n_flag_B4,
                         n_flag_B3,
                         n_flag_B2,
                         n_flag_B1,
                         n_flag_B0};

          NOT_BUS_DIB  = {
                         n_flag_DIB127,
                         n_flag_DIB126,
                         n_flag_DIB125,
                         n_flag_DIB124,
                         n_flag_DIB123,
                         n_flag_DIB122,
                         n_flag_DIB121,
                         n_flag_DIB120,
                         n_flag_DIB119,
                         n_flag_DIB118,
                         n_flag_DIB117,
                         n_flag_DIB116,
                         n_flag_DIB115,
                         n_flag_DIB114,
                         n_flag_DIB113,
                         n_flag_DIB112,
                         n_flag_DIB111,
                         n_flag_DIB110,
                         n_flag_DIB109,
                         n_flag_DIB108,
                         n_flag_DIB107,
                         n_flag_DIB106,
                         n_flag_DIB105,
                         n_flag_DIB104,
                         n_flag_DIB103,
                         n_flag_DIB102,
                         n_flag_DIB101,
                         n_flag_DIB100,
                         n_flag_DIB99,
                         n_flag_DIB98,
                         n_flag_DIB97,
                         n_flag_DIB96,
                         n_flag_DIB95,
                         n_flag_DIB94,
                         n_flag_DIB93,
                         n_flag_DIB92,
                         n_flag_DIB91,
                         n_flag_DIB90,
                         n_flag_DIB89,
                         n_flag_DIB88,
                         n_flag_DIB87,
                         n_flag_DIB86,
                         n_flag_DIB85,
                         n_flag_DIB84,
                         n_flag_DIB83,
                         n_flag_DIB82,
                         n_flag_DIB81,
                         n_flag_DIB80,
                         n_flag_DIB79,
                         n_flag_DIB78,
                         n_flag_DIB77,
                         n_flag_DIB76,
                         n_flag_DIB75,
                         n_flag_DIB74,
                         n_flag_DIB73,
                         n_flag_DIB72,
                         n_flag_DIB71,
                         n_flag_DIB70,
                         n_flag_DIB69,
                         n_flag_DIB68,
                         n_flag_DIB67,
                         n_flag_DIB66,
                         n_flag_DIB65,
                         n_flag_DIB64,
                         n_flag_DIB63,
                         n_flag_DIB62,
                         n_flag_DIB61,
                         n_flag_DIB60,
                         n_flag_DIB59,
                         n_flag_DIB58,
                         n_flag_DIB57,
                         n_flag_DIB56,
                         n_flag_DIB55,
                         n_flag_DIB54,
                         n_flag_DIB53,
                         n_flag_DIB52,
                         n_flag_DIB51,
                         n_flag_DIB50,
                         n_flag_DIB49,
                         n_flag_DIB48,
                         n_flag_DIB47,
                         n_flag_DIB46,
                         n_flag_DIB45,
                         n_flag_DIB44,
                         n_flag_DIB43,
                         n_flag_DIB42,
                         n_flag_DIB41,
                         n_flag_DIB40,
                         n_flag_DIB39,
                         n_flag_DIB38,
                         n_flag_DIB37,
                         n_flag_DIB36,
                         n_flag_DIB35,
                         n_flag_DIB34,
                         n_flag_DIB33,
                         n_flag_DIB32,
                         n_flag_DIB31,
                         n_flag_DIB30,
                         n_flag_DIB29,
                         n_flag_DIB28,
                         n_flag_DIB27,
                         n_flag_DIB26,
                         n_flag_DIB25,
                         n_flag_DIB24,
                         n_flag_DIB23,
                         n_flag_DIB22,
                         n_flag_DIB21,
                         n_flag_DIB20,
                         n_flag_DIB19,
                         n_flag_DIB18,
                         n_flag_DIB17,
                         n_flag_DIB16,
                         n_flag_DIB15,
                         n_flag_DIB14,
                         n_flag_DIB13,
                         n_flag_DIB12,
                         n_flag_DIB11,
                         n_flag_DIB10,
                         n_flag_DIB9,
                         n_flag_DIB8,
                         n_flag_DIB7,
                         n_flag_DIB6,
                         n_flag_DIB5,
                         n_flag_DIB4,
                         n_flag_DIB3,
                         n_flag_DIB2,
                         n_flag_DIB1,
                         n_flag_DIB0};

          for (i=0; i<AddressSize; i=i+1) begin
             Latch_B[i] = (NOT_BUS_B[i] !== LAST_NOT_BUS_B[i]) ? 1'bx : Latch_B[i];
          end
          for (i=0; i<Bits; i=i+1) begin
             Latch_DIB[i] = (NOT_BUS_DIB[i] !== LAST_NOT_BUS_DIB[i]) ? 1'bx : Latch_DIB[i];
          end
          Latch_CSB  =  (n_flag_CSB  !== LAST_n_flag_CSB)  ? 1'bx : Latch_CSB;
          Latch_WEBN = (n_flag_WEBN !== LAST_n_flag_WEBN)  ? 1'bx : Latch_WEBN;
          memory_functionB;
      end

      LAST_NOT_BUS_B                 = NOT_BUS_B;
      LAST_NOT_BUS_DIB               = NOT_BUS_DIB;
      LAST_n_flag_WEBN               = n_flag_WEBN;
      LAST_n_flag_CSB                = n_flag_CSB;
      LAST_n_flag_CKB_PER            = n_flag_CKB_PER;
      LAST_n_flag_CKB_MINH           = n_flag_CKB_MINH;
      LAST_n_flag_CKB_MINL           = n_flag_CKB_MINL;
    end
  endtask // end timingcheck_violationB;

  task pre_latch_dataA;
    begin
      Latch_A                        = A_;
      Latch_DIA                      = DIA_;
      Latch_CSA                      = CSA_;
      Latch_WEAN                     = WEAN_;
    end
  endtask //end pre_latch_dataA

  task pre_latch_dataB;
    begin
      Latch_B                        = B_;
      Latch_DIB                      = DIB_;
      Latch_CSB                      = CSB_;
      Latch_WEBN                     = WEBN_;
    end
  endtask //end pre_latch_dataB

  task memory_functionA;
    begin
      A_i                            = Latch_A;
      DIA_i                          = Latch_DIA;
      WEAN_i                         = Latch_WEAN;
      CSA_i                          = Latch_CSA;

      if (CSA_ == 1'b1) A_monitor;

      casez({WEAN_i,CSA_i})
        2'b11: begin
           if (AddressRangeCheck(A_i)) begin
              if ((A_i == LastCycleBAddress)&&
                  (Last_WEBN_i == 1'b0) &&
                  ($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOA;
                  NODELAYA = 1'b1;
                  DOA_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                    if (A_i !== last_A) begin
                       NODELAYA = 1'b1;
                       DOA_tmp = Memory[A_i];
                       ->EventTOHDOA;
                    end else begin
                       NODELAYA = 1'b0;
                       DOA_tmp  = Memory[A_i];
                       DOA_i    = DOA_tmp;
                    end
                  end else begin
                    NODELAYA = 1'b1;
                    DOA_tmp = Memory[A_i];
                    ->EventTOHDOA;
                  end
              end
           end
           else begin
                //DOA_i = {Bits{1'bX}};
                #0 disable TOHDOA;
                NODELAYA = 1'b1;
                DOA_i = {Bits{1'bX}};
           end
           LastCycleAAddress = A_i;
        end
        2'b01: begin
           if (AddressRangeCheck(A_i)) begin
              if (A_i == LastCycleBAddress) begin
                 if ((Last_WEBN_i == 1'b1)&&($time-Last_tc_ClkB_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    //DOB_i = {Bits{1'bX}};
                    #0 disable TOHDOB;
                    NODELAYB = 1'b1;
                    DOB_i = {Bits{1'bX}};
                    Memory[A_i] = DIA_i;
                 end else if ((Last_WEBN_i == 1'b0)&&($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory[A_i] = {Bits{1'bX}};
                 end else begin
                    Memory[A_i] = DIA_i;
                 end
              end else begin
                 Memory[A_i] = DIA_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (A_i !== last_A) begin
                     NODELAYA = 1'b1;
                     DOA_tmp = Memory[A_i];
                     ->EventTOHDOA;
                 end else begin
                    if (DIA_i !== last_DIA) begin
                       NODELAYA = 1'b1;
                       DOA_tmp = Memory[A_i];
                       ->EventTOHDOA;
                    end else begin
                       NODELAYA = 1'b0;
                       DOA_tmp = Memory[A_i];
                       DOA_i = DOA_tmp;
                    end
                 end
              end else begin
                  NODELAYA = 1'b1;
                  DOA_tmp = Memory[A_i];
                  ->EventTOHDOA;
              end
           end else begin
                all_core_xA(9999,1);
           end
           LastCycleAAddress = A_i;
        end
        2'b1x: begin
           //DOA_i = {Bits{1'bX}};
           #0 disable TOHDOA;
           NODELAYA = 1'b1;
           DOA_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(A_i)) begin
                Memory[A_i] = {Bits{1'bX}};
                //DOA_i = {Bits{1'bX}};
                #0 disable TOHDOA;
                NODELAYA = 1'b1;
                DOA_i = {Bits{1'bX}};
           end else begin
                all_core_xA(9999,1);
           end
        end
      endcase
      Last_WEAN_i = WEAN_i;
  end
  endtask //memory_functionA;

  task memory_functionB;
    begin
      B_i                            = Latch_B;
      DIB_i                          = Latch_DIB;
      WEBN_i                         = Latch_WEBN;
      CSB_i                          = Latch_CSB;

      if (CSB_ == 1'b1) B_monitor;

      casez({WEBN_i,CSB_i})
        2'b11: begin
           if (AddressRangeCheck(B_i)) begin
              if ((B_i == LastCycleAAddress)&&
                  (Last_WEAN_i == 1'b0) &&
                  ($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOB;
                  NODELAYB = 1'b1;
                  DOB_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                    if (B_i !== last_B) begin
                       NODELAYB = 1'b1;
                       DOB_tmp = Memory[B_i];
                       ->EventTOHDOB;
                    end else begin
                       NODELAYB = 1'b0;
                       DOB_tmp  = Memory[B_i];
                       DOB_i    = DOB_tmp;
                    end
                  end else begin
                    NODELAYB = 1'b1;
                    DOB_tmp = Memory[B_i];
                    ->EventTOHDOB;
                  end
              end
           end
           else begin
                //DOB_i = {Bits{1'bX}};
                #0 disable TOHDOB;
                NODELAYB = 1'b1;
                DOB_i = {Bits{1'bX}};
           end
           LastCycleBAddress = B_i;
        end
        2'b01: begin
           if (AddressRangeCheck(B_i)) begin
              if (B_i == LastCycleAAddress) begin
                 if ((Last_WEAN_i == 1'b1)&&($time-Last_tc_ClkA_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOA;
                    NODELAYA = 1'b1;
                    DOA_i = {Bits{1'bX}};
                    Memory[B_i] = DIB_i;
                 end else if ((Last_WEAN_i == 1'b0)&&($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory[B_i] = {Bits{1'bX}};
                 end else begin
                    Memory[B_i] = DIB_i;
                 end
              end else begin
                 Memory[B_i] = DIB_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (B_i !== last_B) begin
                     NODELAYB = 1'b1;
                     DOB_tmp = Memory[B_i];
                     ->EventTOHDOB;
                 end else begin
                    if (DIB_i !== last_DIB) begin
                       NODELAYB = 1'b1;
                       DOB_tmp = Memory[B_i];
                       ->EventTOHDOB;
                    end else begin
                       NODELAYB = 1'b0;
                       DOB_tmp = Memory[B_i];
                       DOB_i = DOB_tmp;
                    end
                 end
              end else begin
                  NODELAYB = 1'b1;
                  DOB_tmp = Memory[B_i];
                  ->EventTOHDOB;
              end
           end else begin
                all_core_xB(9999,1);
           end
           LastCycleBAddress = B_i;
        end
        2'b1x: begin
           //DOB_i = {Bits{1'bX}};
           #0 disable TOHDOB;
           NODELAYB = 1'b1;
           DOB_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(B_i)) begin
                Memory[B_i] = {Bits{1'bX}};
                //DOB_i = {Bits{1'bX}};
                #0 disable TOHDOB;
                NODELAYB = 1'b1;
                DOB_i = {Bits{1'bX}};
           end else begin
                all_core_xB(9999,1);
           end
        end
      endcase
      Last_WEBN_i = WEBN_i;
  end
  endtask //memory_functionB;

  task all_core_xA;
     input byte_num;
     input do_x;

     integer byte_num;
     integer do_x;
     integer LoopCount_Address;
     begin
       if (do_x == 1) begin
          #0 disable TOHDOA;
          NODELAYA = 1'b1;
          DOA_i = {Bits{1'bX}};
       end
       LoopCount_Address=Words-1;
       while(LoopCount_Address >=0) begin
         Memory[LoopCount_Address]={Bits{1'bX}};
         LoopCount_Address=LoopCount_Address-1;
      end
    end
  endtask //end all_core_xA;

  task all_core_xB;
     input byte_num;
     input do_x;

     integer byte_num;
     integer do_x;
     integer LoopCount_Address;
     begin
       if (do_x == 1) begin
          #0 disable TOHDOB;
          NODELAYB = 1'b1;
          DOB_i = {Bits{1'bX}};
       end
       LoopCount_Address=Words-1;
       while(LoopCount_Address >=0) begin
         Memory[LoopCount_Address]={Bits{1'bX}};
         LoopCount_Address=LoopCount_Address-1;
      end
    end
  endtask //end all_core_xB;

  task A_monitor;
     begin
       if (^(A_) !== 1'bX) begin
          flag_A_x = `FALSE;
       end
       else begin
          if (flag_A_x == `FALSE) begin
              flag_A_x = `TRUE;
              ErrorMessage(2);
          end
       end
     end
  endtask //end A_monitor;

  task B_monitor;
     begin
       if (^(B_) !== 1'bX) begin
          flag_B_x = `FALSE;
       end
       else begin
          if (flag_B_x == `FALSE) begin
              flag_B_x = `TRUE;
              ErrorMessage(2);
          end
       end
     end
  endtask //end B_monitor;

  task CSA_monitor;
     begin
       if (^(CSA_) !== 1'bX) begin
          flag_CSA_x = `FALSE;
       end
       else begin
          if (flag_CSA_x == `FALSE) begin
              flag_CSA_x = `TRUE;
              ErrorMessage(3);
          end
       end
     end
  endtask //end CSA_monitor;

  task CSB_monitor;
     begin
       if (^(CSB_) !== 1'bX) begin
          flag_CSB_x = `FALSE;
       end
       else begin
          if (flag_CSB_x == `FALSE) begin
              flag_CSB_x = `TRUE;
              ErrorMessage(3);
          end
       end
     end
  endtask //end CSB_monitor;

  task ErrorMessage;
     input error_type;
     integer error_type;

     begin
       case (error_type)
         0: $display("** MEM_Error: Abnormal transition occurred (%t) in Clock of %m",$time);
         1: $display("** MEM_Warning: Read and Write the same Address, DO is unknown (%t) in clock of %m",$time);
         2: $display("** MEM_Error: Unknown value occurred (%t) in Address of %m",$time);
         3: $display("** MEM_Error: Unknown value occurred (%t) in ChipSelect of %m",$time);
         4: $display("** MEM_Error: Port A and B write the same Address, core is unknown (%t) in clock of %m",$time);
         5: $display("** MEM_Error: Clear all memory core to unknown (%t) in clock of %m",$time);
       endcase
     end
  endtask

  function AddressRangeCheck;
      input  [AddressSize-1:0] AddressItem;
      reg    UnaryResult;
      begin
        UnaryResult = ^AddressItem;
        if(UnaryResult!==1'bX) begin
           if (AddressItem >= Words) begin
              $display("** MEM_Error: Out of range occurred (%t) in Address of %m",$time);
              AddressRangeCheck = `FALSE;
           end else begin
              AddressRangeCheck = `TRUE;
           end
        end
        else begin
           AddressRangeCheck = `FALSE;
        end
      end
  endfunction //end AddressRangeCheck;

   specify
      specparam TAA  = (131:189:313);
      specparam TRC  = (172:251:410);
      specparam THPW = (57:84:137);
      specparam TLPW = (57:84:137);
      specparam TAS  = (51:80:137);
      specparam TAH  = (9:12:19);
      specparam TWS  = (27:42:69);
      specparam TWH  = (4:7:13);
      specparam TDS  = (6:11:19);
      specparam TDH  = (25:28:34);
      specparam TCSS = (54:82:136);
      specparam TCSH = (0:0:0);
      specparam TOE  = (107:150:233);
      specparam TOZ  = (71:96:147);


      $setuphold ( posedge CKA &&& con_A,         posedge A0, TAS,     TAH,     n_flag_A0      );
      $setuphold ( posedge CKA &&& con_A,         negedge A0, TAS,     TAH,     n_flag_A0      );
      $setuphold ( posedge CKA &&& con_A,         posedge A1, TAS,     TAH,     n_flag_A1      );
      $setuphold ( posedge CKA &&& con_A,         negedge A1, TAS,     TAH,     n_flag_A1      );
      $setuphold ( posedge CKA &&& con_A,         posedge A2, TAS,     TAH,     n_flag_A2      );
      $setuphold ( posedge CKA &&& con_A,         negedge A2, TAS,     TAH,     n_flag_A2      );
      $setuphold ( posedge CKA &&& con_A,         posedge A3, TAS,     TAH,     n_flag_A3      );
      $setuphold ( posedge CKA &&& con_A,         negedge A3, TAS,     TAH,     n_flag_A3      );
      $setuphold ( posedge CKA &&& con_A,         posedge A4, TAS,     TAH,     n_flag_A4      );
      $setuphold ( posedge CKA &&& con_A,         negedge A4, TAS,     TAH,     n_flag_A4      );
      $setuphold ( posedge CKA &&& con_A,         posedge A5, TAS,     TAH,     n_flag_A5      );
      $setuphold ( posedge CKA &&& con_A,         negedge A5, TAS,     TAH,     n_flag_A5      );
      $setuphold ( posedge CKA &&& con_A,         posedge A6, TAS,     TAH,     n_flag_A6      );
      $setuphold ( posedge CKA &&& con_A,         negedge A6, TAS,     TAH,     n_flag_A6      );
      $setuphold ( posedge CKB &&& con_B,         posedge B0, TAS,     TAH,     n_flag_B0      );
      $setuphold ( posedge CKB &&& con_B,         negedge B0, TAS,     TAH,     n_flag_B0      );
      $setuphold ( posedge CKB &&& con_B,         posedge B1, TAS,     TAH,     n_flag_B1      );
      $setuphold ( posedge CKB &&& con_B,         negedge B1, TAS,     TAH,     n_flag_B1      );
      $setuphold ( posedge CKB &&& con_B,         posedge B2, TAS,     TAH,     n_flag_B2      );
      $setuphold ( posedge CKB &&& con_B,         negedge B2, TAS,     TAH,     n_flag_B2      );
      $setuphold ( posedge CKB &&& con_B,         posedge B3, TAS,     TAH,     n_flag_B3      );
      $setuphold ( posedge CKB &&& con_B,         negedge B3, TAS,     TAH,     n_flag_B3      );
      $setuphold ( posedge CKB &&& con_B,         posedge B4, TAS,     TAH,     n_flag_B4      );
      $setuphold ( posedge CKB &&& con_B,         negedge B4, TAS,     TAH,     n_flag_B4      );
      $setuphold ( posedge CKB &&& con_B,         posedge B5, TAS,     TAH,     n_flag_B5      );
      $setuphold ( posedge CKB &&& con_B,         negedge B5, TAS,     TAH,     n_flag_B5      );
      $setuphold ( posedge CKB &&& con_B,         posedge B6, TAS,     TAH,     n_flag_B6      );
      $setuphold ( posedge CKB &&& con_B,         negedge B6, TAS,     TAH,     n_flag_B6      );

      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA0, TDS,     TDH,     n_flag_DIA0    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA0, TDS,     TDH,     n_flag_DIA0    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB0, TDS,     TDH,     n_flag_DIB0    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB0, TDS,     TDH,     n_flag_DIB0    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA1, TDS,     TDH,     n_flag_DIA1    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA1, TDS,     TDH,     n_flag_DIA1    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB1, TDS,     TDH,     n_flag_DIB1    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB1, TDS,     TDH,     n_flag_DIB1    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA2, TDS,     TDH,     n_flag_DIA2    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA2, TDS,     TDH,     n_flag_DIA2    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB2, TDS,     TDH,     n_flag_DIB2    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB2, TDS,     TDH,     n_flag_DIB2    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA3, TDS,     TDH,     n_flag_DIA3    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA3, TDS,     TDH,     n_flag_DIA3    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB3, TDS,     TDH,     n_flag_DIB3    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB3, TDS,     TDH,     n_flag_DIB3    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA4, TDS,     TDH,     n_flag_DIA4    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA4, TDS,     TDH,     n_flag_DIA4    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB4, TDS,     TDH,     n_flag_DIB4    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB4, TDS,     TDH,     n_flag_DIB4    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA5, TDS,     TDH,     n_flag_DIA5    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA5, TDS,     TDH,     n_flag_DIA5    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB5, TDS,     TDH,     n_flag_DIB5    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB5, TDS,     TDH,     n_flag_DIB5    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA6, TDS,     TDH,     n_flag_DIA6    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA6, TDS,     TDH,     n_flag_DIA6    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB6, TDS,     TDH,     n_flag_DIB6    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB6, TDS,     TDH,     n_flag_DIB6    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA7, TDS,     TDH,     n_flag_DIA7    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA7, TDS,     TDH,     n_flag_DIA7    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB7, TDS,     TDH,     n_flag_DIB7    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB7, TDS,     TDH,     n_flag_DIB7    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA8, TDS,     TDH,     n_flag_DIA8    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA8, TDS,     TDH,     n_flag_DIA8    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB8, TDS,     TDH,     n_flag_DIB8    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB8, TDS,     TDH,     n_flag_DIB8    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA9, TDS,     TDH,     n_flag_DIA9    );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA9, TDS,     TDH,     n_flag_DIA9    );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB9, TDS,     TDH,     n_flag_DIB9    );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB9, TDS,     TDH,     n_flag_DIB9    );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA10, TDS,     TDH,     n_flag_DIA10   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA10, TDS,     TDH,     n_flag_DIA10   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB10, TDS,     TDH,     n_flag_DIB10   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB10, TDS,     TDH,     n_flag_DIB10   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA11, TDS,     TDH,     n_flag_DIA11   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA11, TDS,     TDH,     n_flag_DIA11   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB11, TDS,     TDH,     n_flag_DIB11   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB11, TDS,     TDH,     n_flag_DIB11   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA12, TDS,     TDH,     n_flag_DIA12   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA12, TDS,     TDH,     n_flag_DIA12   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB12, TDS,     TDH,     n_flag_DIB12   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB12, TDS,     TDH,     n_flag_DIB12   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA13, TDS,     TDH,     n_flag_DIA13   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA13, TDS,     TDH,     n_flag_DIA13   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB13, TDS,     TDH,     n_flag_DIB13   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB13, TDS,     TDH,     n_flag_DIB13   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA14, TDS,     TDH,     n_flag_DIA14   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA14, TDS,     TDH,     n_flag_DIA14   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB14, TDS,     TDH,     n_flag_DIB14   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB14, TDS,     TDH,     n_flag_DIB14   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA15, TDS,     TDH,     n_flag_DIA15   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA15, TDS,     TDH,     n_flag_DIA15   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB15, TDS,     TDH,     n_flag_DIB15   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB15, TDS,     TDH,     n_flag_DIB15   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA16, TDS,     TDH,     n_flag_DIA16   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA16, TDS,     TDH,     n_flag_DIA16   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB16, TDS,     TDH,     n_flag_DIB16   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB16, TDS,     TDH,     n_flag_DIB16   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA17, TDS,     TDH,     n_flag_DIA17   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA17, TDS,     TDH,     n_flag_DIA17   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB17, TDS,     TDH,     n_flag_DIB17   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB17, TDS,     TDH,     n_flag_DIB17   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA18, TDS,     TDH,     n_flag_DIA18   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA18, TDS,     TDH,     n_flag_DIA18   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB18, TDS,     TDH,     n_flag_DIB18   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB18, TDS,     TDH,     n_flag_DIB18   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA19, TDS,     TDH,     n_flag_DIA19   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA19, TDS,     TDH,     n_flag_DIA19   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB19, TDS,     TDH,     n_flag_DIB19   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB19, TDS,     TDH,     n_flag_DIB19   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA20, TDS,     TDH,     n_flag_DIA20   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA20, TDS,     TDH,     n_flag_DIA20   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB20, TDS,     TDH,     n_flag_DIB20   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB20, TDS,     TDH,     n_flag_DIB20   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA21, TDS,     TDH,     n_flag_DIA21   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA21, TDS,     TDH,     n_flag_DIA21   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB21, TDS,     TDH,     n_flag_DIB21   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB21, TDS,     TDH,     n_flag_DIB21   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA22, TDS,     TDH,     n_flag_DIA22   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA22, TDS,     TDH,     n_flag_DIA22   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB22, TDS,     TDH,     n_flag_DIB22   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB22, TDS,     TDH,     n_flag_DIB22   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA23, TDS,     TDH,     n_flag_DIA23   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA23, TDS,     TDH,     n_flag_DIA23   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB23, TDS,     TDH,     n_flag_DIB23   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB23, TDS,     TDH,     n_flag_DIB23   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA24, TDS,     TDH,     n_flag_DIA24   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA24, TDS,     TDH,     n_flag_DIA24   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB24, TDS,     TDH,     n_flag_DIB24   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB24, TDS,     TDH,     n_flag_DIB24   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA25, TDS,     TDH,     n_flag_DIA25   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA25, TDS,     TDH,     n_flag_DIA25   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB25, TDS,     TDH,     n_flag_DIB25   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB25, TDS,     TDH,     n_flag_DIB25   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA26, TDS,     TDH,     n_flag_DIA26   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA26, TDS,     TDH,     n_flag_DIA26   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB26, TDS,     TDH,     n_flag_DIB26   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB26, TDS,     TDH,     n_flag_DIB26   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA27, TDS,     TDH,     n_flag_DIA27   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA27, TDS,     TDH,     n_flag_DIA27   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB27, TDS,     TDH,     n_flag_DIB27   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB27, TDS,     TDH,     n_flag_DIB27   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA28, TDS,     TDH,     n_flag_DIA28   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA28, TDS,     TDH,     n_flag_DIA28   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB28, TDS,     TDH,     n_flag_DIB28   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB28, TDS,     TDH,     n_flag_DIB28   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA29, TDS,     TDH,     n_flag_DIA29   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA29, TDS,     TDH,     n_flag_DIA29   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB29, TDS,     TDH,     n_flag_DIB29   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB29, TDS,     TDH,     n_flag_DIB29   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA30, TDS,     TDH,     n_flag_DIA30   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA30, TDS,     TDH,     n_flag_DIA30   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB30, TDS,     TDH,     n_flag_DIB30   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB30, TDS,     TDH,     n_flag_DIB30   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA31, TDS,     TDH,     n_flag_DIA31   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA31, TDS,     TDH,     n_flag_DIA31   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB31, TDS,     TDH,     n_flag_DIB31   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB31, TDS,     TDH,     n_flag_DIB31   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA32, TDS,     TDH,     n_flag_DIA32   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA32, TDS,     TDH,     n_flag_DIA32   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB32, TDS,     TDH,     n_flag_DIB32   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB32, TDS,     TDH,     n_flag_DIB32   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA33, TDS,     TDH,     n_flag_DIA33   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA33, TDS,     TDH,     n_flag_DIA33   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB33, TDS,     TDH,     n_flag_DIB33   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB33, TDS,     TDH,     n_flag_DIB33   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA34, TDS,     TDH,     n_flag_DIA34   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA34, TDS,     TDH,     n_flag_DIA34   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB34, TDS,     TDH,     n_flag_DIB34   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB34, TDS,     TDH,     n_flag_DIB34   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA35, TDS,     TDH,     n_flag_DIA35   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA35, TDS,     TDH,     n_flag_DIA35   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB35, TDS,     TDH,     n_flag_DIB35   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB35, TDS,     TDH,     n_flag_DIB35   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA36, TDS,     TDH,     n_flag_DIA36   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA36, TDS,     TDH,     n_flag_DIA36   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB36, TDS,     TDH,     n_flag_DIB36   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB36, TDS,     TDH,     n_flag_DIB36   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA37, TDS,     TDH,     n_flag_DIA37   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA37, TDS,     TDH,     n_flag_DIA37   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB37, TDS,     TDH,     n_flag_DIB37   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB37, TDS,     TDH,     n_flag_DIB37   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA38, TDS,     TDH,     n_flag_DIA38   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA38, TDS,     TDH,     n_flag_DIA38   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB38, TDS,     TDH,     n_flag_DIB38   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB38, TDS,     TDH,     n_flag_DIB38   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA39, TDS,     TDH,     n_flag_DIA39   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA39, TDS,     TDH,     n_flag_DIA39   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB39, TDS,     TDH,     n_flag_DIB39   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB39, TDS,     TDH,     n_flag_DIB39   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA40, TDS,     TDH,     n_flag_DIA40   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA40, TDS,     TDH,     n_flag_DIA40   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB40, TDS,     TDH,     n_flag_DIB40   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB40, TDS,     TDH,     n_flag_DIB40   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA41, TDS,     TDH,     n_flag_DIA41   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA41, TDS,     TDH,     n_flag_DIA41   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB41, TDS,     TDH,     n_flag_DIB41   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB41, TDS,     TDH,     n_flag_DIB41   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA42, TDS,     TDH,     n_flag_DIA42   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA42, TDS,     TDH,     n_flag_DIA42   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB42, TDS,     TDH,     n_flag_DIB42   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB42, TDS,     TDH,     n_flag_DIB42   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA43, TDS,     TDH,     n_flag_DIA43   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA43, TDS,     TDH,     n_flag_DIA43   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB43, TDS,     TDH,     n_flag_DIB43   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB43, TDS,     TDH,     n_flag_DIB43   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA44, TDS,     TDH,     n_flag_DIA44   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA44, TDS,     TDH,     n_flag_DIA44   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB44, TDS,     TDH,     n_flag_DIB44   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB44, TDS,     TDH,     n_flag_DIB44   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA45, TDS,     TDH,     n_flag_DIA45   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA45, TDS,     TDH,     n_flag_DIA45   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB45, TDS,     TDH,     n_flag_DIB45   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB45, TDS,     TDH,     n_flag_DIB45   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA46, TDS,     TDH,     n_flag_DIA46   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA46, TDS,     TDH,     n_flag_DIA46   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB46, TDS,     TDH,     n_flag_DIB46   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB46, TDS,     TDH,     n_flag_DIB46   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA47, TDS,     TDH,     n_flag_DIA47   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA47, TDS,     TDH,     n_flag_DIA47   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB47, TDS,     TDH,     n_flag_DIB47   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB47, TDS,     TDH,     n_flag_DIB47   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA48, TDS,     TDH,     n_flag_DIA48   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA48, TDS,     TDH,     n_flag_DIA48   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB48, TDS,     TDH,     n_flag_DIB48   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB48, TDS,     TDH,     n_flag_DIB48   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA49, TDS,     TDH,     n_flag_DIA49   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA49, TDS,     TDH,     n_flag_DIA49   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB49, TDS,     TDH,     n_flag_DIB49   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB49, TDS,     TDH,     n_flag_DIB49   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA50, TDS,     TDH,     n_flag_DIA50   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA50, TDS,     TDH,     n_flag_DIA50   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB50, TDS,     TDH,     n_flag_DIB50   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB50, TDS,     TDH,     n_flag_DIB50   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA51, TDS,     TDH,     n_flag_DIA51   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA51, TDS,     TDH,     n_flag_DIA51   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB51, TDS,     TDH,     n_flag_DIB51   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB51, TDS,     TDH,     n_flag_DIB51   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA52, TDS,     TDH,     n_flag_DIA52   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA52, TDS,     TDH,     n_flag_DIA52   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB52, TDS,     TDH,     n_flag_DIB52   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB52, TDS,     TDH,     n_flag_DIB52   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA53, TDS,     TDH,     n_flag_DIA53   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA53, TDS,     TDH,     n_flag_DIA53   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB53, TDS,     TDH,     n_flag_DIB53   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB53, TDS,     TDH,     n_flag_DIB53   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA54, TDS,     TDH,     n_flag_DIA54   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA54, TDS,     TDH,     n_flag_DIA54   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB54, TDS,     TDH,     n_flag_DIB54   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB54, TDS,     TDH,     n_flag_DIB54   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA55, TDS,     TDH,     n_flag_DIA55   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA55, TDS,     TDH,     n_flag_DIA55   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB55, TDS,     TDH,     n_flag_DIB55   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB55, TDS,     TDH,     n_flag_DIB55   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA56, TDS,     TDH,     n_flag_DIA56   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA56, TDS,     TDH,     n_flag_DIA56   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB56, TDS,     TDH,     n_flag_DIB56   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB56, TDS,     TDH,     n_flag_DIB56   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA57, TDS,     TDH,     n_flag_DIA57   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA57, TDS,     TDH,     n_flag_DIA57   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB57, TDS,     TDH,     n_flag_DIB57   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB57, TDS,     TDH,     n_flag_DIB57   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA58, TDS,     TDH,     n_flag_DIA58   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA58, TDS,     TDH,     n_flag_DIA58   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB58, TDS,     TDH,     n_flag_DIB58   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB58, TDS,     TDH,     n_flag_DIB58   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA59, TDS,     TDH,     n_flag_DIA59   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA59, TDS,     TDH,     n_flag_DIA59   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB59, TDS,     TDH,     n_flag_DIB59   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB59, TDS,     TDH,     n_flag_DIB59   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA60, TDS,     TDH,     n_flag_DIA60   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA60, TDS,     TDH,     n_flag_DIA60   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB60, TDS,     TDH,     n_flag_DIB60   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB60, TDS,     TDH,     n_flag_DIB60   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA61, TDS,     TDH,     n_flag_DIA61   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA61, TDS,     TDH,     n_flag_DIA61   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB61, TDS,     TDH,     n_flag_DIB61   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB61, TDS,     TDH,     n_flag_DIB61   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA62, TDS,     TDH,     n_flag_DIA62   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA62, TDS,     TDH,     n_flag_DIA62   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB62, TDS,     TDH,     n_flag_DIB62   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB62, TDS,     TDH,     n_flag_DIB62   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA63, TDS,     TDH,     n_flag_DIA63   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA63, TDS,     TDH,     n_flag_DIA63   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB63, TDS,     TDH,     n_flag_DIB63   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB63, TDS,     TDH,     n_flag_DIB63   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA64, TDS,     TDH,     n_flag_DIA64   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA64, TDS,     TDH,     n_flag_DIA64   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB64, TDS,     TDH,     n_flag_DIB64   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB64, TDS,     TDH,     n_flag_DIB64   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA65, TDS,     TDH,     n_flag_DIA65   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA65, TDS,     TDH,     n_flag_DIA65   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB65, TDS,     TDH,     n_flag_DIB65   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB65, TDS,     TDH,     n_flag_DIB65   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA66, TDS,     TDH,     n_flag_DIA66   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA66, TDS,     TDH,     n_flag_DIA66   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB66, TDS,     TDH,     n_flag_DIB66   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB66, TDS,     TDH,     n_flag_DIB66   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA67, TDS,     TDH,     n_flag_DIA67   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA67, TDS,     TDH,     n_flag_DIA67   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB67, TDS,     TDH,     n_flag_DIB67   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB67, TDS,     TDH,     n_flag_DIB67   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA68, TDS,     TDH,     n_flag_DIA68   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA68, TDS,     TDH,     n_flag_DIA68   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB68, TDS,     TDH,     n_flag_DIB68   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB68, TDS,     TDH,     n_flag_DIB68   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA69, TDS,     TDH,     n_flag_DIA69   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA69, TDS,     TDH,     n_flag_DIA69   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB69, TDS,     TDH,     n_flag_DIB69   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB69, TDS,     TDH,     n_flag_DIB69   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA70, TDS,     TDH,     n_flag_DIA70   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA70, TDS,     TDH,     n_flag_DIA70   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB70, TDS,     TDH,     n_flag_DIB70   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB70, TDS,     TDH,     n_flag_DIB70   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA71, TDS,     TDH,     n_flag_DIA71   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA71, TDS,     TDH,     n_flag_DIA71   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB71, TDS,     TDH,     n_flag_DIB71   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB71, TDS,     TDH,     n_flag_DIB71   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA72, TDS,     TDH,     n_flag_DIA72   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA72, TDS,     TDH,     n_flag_DIA72   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB72, TDS,     TDH,     n_flag_DIB72   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB72, TDS,     TDH,     n_flag_DIB72   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA73, TDS,     TDH,     n_flag_DIA73   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA73, TDS,     TDH,     n_flag_DIA73   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB73, TDS,     TDH,     n_flag_DIB73   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB73, TDS,     TDH,     n_flag_DIB73   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA74, TDS,     TDH,     n_flag_DIA74   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA74, TDS,     TDH,     n_flag_DIA74   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB74, TDS,     TDH,     n_flag_DIB74   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB74, TDS,     TDH,     n_flag_DIB74   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA75, TDS,     TDH,     n_flag_DIA75   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA75, TDS,     TDH,     n_flag_DIA75   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB75, TDS,     TDH,     n_flag_DIB75   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB75, TDS,     TDH,     n_flag_DIB75   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA76, TDS,     TDH,     n_flag_DIA76   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA76, TDS,     TDH,     n_flag_DIA76   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB76, TDS,     TDH,     n_flag_DIB76   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB76, TDS,     TDH,     n_flag_DIB76   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA77, TDS,     TDH,     n_flag_DIA77   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA77, TDS,     TDH,     n_flag_DIA77   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB77, TDS,     TDH,     n_flag_DIB77   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB77, TDS,     TDH,     n_flag_DIB77   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA78, TDS,     TDH,     n_flag_DIA78   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA78, TDS,     TDH,     n_flag_DIA78   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB78, TDS,     TDH,     n_flag_DIB78   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB78, TDS,     TDH,     n_flag_DIB78   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA79, TDS,     TDH,     n_flag_DIA79   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA79, TDS,     TDH,     n_flag_DIA79   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB79, TDS,     TDH,     n_flag_DIB79   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB79, TDS,     TDH,     n_flag_DIB79   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA80, TDS,     TDH,     n_flag_DIA80   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA80, TDS,     TDH,     n_flag_DIA80   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB80, TDS,     TDH,     n_flag_DIB80   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB80, TDS,     TDH,     n_flag_DIB80   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA81, TDS,     TDH,     n_flag_DIA81   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA81, TDS,     TDH,     n_flag_DIA81   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB81, TDS,     TDH,     n_flag_DIB81   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB81, TDS,     TDH,     n_flag_DIB81   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA82, TDS,     TDH,     n_flag_DIA82   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA82, TDS,     TDH,     n_flag_DIA82   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB82, TDS,     TDH,     n_flag_DIB82   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB82, TDS,     TDH,     n_flag_DIB82   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA83, TDS,     TDH,     n_flag_DIA83   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA83, TDS,     TDH,     n_flag_DIA83   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB83, TDS,     TDH,     n_flag_DIB83   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB83, TDS,     TDH,     n_flag_DIB83   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA84, TDS,     TDH,     n_flag_DIA84   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA84, TDS,     TDH,     n_flag_DIA84   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB84, TDS,     TDH,     n_flag_DIB84   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB84, TDS,     TDH,     n_flag_DIB84   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA85, TDS,     TDH,     n_flag_DIA85   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA85, TDS,     TDH,     n_flag_DIA85   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB85, TDS,     TDH,     n_flag_DIB85   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB85, TDS,     TDH,     n_flag_DIB85   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA86, TDS,     TDH,     n_flag_DIA86   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA86, TDS,     TDH,     n_flag_DIA86   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB86, TDS,     TDH,     n_flag_DIB86   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB86, TDS,     TDH,     n_flag_DIB86   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA87, TDS,     TDH,     n_flag_DIA87   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA87, TDS,     TDH,     n_flag_DIA87   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB87, TDS,     TDH,     n_flag_DIB87   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB87, TDS,     TDH,     n_flag_DIB87   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA88, TDS,     TDH,     n_flag_DIA88   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA88, TDS,     TDH,     n_flag_DIA88   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB88, TDS,     TDH,     n_flag_DIB88   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB88, TDS,     TDH,     n_flag_DIB88   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA89, TDS,     TDH,     n_flag_DIA89   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA89, TDS,     TDH,     n_flag_DIA89   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB89, TDS,     TDH,     n_flag_DIB89   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB89, TDS,     TDH,     n_flag_DIB89   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA90, TDS,     TDH,     n_flag_DIA90   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA90, TDS,     TDH,     n_flag_DIA90   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB90, TDS,     TDH,     n_flag_DIB90   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB90, TDS,     TDH,     n_flag_DIB90   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA91, TDS,     TDH,     n_flag_DIA91   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA91, TDS,     TDH,     n_flag_DIA91   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB91, TDS,     TDH,     n_flag_DIB91   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB91, TDS,     TDH,     n_flag_DIB91   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA92, TDS,     TDH,     n_flag_DIA92   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA92, TDS,     TDH,     n_flag_DIA92   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB92, TDS,     TDH,     n_flag_DIB92   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB92, TDS,     TDH,     n_flag_DIB92   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA93, TDS,     TDH,     n_flag_DIA93   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA93, TDS,     TDH,     n_flag_DIA93   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB93, TDS,     TDH,     n_flag_DIB93   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB93, TDS,     TDH,     n_flag_DIB93   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA94, TDS,     TDH,     n_flag_DIA94   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA94, TDS,     TDH,     n_flag_DIA94   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB94, TDS,     TDH,     n_flag_DIB94   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB94, TDS,     TDH,     n_flag_DIB94   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA95, TDS,     TDH,     n_flag_DIA95   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA95, TDS,     TDH,     n_flag_DIA95   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB95, TDS,     TDH,     n_flag_DIB95   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB95, TDS,     TDH,     n_flag_DIB95   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA96, TDS,     TDH,     n_flag_DIA96   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA96, TDS,     TDH,     n_flag_DIA96   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB96, TDS,     TDH,     n_flag_DIB96   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB96, TDS,     TDH,     n_flag_DIB96   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA97, TDS,     TDH,     n_flag_DIA97   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA97, TDS,     TDH,     n_flag_DIA97   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB97, TDS,     TDH,     n_flag_DIB97   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB97, TDS,     TDH,     n_flag_DIB97   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA98, TDS,     TDH,     n_flag_DIA98   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA98, TDS,     TDH,     n_flag_DIA98   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB98, TDS,     TDH,     n_flag_DIB98   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB98, TDS,     TDH,     n_flag_DIB98   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA99, TDS,     TDH,     n_flag_DIA99   );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA99, TDS,     TDH,     n_flag_DIA99   );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB99, TDS,     TDH,     n_flag_DIB99   );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB99, TDS,     TDH,     n_flag_DIB99   );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA100, TDS,     TDH,     n_flag_DIA100  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA100, TDS,     TDH,     n_flag_DIA100  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB100, TDS,     TDH,     n_flag_DIB100  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB100, TDS,     TDH,     n_flag_DIB100  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA101, TDS,     TDH,     n_flag_DIA101  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA101, TDS,     TDH,     n_flag_DIA101  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB101, TDS,     TDH,     n_flag_DIB101  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB101, TDS,     TDH,     n_flag_DIB101  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA102, TDS,     TDH,     n_flag_DIA102  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA102, TDS,     TDH,     n_flag_DIA102  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB102, TDS,     TDH,     n_flag_DIB102  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB102, TDS,     TDH,     n_flag_DIB102  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA103, TDS,     TDH,     n_flag_DIA103  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA103, TDS,     TDH,     n_flag_DIA103  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB103, TDS,     TDH,     n_flag_DIB103  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB103, TDS,     TDH,     n_flag_DIB103  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA104, TDS,     TDH,     n_flag_DIA104  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA104, TDS,     TDH,     n_flag_DIA104  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB104, TDS,     TDH,     n_flag_DIB104  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB104, TDS,     TDH,     n_flag_DIB104  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA105, TDS,     TDH,     n_flag_DIA105  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA105, TDS,     TDH,     n_flag_DIA105  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB105, TDS,     TDH,     n_flag_DIB105  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB105, TDS,     TDH,     n_flag_DIB105  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA106, TDS,     TDH,     n_flag_DIA106  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA106, TDS,     TDH,     n_flag_DIA106  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB106, TDS,     TDH,     n_flag_DIB106  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB106, TDS,     TDH,     n_flag_DIB106  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA107, TDS,     TDH,     n_flag_DIA107  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA107, TDS,     TDH,     n_flag_DIA107  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB107, TDS,     TDH,     n_flag_DIB107  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB107, TDS,     TDH,     n_flag_DIB107  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA108, TDS,     TDH,     n_flag_DIA108  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA108, TDS,     TDH,     n_flag_DIA108  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB108, TDS,     TDH,     n_flag_DIB108  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB108, TDS,     TDH,     n_flag_DIB108  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA109, TDS,     TDH,     n_flag_DIA109  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA109, TDS,     TDH,     n_flag_DIA109  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB109, TDS,     TDH,     n_flag_DIB109  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB109, TDS,     TDH,     n_flag_DIB109  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA110, TDS,     TDH,     n_flag_DIA110  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA110, TDS,     TDH,     n_flag_DIA110  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB110, TDS,     TDH,     n_flag_DIB110  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB110, TDS,     TDH,     n_flag_DIB110  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA111, TDS,     TDH,     n_flag_DIA111  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA111, TDS,     TDH,     n_flag_DIA111  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB111, TDS,     TDH,     n_flag_DIB111  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB111, TDS,     TDH,     n_flag_DIB111  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA112, TDS,     TDH,     n_flag_DIA112  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA112, TDS,     TDH,     n_flag_DIA112  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB112, TDS,     TDH,     n_flag_DIB112  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB112, TDS,     TDH,     n_flag_DIB112  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA113, TDS,     TDH,     n_flag_DIA113  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA113, TDS,     TDH,     n_flag_DIA113  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB113, TDS,     TDH,     n_flag_DIB113  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB113, TDS,     TDH,     n_flag_DIB113  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA114, TDS,     TDH,     n_flag_DIA114  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA114, TDS,     TDH,     n_flag_DIA114  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB114, TDS,     TDH,     n_flag_DIB114  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB114, TDS,     TDH,     n_flag_DIB114  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA115, TDS,     TDH,     n_flag_DIA115  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA115, TDS,     TDH,     n_flag_DIA115  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB115, TDS,     TDH,     n_flag_DIB115  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB115, TDS,     TDH,     n_flag_DIB115  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA116, TDS,     TDH,     n_flag_DIA116  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA116, TDS,     TDH,     n_flag_DIA116  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB116, TDS,     TDH,     n_flag_DIB116  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB116, TDS,     TDH,     n_flag_DIB116  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA117, TDS,     TDH,     n_flag_DIA117  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA117, TDS,     TDH,     n_flag_DIA117  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB117, TDS,     TDH,     n_flag_DIB117  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB117, TDS,     TDH,     n_flag_DIB117  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA118, TDS,     TDH,     n_flag_DIA118  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA118, TDS,     TDH,     n_flag_DIA118  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB118, TDS,     TDH,     n_flag_DIB118  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB118, TDS,     TDH,     n_flag_DIB118  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA119, TDS,     TDH,     n_flag_DIA119  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA119, TDS,     TDH,     n_flag_DIA119  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB119, TDS,     TDH,     n_flag_DIB119  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB119, TDS,     TDH,     n_flag_DIB119  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA120, TDS,     TDH,     n_flag_DIA120  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA120, TDS,     TDH,     n_flag_DIA120  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB120, TDS,     TDH,     n_flag_DIB120  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB120, TDS,     TDH,     n_flag_DIB120  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA121, TDS,     TDH,     n_flag_DIA121  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA121, TDS,     TDH,     n_flag_DIA121  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB121, TDS,     TDH,     n_flag_DIB121  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB121, TDS,     TDH,     n_flag_DIB121  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA122, TDS,     TDH,     n_flag_DIA122  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA122, TDS,     TDH,     n_flag_DIA122  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB122, TDS,     TDH,     n_flag_DIB122  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB122, TDS,     TDH,     n_flag_DIB122  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA123, TDS,     TDH,     n_flag_DIA123  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA123, TDS,     TDH,     n_flag_DIA123  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB123, TDS,     TDH,     n_flag_DIB123  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB123, TDS,     TDH,     n_flag_DIB123  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA124, TDS,     TDH,     n_flag_DIA124  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA124, TDS,     TDH,     n_flag_DIA124  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB124, TDS,     TDH,     n_flag_DIB124  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB124, TDS,     TDH,     n_flag_DIB124  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA125, TDS,     TDH,     n_flag_DIA125  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA125, TDS,     TDH,     n_flag_DIA125  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB125, TDS,     TDH,     n_flag_DIB125  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB125, TDS,     TDH,     n_flag_DIB125  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA126, TDS,     TDH,     n_flag_DIA126  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA126, TDS,     TDH,     n_flag_DIA126  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB126, TDS,     TDH,     n_flag_DIB126  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB126, TDS,     TDH,     n_flag_DIB126  );
      $setuphold ( posedge CKA &&& con_DIA,       posedge DIA127, TDS,     TDH,     n_flag_DIA127  );
      $setuphold ( posedge CKA &&& con_DIA,       negedge DIA127, TDS,     TDH,     n_flag_DIA127  );
      $setuphold ( posedge CKB &&& con_DIB,       posedge DIB127, TDS,     TDH,     n_flag_DIB127  );
      $setuphold ( posedge CKB &&& con_DIB,       negedge DIB127, TDS,     TDH,     n_flag_DIB127  );

      $setuphold ( posedge CKA &&& con_WEAN,      posedge WEAN, TWS,     TWH,     n_flag_WEAN    );
      $setuphold ( posedge CKA &&& con_WEAN,      negedge WEAN, TWS,     TWH,     n_flag_WEAN    );
      $setuphold ( posedge CKB &&& con_WEBN,      posedge WEBN, TWS,     TWH,     n_flag_WEBN    );
      $setuphold ( posedge CKB &&& con_WEBN,      negedge WEBN, TWS,     TWH,     n_flag_WEBN    );
      $setuphold ( posedge CKA,                   posedge CSA, TCSS,    TCSH,    n_flag_CSA     );
      $setuphold ( posedge CKA,                   negedge CSA, TCSS,    TCSH,    n_flag_CSA     );
      $setuphold ( posedge CKB,                   posedge CSB, TCSS,    TCSH,    n_flag_CSB     );
      $setuphold ( posedge CKB,                   negedge CSB, TCSS,    TCSH,    n_flag_CSB     );
      $period    ( posedge CKA &&& con_CKA,       TRC,                       n_flag_CKA_PER );
      $width     ( posedge CKA &&& con_CKA,       THPW,    0,                n_flag_CKA_MINH);
      $width     ( negedge CKA &&& con_CKA,       TLPW,    0,                n_flag_CKA_MINL);
      $period    ( posedge CKB &&& con_CKB,       TRC,                       n_flag_CKB_PER );
      $width     ( posedge CKB &&& con_CKB,       THPW,    0,                n_flag_CKB_MINH);
      $width     ( negedge CKB &&& con_CKB,       TLPW,    0,                n_flag_CKB_MINL);

      if (NODELAYA == 0)  (posedge CKA => (DOA0 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB0 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA1 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB1 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA2 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB2 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA3 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB3 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA4 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB4 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA5 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB5 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA6 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB6 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA7 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB7 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA8 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB8 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA9 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB9 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA10 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB10 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA11 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB11 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA12 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB12 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA13 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB13 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA14 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB14 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA15 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB15 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA16 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB16 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA17 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB17 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA18 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB18 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA19 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB19 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA20 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB20 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA21 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB21 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA22 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB22 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA23 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB23 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA24 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB24 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA25 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB25 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA26 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB26 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA27 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB27 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA28 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB28 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA29 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB29 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA30 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB30 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA31 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB31 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA32 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB32 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA33 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB33 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA34 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB34 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA35 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB35 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA36 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB36 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA37 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB37 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA38 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB38 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA39 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB39 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA40 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB40 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA41 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB41 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA42 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB42 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA43 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB43 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA44 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB44 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA45 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB45 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA46 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB46 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA47 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB47 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA48 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB48 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA49 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB49 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA50 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB50 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA51 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB51 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA52 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB52 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA53 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB53 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA54 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB54 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA55 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB55 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA56 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB56 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA57 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB57 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA58 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB58 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA59 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB59 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA60 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB60 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA61 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB61 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA62 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB62 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA63 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB63 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA64 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB64 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA65 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB65 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA66 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB66 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA67 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB67 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA68 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB68 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA69 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB69 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA70 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB70 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA71 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB71 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA72 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB72 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA73 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB73 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA74 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB74 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA75 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB75 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA76 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB76 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA77 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB77 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA78 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB78 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA79 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB79 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA80 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB80 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA81 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB81 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA82 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB82 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA83 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB83 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA84 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB84 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA85 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB85 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA86 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB86 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA87 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB87 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA88 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB88 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA89 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB89 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA90 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB90 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA91 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB91 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA92 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB92 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA93 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB93 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA94 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB94 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA95 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB95 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA96 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB96 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA97 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB97 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA98 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB98 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA99 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB99 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA100 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB100 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA101 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB101 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA102 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB102 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA103 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB103 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA104 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB104 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA105 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB105 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA106 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB106 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA107 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB107 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA108 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB108 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA109 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB109 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA110 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB110 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA111 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB111 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA112 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB112 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA113 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB113 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA114 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB114 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA115 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB115 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA116 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB116 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA117 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB117 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA118 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB118 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA119 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB119 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA120 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB120 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA121 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB121 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA122 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB122 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA123 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB123 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA124 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB124 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA125 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB125 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA126 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB126 :1'bx)) = TAA  ;
      if (NODELAYA == 0)  (posedge CKA => (DOA127 :1'bx)) = TAA  ;
      if (NODELAYB == 0)  (posedge CKB => (DOB127 :1'bx)) = TAA  ;


      (OEA => DOA0) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB0) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA1) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB1) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA2) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB2) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA3) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB3) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA4) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB4) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA5) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB5) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA6) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB6) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA7) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB7) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA8) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB8) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA9) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB9) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA10) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB10) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA11) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB11) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA12) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB12) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA13) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB13) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA14) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB14) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA15) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB15) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA16) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB16) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA17) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB17) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA18) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB18) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA19) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB19) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA20) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB20) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA21) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB21) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA22) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB22) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA23) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB23) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA24) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB24) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA25) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB25) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA26) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB26) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA27) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB27) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA28) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB28) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA29) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB29) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA30) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB30) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA31) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB31) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA32) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB32) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA33) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB33) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA34) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB34) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA35) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB35) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA36) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB36) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA37) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB37) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA38) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB38) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA39) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB39) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA40) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB40) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA41) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB41) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA42) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB42) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA43) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB43) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA44) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB44) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA45) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB45) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA46) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB46) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA47) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB47) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA48) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB48) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA49) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB49) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA50) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB50) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA51) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB51) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA52) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB52) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA53) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB53) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA54) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB54) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA55) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB55) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA56) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB56) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA57) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB57) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA58) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB58) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA59) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB59) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA60) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB60) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA61) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB61) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA62) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB62) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA63) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB63) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA64) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB64) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA65) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB65) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA66) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB66) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA67) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB67) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA68) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB68) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA69) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB69) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA70) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB70) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA71) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB71) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA72) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB72) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA73) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB73) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA74) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB74) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA75) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB75) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA76) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB76) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA77) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB77) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA78) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB78) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA79) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB79) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA80) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB80) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA81) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB81) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA82) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB82) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA83) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB83) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA84) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB84) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA85) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB85) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA86) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB86) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA87) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB87) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA88) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB88) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA89) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB89) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA90) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB90) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA91) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB91) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA92) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB92) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA93) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB93) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA94) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB94) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA95) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB95) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA96) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB96) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA97) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB97) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA98) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB98) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA99) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB99) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA100) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB100) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA101) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB101) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA102) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB102) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA103) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB103) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA104) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB104) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA105) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB105) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA106) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB106) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA107) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB107) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA108) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB108) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA109) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB109) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA110) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB110) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA111) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB111) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA112) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB112) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA113) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB113) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA114) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB114) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA115) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB115) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA116) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB116) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA117) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB117) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA118) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB118) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA119) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB119) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA120) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB120) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA121) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB121) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA122) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB122) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA123) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB123) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA124) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB124) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA125) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB125) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA126) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB126) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA127) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB127) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
   endspecify

`endprotect
endmodule
