module CC(
    //Input Port
    clk,
    rst_n,
	in_valid,
	mode,
    xi,
    yi,

    //Output Port
    out_valid,
	xo,
	yo
    );

input               clk, rst_n, in_valid;
input       [1:0]   mode;
input       [7:0]   xi, yi;  

output reg          out_valid;
output reg  signed [7:0]   xo, yo;
//==============================================//
//             Parameter and Integer            //
//==============================================//
parameter   IDLE    = 'd0,
            INPUT   = 'd1,
            COMP    = 'd2,
            OUTPUT  = 'd3;
integer     i,j;
integer     ctr;

reg [2:0] next_state, curr_state;

wire CS_IDLE   = (curr_state == IDLE );
wire NS_INPUT  = (next_state == INPUT&&curr_state!=INPUT);
wire CS_INPUT  = (curr_state == INPUT);

wire CS_COMP  =  (curr_state == COMP);
wire NS_COMP  =  (next_state == COMP&&curr_state!=COMP);

wire CS_OUTPUT = (curr_state == OUTPUT);
wire NS_OUTPUT = (next_state == OUTPUT&&curr_state!=OUTPUT);
 
wire is_trapezoid_mode=   (mode==2'b00);
wire is_circle_line_mode= (mode==2'b01);
wire is_area_mode=        (mode==2'b10);

reg [15:0] Fraction_0,Fraction_1;
wire [7:0] Dy0,Dy1,Dy2,Dy3,Dx0,Dx1,Dx2,Dx3;
reg signed [15:0] Dhold[0:3];
reg signed [7:0] Edge_pairs0[0:1][0:20],Edge_pairs1[0:1][0:20],Edge_pairs2[0:1][0:20],Edge_pairs3[0:1][0:20];

genvar idx,jdx;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) curr_state <= IDLE;
    else       curr_state <= next_state;
end
//==============================================//
//              Next State Block                //
//==============================================//
always @(*) begin //next_state
    case(curr_state)
        IDLE:
            if(in_valid)                          next_state = INPUT;
            else                                  next_state = curr_state;
        INPUT:
            if(!in_valid)                         next_state = COMP;
            else                                  next_state = INPUT;
        COMP:
            if     (is_trapezoid_mode&&ctr==18)   next_state = OUTPUT;
            else if(is_circle_line_mode&&ctr==5)  next_state = OUTPUT;
            else if(is_area_mode&&ctr==18)        next_state = OUTPUT;
            else                                  next_state = COMP;
        OUTPUT: 
            if     (is_trapezoid_mode&&ctr==161)    next_state = IDLE;
            else if(is_circle_line_mode&&ctr==5)  next_state = IDLE;
            else if(is_area_mode&&ctr==5)         next_state = IDLE;
            else                                  next_state = OUTPUT;
           
        default:                                  next_state = curr_state;
    endcase
end
always @(posedge clk or negedge rst_n) begin//ctr
	if(!rst_n) begin
		ctr <= 0;
	end
	else begin
		case(curr_state)
			INPUT: begin
				if(in_valid==0&&ctr==4) begin
					ctr<= 0;
				end
				else if(next_state==COMP) begin
					ctr <= 0;
				end
				else begin
					ctr <= ctr+1;
				end
			end 
			COMP: begin
				if(next_state==OUTPUT) begin
					ctr <= 0;
				end
				else begin
					ctr <= ctr+1;
				end
			end
			OUTPUT: begin
        if(next_state==IDLE) begin
				ctr<=0;
        end else begin 
          ctr<=ctr+1;
        end
			end
		default: ctr <= 0;
		endcase
	end
	end
//==============================================//
//                  Input Block                 //
//==============================================//
  reg [7:0] A [0:1];
  reg signed [7:0]  B [0:1];
  reg signed [7:0]C [0:1],D [0:1];
  wire [7:0] DY0,DY1,DY2,DY3,DX0,DX1,DX2,DX3,DX4,DY4;
  assign Dx_AB=(B[0]>A[0])?(B[0]-A[0]):(A[0]-B[0]);
  assign Dx_CD=(D[0]>C[0])?(D[0]-C[0]):(C[0]-D[0]);
  assign Dx_DA= (A[0]>D[0])?(A[0]-D[0]):(D[0]-A[0]);
  assign Dx_BC=(C[0]>B[0])?(C[0]-B[0]):(B[0]-C[0]);
  assign Dx_AC=(C[0]>A[0])?(C[0]-A[0]):(A[0]-C[0]);
  assign Dy_AB=(B[1]>A[1])?(B[1]-A[1]):(A[1]-B[1]);
  assign Dy_CD=(D[1]>C[1])?(D[1]-C[1]):(C[1]-D[1]);
  assign Dy_BC=(C[1]>B[1])?(C[1]-B[1]):(B[1]-C[1]);
  assign Dy_DA=(A[1]>D[1])?(A[1]-D[1]):(D[1]-A[1]);
  assign Dy_AC=(C[1]>A[1])?(C[1]-A[1]):(A[1]-C[1]);

  wire isparallel_AB_CD=((B[1]-A[1])/(B[0]-A[0]))==((D[1]-C[1])/(D[0]-C[0]));//parallel means ACBD
  wire isparallel_BC_DA=((C[1]-B[1])/(C[0]-B[0]))==((A[1]-D[1])/(A[0]-D[0]));//if true then operate on abcd
  // wire isparallel_AC_BD=((C[1]-A[1])/(C[0]-A[0]))==((B[1]-D[1])/(B[0]-D[0]));//if true then operate on abcd

  wire [1:0]Plot_line_AB=(Dx_AB>Dy_AB)?(A[0]>B[0]?1:0):(A[1]>B[1]?2:3);
  wire [1:0]Plot_line_CD=(Dx_CD>Dy_CD)?(C[0]>D[0]?1:0):(C[1]>D[1]?2:3);
  wire [1:0]Plot_line_DA=(Dx_DA>Dy_DA)?(D[0]>A[0]?1:0):(D[1]>A[1]?2:3);
  wire [1:0]Plot_line_BC=(Dx_BC>Dy_BC)?(B[0]>C[0]?1:0):(B[1]>C[1]?2:3);



  DYDX DYDX0(.x0(A[0]),.x1(B[0]),.y0(A[1]),.y1(B[1]),.dx(DX0),.dy(DY0));
  DYDX DYDX1(.x0(C[0]),.x1(D[0]),.y0(C[1]),.y1(D[1]),.dx(DX1),.dy(DY1));
  DYDX DYDX2(.x0(D[0]),.x1(B[0]),.y0(D[1]),.y1(B[1]),.dx(DX3),.dy(DY3));
  DYDX DYDX3(.x0(C[0]),.x1(A[0]),.y0(C[1]),.y1(A[1]),.dx(DX2),.dy(DY2));

generate //input ABCD
    for(idx=0;idx<2;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        A[idx]<=0;
        B[idx]<=0;
        C[idx]<=0;
        D[idx]<=0;
    end else begin 
        if(NS_INPUT&&ctr==0) begin
            A[0]<=xi;
            A[1]<=yi;
        end else if(CS_INPUT&&ctr==0) begin
            B[0]<=xi;
            B[1]<=yi;
        end else if(CS_INPUT&&ctr==1) begin
            C[0]<=xi;
            C[1]<=yi;
        end else if(CS_INPUT&&ctr==2) begin
            D[0]<=xi;
            D[1]<=yi;
        end else begin 
            A[idx]<=A[idx];
            B[idx]<=B[idx];
            C[idx]<=C[idx];
            D[idx]<=D[idx];
        end
        end
    end 
endgenerate
//xompute and fill the edge pairs
wire dx_0,dx_1,dx_2,dx_3,dy_0,dy_1,dy_2,dy_3;//follows <0
wire signed [0:1] xi_0,xi_1,xi_2,xi_3,yi_0,yi_1,yi_2,yi_3;
assign dx_0 =(DX0<0)?1:0;
assign xi_0 =(dx_0)?-1:1;
assign dy_0 =(DY0<0)?1:0;
assign yi_0 =(dy_0)?-1:1;
assign dx_1 =(DX1<0)?1:0;
assign xi_1 =(dx_1)?-1:1;
assign dy_1 =(DY1<0)?1:0;
assign yi_1 =(dy_1)?-1:1;
assign dx_2 =(DX2<0)?1:0;
assign xi_2 =(dx_2)?-1:1;
assign dy_2 =(DY2<0)?1:0;
assign yi_2 =(dy_2)?-1:1;
assign dx_3 =((D[0]-B[0])<0)?1:0;
assign xi_3 =(dx_3)?-1:1;
assign dy_3 =((D[1]-B[1])<0)?1:0;//(D[0]-B[0])
assign yi_3 =(dy_3)?-1:1;

generate //Dhold[0]
    for(idx=0;idx<4;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Dhold[0]=0;
    end else begin 
        if(CS_COMP&&ctr==0) begin//abcd
            Dhold[0]<=2*((dy_0)?(-DY0):DY0)-DX0;//AB
        end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[0]>0)begin 
                Dhold[0]<=Dhold[0]-2*DX0;
            end else begin 
                Dhold[0]<=Dhold[0]+2*DY0;
            end
        end else begin 
            Dhold[0]<=Dhold[0];
        end
        end
    end
endgenerate
generate//Dhold[1] 
    for(idx=0;idx<4;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Dhold[1]=0;
    end else begin 
        if(CS_COMP&&ctr==0) begin//abcd
            Dhold[1]<=2*((dy_1)?(-DY1):DY1)-DX1;//AB
        end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[1]>0)begin 
                Dhold[1]<=Dhold[1]-2*DX1;
            end else begin 
                Dhold[1]<=Dhold[1]+2*DY1;
            end
        end else begin 
            Dhold[1]<=Dhold[1];
        end
        end
    end
endgenerate
generate//Dhold[2] 
    for(idx=0;idx<4;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Dhold[2]=0;
    end else begin 
        if(CS_COMP&&ctr==0) begin//abcd
            Dhold[2]<=2*((dx_2)?(-DX2):DX2)-DY2;//AC
        end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[2]>0)begin 
                Dhold[2]<=Dhold[2]-2*((A[1]-C[1])-(A[0]-C[0]));
            end else if (Dhold[2]==0)begin 
                Dhold[2]<=Dhold[2]+2*(A[0]-C[0]);
            end else begin
                Dhold[2]<=Dhold[2]+2*(A[0]-C[0]);
            end
        end else begin 
            Dhold[2]<=Dhold[2];
        end
        end
    end
endgenerate
generate//Dhold[3] 
    for(idx=0;idx<4;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Dhold[3]<=0;
    end else begin 
        if(CS_COMP&&ctr==0) begin//abcd
            Dhold[3]<=2*((dx_3)?(-DX3):DX3)-DY3;//AC
        end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[3]>=0)begin 
                Dhold[3]<=Dhold[3]-2*(DY3-DX3);//D[0]),.x1(B[0]),.y0(D[1]),.y1(B[1])
            end else begin 
                Dhold[3]<=Dhold[3]+2*(D[0]-B[0]);
            end
        end else begin 
            Dhold[3]<=Dhold[3];
        end
        end
    end
endgenerate
generate //Edge_pairs0
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs0[idx][jdx]<=0;
        Edge_pairs1[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs0[0][0]<=A[0];
            Edge_pairs0[1][0]<=A[1];
            // Edge_pairs1[0][0]<=C[0];
            // Edge_pairs1[0][1]<=C[1];
            // Edge_pairs1[1][0]<=D[0];
            // Edge_pairs1[1][1]<=D[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
            if(Dhold[0]>0)begin 
                Edge_pairs0[0][ctr]<=Edge_pairs0[0][ctr-1]+1;
                Edge_pairs0[1][ctr]<=Edge_pairs0[1][ctr-1]+yi_0;
            end else begin 
                Edge_pairs0[0][ctr]<=Edge_pairs0[0][ctr-1]+1;
                Edge_pairs0[1][ctr]<=Edge_pairs0[1][ctr-1];
            end
        end else begin 
            Edge_pairs0[idx][jdx]<=Edge_pairs0[idx][jdx];
            Edge_pairs1[idx][jdx]<=Edge_pairs1[idx][jdx];
        end
        end
    end
endgenerate
generate //Edge_pairs1
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs1[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs1[0][0]<=C[0];
            Edge_pairs1[1][0]<=C[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
            if(Dhold[1]>0)begin 
                Edge_pairs1[0][ctr]<=Edge_pairs1[0][ctr-1]+1;
                Edge_pairs1[1][ctr]<=Edge_pairs1[1][ctr-1]+yi_1;
            end else begin 
                Edge_pairs1[0][ctr]<=Edge_pairs1[0][ctr-1]+1;
                Edge_pairs1[1][ctr]<=Edge_pairs1[1][ctr-1];
            end
        end else begin 
            Edge_pairs1[idx][jdx]<=Edge_pairs1[idx][jdx];
        end
        end
    end
endgenerate

wire [9:0] m=((Edge_pairs2[1][ctr-1]+1)-C[0]);//denominateur
wire signed [9:0] mmm=(Edge_pairs2[1][ctr-1]+1)-C[0];
wire [9:0] Reference= (A[1]-C[1])/(A[0]-C[0]);

generate //Edge_pairs2
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs2[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs2[0][0]<=C[0];
            Edge_pairs2[1][0]<=C[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
            //m=A[1]-C[0]/A[0]-C[0];

             if(mmm==Reference||mmm==2*Reference)
             begin 
                Edge_pairs2[0][ctr]<=Edge_pairs2[0][ctr-1]+1;
                Edge_pairs2[1][ctr]<=Edge_pairs2[1][ctr-1]+1;
             end else begin 
                Edge_pairs2[0][ctr]<=Edge_pairs2[0][ctr-1];
                Edge_pairs2[1][ctr]<=Edge_pairs2[1][ctr-1]+1;
             end
        end else begin 
            Edge_pairs2[idx][jdx]<=Edge_pairs2[idx][jdx];
        end
        end
    end
endgenerate
generate //Edge_pairs3
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs3[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs3[0][0]<=D[0]-1;
            Edge_pairs3[1][0]<=D[1];
         end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[3]>=0)begin 
                Edge_pairs3[0][ctr]<=Edge_pairs3[0][ctr-1]+(((D[0]-B[0])>0)?-1:1);
                Edge_pairs3[1][ctr]<=Edge_pairs3[1][ctr-1]+1;
            end else begin 
                Edge_pairs3[0][ctr]<=Edge_pairs3[0][ctr-1];
                Edge_pairs3[1][ctr]<=Edge_pairs3[1][ctr-1]+1;
            end
        end else begin 
            Edge_pairs3[idx][jdx]<=Edge_pairs3[idx][jdx];
        end
    end
    end
endgenerate


always@(*) begin//Fraction_1
    if(!rst_n) 
        Fraction_0=0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
       case (m)
            2: Fraction_0 = 16'b0100000000000000;
            3: Fraction_0 = 16'b0010101010101010;
            4: Fraction_0 = 16'b0010000000000000;
            5: Fraction_0 = 16'b0001100110011001;
            6: Fraction_0 = 16'b0001010101010101;
            7: Fraction_0 = 16'b0001000000000000;
            8: Fraction_0 = 16'b0000110011001100;
            9: Fraction_0 = 16'b0000101010101010;
            10: Fraction_0 = 16'b0000100000000000;
            11: Fraction_0 = 16'b0000011001100110;
            12: Fraction_0 = 16'b0000010101010101;
            13: Fraction_0 = 16'b0000010000000000;
            14: Fraction_0 = 16'b0000001100110011;
            15: Fraction_0 = 16'b0000001010101010;
            16: Fraction_0 = 16'b0000001000000000;
            17: Fraction_0 = 16'b0000000110011001;
            18: Fraction_0 = 16'b0000000101010101;
            19: Fraction_0 = 16'b0000000100000000;
            20: Fraction_0 = 16'b0000000011001100;
            default: Fraction_0 = 16'b0000000000000000;
       endcase
    end
    else begin
        Fraction_0 = 0;
    end
end
always@(*) begin//Fraction_1
    if(!rst_n) 
        Fraction_1 =0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
       case (m)
             2: Fraction_1  = 16'b0100000000000000;
            3: Fraction_1  =  16'b0010101010101010;
            4: Fraction_1  =  16'b0010000000000000;
            5: Fraction_1  =  16'b0001100110011001;
            6: Fraction_1  =  16'b0001010101010101;
            7: Fraction_1  =  16'b0001000000000000;
            8: Fraction_1  =  16'b0000110011001100;
            9: Fraction_1  =  16'b0000101010101010;
            10: Fraction_1  = 16'b0000100000000000;
            11: Fraction_1  = 16'b0000011001100110;
            12: Fraction_1  = 16'b0000010101010101;
            13: Fraction_1  = 16'b0000010000000000;
            14: Fraction_1  = 16'b0000001100110011;
            15: Fraction_1  = 16'b0000001010101010;
            16: Fraction_1  = 16'b0000001000000000;
            17: Fraction_1  = 16'b0000000110011001;
            18: Fraction_1  = 16'b0000000101010101;
            19: Fraction_1  = 16'b0000000100000000;
            20: Fraction_1  = 16'b0000000011001100;
       default: Fraction_1  = 16'b0000000000000000;
       endcase
    end
    else begin
        Fraction_1  = 0;
    end
end


//==============================================//
//                  Output Block                //
//==============================================//
always@(posedge clk or negedge rst_n) begin//out_valid
    if(!rst_n) 
        out_valid <= 0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
        out_valid <= 1;
    end
    else begin
        out_valid <= 0;
    end
end

reg [4:0]value;
reg [4:0]Left_index;
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        value<=0;
        Left_index<=0;
    end else begin 
        if(CS_OUTPUT)begin 
            if(ctr==0)begin 
                value<=0;
            end else if(xo==Edge_pairs3[0][Left_index]&&ctr!=0)begin 
                value<=0;
            end   else begin
                value<=value+1;
            end
        end else begin 
        value<=0;
end
end
end
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        Left_index<=0;
    end else begin 
        if(CS_OUTPUT)begin 
            if(ctr<5)begin 
                Left_index<=0;
            end  else if(value==0&&ctr>5)begin 
                  Left_index<=Left_index+1;
            end  else begin
                 Left_index<=Left_index;
            end 
        end  else begin 
            value<=0;
end
end
end
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        xo <= 0; /* remember to reset */
        yo <= 0;
    end else if(curr_state==OUTPUT)begin 
        if(ctr==0)begin 
            xo<=C[0];//Edge_pairs2[0][0];
            yo<=C[1];//Edge_pairs2[1][0];
        end else if(xo<D[0]&&Left_index==0&&D[0]>0)begin 
            xo<=xo+1;
            yo<=yo;
        end else if(xo<D[0]&&Left_index==0&&D[0]<0)begin 
            xo<=-(xo)+1;
            yo<=-(yo);
        end else if(xo==D[0]&&Left_index==0) begin
            xo<=Edge_pairs2[0][Left_index+1];
            yo<=Edge_pairs2[1][Left_index+1];
        end else if(xo==Edge_pairs3[0][Left_index-1]&&Left_index!=0) begin
            xo<=Edge_pairs2[0][Left_index+1];
            yo<=Edge_pairs2[1][Left_index+1];
        end else if(xo<Edge_pairs3[0][Left_index-1]&&Left_index!=0)begin 
            xo<=xo+1;
            yo<=yo;
        end else begin 
            xo<=9;
            yo<=9;
        end
    end else begin 
        xo <= 0;
        yo <= 0;
end  
end

endmodule 

module DYDX (x0,x1,y0,y1,dx,dy);
    input [7:0] x0,x1,y0,y1;
    output [7:0] dx,dy;
    assign dx=(x1>x0)?(x1-x0):(x0-x1);
    assign dy=(y1>y0)?(y1-y0):(y0-y1);
endmodule 

//////////////
module CC(
    //Input Port
    clk,
    rst_n,
	in_valid,
	mode,
    xi,
    yi,

    //Output Port
    out_valid,
	xo,
	yo
    );

input               clk, rst_n, in_valid;
input       [1:0]   mode;
input       [7:0]   xi, yi;  

output reg          out_valid;
output reg  signed [7:0]   xo, yo;
//==============================================//
//             Parameter and Integer            //
//==============================================//
parameter   IDLE    = 'd0,
            INPUT   = 'd1,
            COMP    = 'd2,
            OUTPUT  = 'd3;
integer     i,j;
integer     ctr;

reg [2:0] next_state, curr_state;

wire CS_IDLE   = (curr_state == IDLE );
wire NS_INPUT  = (next_state == INPUT&&curr_state!=INPUT);
wire CS_INPUT  = (curr_state == INPUT);

wire CS_COMP  =  (curr_state == COMP);
wire NS_COMP  =  (next_state == COMP&&curr_state!=COMP);

wire CS_OUTPUT = (curr_state == OUTPUT);
wire NS_OUTPUT = (next_state == OUTPUT&&curr_state!=OUTPUT);
 
wire is_trapezoid_mode=   (mode==2'b00);
wire is_circle_line_mode= (mode==2'b01);
wire is_area_mode=        (mode==2'b10);

reg [15:0] Fraction_0,Fraction_1;
reg signed [15:0] Dhold[0:3];
reg signed [7:0] Box1[1:0][20:0],Box2[1:0][20:0];
genvar idx,jdx;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) curr_state <= IDLE;
    else       curr_state <= next_state;
end
//==============================================//
//              Next State Block                //
//==============================================//
always @(*) begin //next_state
    case(curr_state)
        IDLE:
            if(in_valid)                          next_state = INPUT;
            else                                  next_state = curr_state;
        INPUT:
            if(!in_valid)                         next_state = COMP;
            else                                  next_state = INPUT;
        COMP:
            if     (is_trapezoid_mode&&ctr==18)   next_state = OUTPUT;
            else if(is_circle_line_mode&&ctr==5)  next_state = OUTPUT;
            else if(is_area_mode&&ctr==18)        next_state = OUTPUT;
            else                                  next_state = COMP;
        OUTPUT: 
            if     (is_trapezoid_mode&&ctr==161)    next_state = IDLE;
            else if(is_circle_line_mode&&ctr==5)  next_state = IDLE;
            else if(is_area_mode&&ctr==5)         next_state = IDLE;
            else                                  next_state = OUTPUT;
           
        default:                                  next_state = curr_state;
    endcase
end
always @(posedge clk or negedge rst_n) begin//ctr
	if(!rst_n) begin
		ctr <= 0;
	end
	else begin
		case(curr_state)
			INPUT: begin
				if(in_valid==0&&ctr==4) begin
					ctr<= 0;
				end
				else if(next_state==COMP) begin
					ctr <= 0;
				end
				else begin
					ctr <= ctr+1;
				end
			end 
			COMP: begin
				if(next_state==OUTPUT) begin
					ctr <= 0;
				end
				else begin
					ctr <= ctr+1;
				end
			end
			OUTPUT: begin
        if(next_state==IDLE) begin
				ctr<=0;
        end else begin 
          ctr<=ctr+1;
        end
			end
		default: ctr <= 0;
		endcase
	end
	end
//==============================================//
//                  Input Block                 //
//==============================================//
  reg [7:0] A [0:1];
  reg signed [7:0]  B [0:1];
  reg signed [7:0]C [0:1],D [0:1];

  wire isparallel_AB_CD=((B[1]-A[1])/(B[0]-A[0]))==((D[1]-C[1])/(D[0]-C[0]));//parallel means ACBD
  wire isparallel_BC_DA=((C[1]-B[1])/(C[0]-B[0]))==((A[1]-D[1])/(A[0]-D[0]));//if true then operate on abcd

  DYDX DYDX0(.x0(A[0]),.x1(B[0]),.y0(A[1]),.y1(B[1]),.dx(DX0),.dy(DY0));//always positive
  DYDX DYDX1(.x0(C[0]),.x1(D[0]),.y0(C[1]),.y1(D[1]),.dx(DX1),.dy(DY1));
  DYDX DYDX2(.x0(D[0]),.x1(B[0]),.y0(D[1]),.y1(B[1]),.dx(DX3),.dy(DY3));
  DYDX DYDX3(.x0(C[0]),.x1(A[0]),.y0(C[1]),.y1(A[1]),.dx(DX2),.dy(DY2));

generate //input ABCD
    for(idx=0;idx<2;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        A[idx]<=0;
        B[idx]<=0;
        C[idx]<=0;
        D[idx]<=0;
    end else begin 
        if(NS_INPUT&&ctr==0) begin
            A[0]<=xi;
            A[1]<=yi;
        end else if(CS_INPUT&&ctr==0) begin
            B[0]<=xi;
            B[1]<=yi;
        end else if(CS_INPUT&&ctr==1) begin
            C[0]<=xi;
            C[1]<=yi;
        end else if(CS_INPUT&&ctr==2) begin
            D[0]<=xi;
            D[1]<=yi;
        end else begin 
            A[idx]<=A[idx];
            B[idx]<=B[idx];
            C[idx]<=C[idx];
            D[idx]<=D[idx];
        end
        end
    end 
endgenerate

generate //Edge_pairs0
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs0[idx][jdx]<=0;
        Edge_pairs1[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs0[0][0]<=A[0];
            Edge_pairs0[1][0]<=A[1];
            // Edge_pairs1[0][0]<=C[0];
            // Edge_pairs1[0][1]<=C[1];
            // Edge_pairs1[1][0]<=D[0];
            // Edge_pairs1[1][1]<=D[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
            if(Dhold[0]>0)begin 
                Edge_pairs0[0][ctr]<=Edge_pairs0[0][ctr-1]+1;
                Edge_pairs0[1][ctr]<=Edge_pairs0[1][ctr-1]+yi_0;
            end else begin 
                Edge_pairs0[0][ctr]<=Edge_pairs0[0][ctr-1]+1;
                Edge_pairs0[1][ctr]<=Edge_pairs0[1][ctr-1];
            end
        end else begin 
            Edge_pairs0[idx][jdx]<=Edge_pairs0[idx][jdx];
            Edge_pairs1[idx][jdx]<=Edge_pairs1[idx][jdx];
        end
        end
    end
endgenerate
generate //Edge_pairs1
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs1[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs1[0][0]<=C[0];
            Edge_pairs1[1][0]<=C[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
            if(Dhold[1]>0)begin 
                Edge_pairs1[0][ctr]<=Edge_pairs1[0][ctr-1]+1;
                Edge_pairs1[1][ctr]<=Edge_pairs1[1][ctr-1]+yi_1;
            end else begin 
                Edge_pairs1[0][ctr]<=Edge_pairs1[0][ctr-1]+1;
                Edge_pairs1[1][ctr]<=Edge_pairs1[1][ctr-1];
            end
        end else begin 
            Edge_pairs1[idx][jdx]<=Edge_pairs1[idx][jdx];
        end
        end
    end
endgenerate
wire [9:0] m2=((Box1[1][ctr-1]+1)-C[0]);//denominateur
wire signed [9:0] mmm2=(Box1[1][ctr-1]+1)-C[0];
wire [9:0] Reference2= (A[1]-C[1])/(A[0]-C[0]);

wire [9:0] m=((Box1[1][ctr-1]+1)-C[0]);//denominateur
wire signed [9:0] mmm=(Box1[1][ctr-1]+1)-C[0];
wire [9:0] Reference= (A[1]-C[1])/(A[0]-C[0]);

fxi=(D[0]>=0)?-1:1;
generate //Box1
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Box1[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Box1[0][0]<=C[0];
            Box1[1][0]<=C[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
             if(mmm==Reference||mmm==2*Reference)
             begin 
                Box1[0][ctr]<=Box1[0][ctr-1]+fxi;
                Box1[1][ctr]<=Box1[1][ctr-1]+fxi;
             end else begin 
                Box1[0][ctr]<=Box1[0][ctr-1];
                Box1[1][ctr]<=Box1[1][ctr-1]+fxi;
             end
        end else begin 
            Box1[idx][jdx]<=Box1[idx][jdx];
        end
        end
    end
endgenerate
generate //Edge_pairs3
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs3[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs3[0][0]<=D[0]-1;
            Edge_pairs3[1][0]<=D[1];
         end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[3]>=0)begin 
                Edge_pairs3[0][ctr]<=Edge_pairs3[0][ctr-1]+(((D[0]-B[0])>0)?-1:1);
                Edge_pairs3[1][ctr]<=Edge_pairs3[1][ctr-1]+1;
            end else begin 
                Edge_pairs3[0][ctr]<=Edge_pairs3[0][ctr-1];
                Edge_pairs3[1][ctr]<=Edge_pairs3[1][ctr-1]+1;
            end
        end else begin 
            Edge_pairs3[idx][jdx]<=Edge_pairs3[idx][jdx];
        end
    end
    end
endgenerate


always@(*) begin//Fraction_1
    if(!rst_n) 
        Fraction_0=0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
       case (m)
            2: Fraction_0 = 16'b0100000000000000;
            3: Fraction_0 = 16'b0010101010101010;
            4: Fraction_0 = 16'b0010000000000000;
            5: Fraction_0 = 16'b0001100110011001;
            6: Fraction_0 = 16'b0001010101010101;
            7: Fraction_0 = 16'b0001000000000000;
            8: Fraction_0 = 16'b0000110011001100;
            9: Fraction_0 = 16'b0000101010101010;
            10: Fraction_0 = 16'b0000100000000000;
            11: Fraction_0 = 16'b0000011001100110;
            12: Fraction_0 = 16'b0000010101010101;
            13: Fraction_0 = 16'b0000010000000000;
            14: Fraction_0 = 16'b0000001100110011;
            15: Fraction_0 = 16'b0000001010101010;
            16: Fraction_0 = 16'b0000001000000000;
            17: Fraction_0 = 16'b0000000110011001;
            18: Fraction_0 = 16'b0000000101010101;
            19: Fraction_0 = 16'b0000000100000000;
            20: Fraction_0 = 16'b0000000011001100;
            default: Fraction_0 = 16'b0000000000000000;
       endcase
    end
    else begin
        Fraction_0 = 0;
    end
end
always@(*) begin//Fraction_1
    if(!rst_n) 
        Fraction_1 =0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
       case (m)
             2: Fraction_1  = 16'b0100000000000000;
            3: Fraction_1  =  16'b0010101010101010;
            4: Fraction_1  =  16'b0010000000000000;
            5: Fraction_1  =  16'b0001100110011001;
            6: Fraction_1  =  16'b0001010101010101;
            7: Fraction_1  =  16'b0001000000000000;
            8: Fraction_1  =  16'b0000110011001100;
            9: Fraction_1  =  16'b0000101010101010;
            10: Fraction_1  = 16'b0000100000000000;
            11: Fraction_1  = 16'b0000011001100110;
            12: Fraction_1  = 16'b0000010101010101;
            13: Fraction_1  = 16'b0000010000000000;
            14: Fraction_1  = 16'b0000001100110011;
            15: Fraction_1  = 16'b0000001010101010;
            16: Fraction_1  = 16'b0000001000000000;
            17: Fraction_1  = 16'b0000000110011001;
            18: Fraction_1  = 16'b0000000101010101;
            19: Fraction_1  = 16'b0000000100000000;
            20: Fraction_1  = 16'b0000000011001100;
       default: Fraction_1  = 16'b0000000000000000;
       endcase
    end
    else begin
        Fraction_1  = 0;
    end
end


//==============================================//
//                  Output Block                //
//==============================================//
always@(posedge clk or negedge rst_n) begin//out_valid
    if(!rst_n) 
        out_valid <= 0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
        out_valid <= 1;
    end
    else begin
        out_valid <= 0;
    end
end

reg [4:0]value;
reg [4:0]Left_index;
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        value<=0;
        Left_index<=0;
    end else begin 
        if(CS_OUTPUT)begin 
            if(ctr==0)begin 
                value<=0;
            end else if(xo==Edge_pairs3[0][Left_index]&&ctr!=0)begin 
                value<=0;
            end   else begin
                value<=value+1;
            end
        end else begin 
        value<=0;
end
end
end
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        Left_index<=0;
    end else begin 
        if(CS_OUTPUT)begin 
            if(ctr<5)begin 
                Left_index<=0;
            end  else if(value==0&&ctr>5)begin 
                  Left_index<=Left_index+1;
            end  else begin
                 Left_index<=Left_index;
            end 
        end  else begin 
            value<=0;
end
end
end
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        xo <= 0; /* remember to reset */
        yo <= 0;
    end else if(curr_state==OUTPUT)begin 
        if(ctr==0)begin 
            xo<=C[0];//Box1[0][0];
            yo<=C[1];//Box1[1][0];
        end else if(xo<D[0]&&Left_index==0&&D[0]>0)begin 
            xo<=xo+1;
            yo<=yo;
        end else if(xo<D[0]&&Left_index==0&&D[0]<0)begin 
            xo<=-(xo)+1;
            yo<=-(yo);
        end else if(xo==D[0]&&Left_index==0) begin
            xo<=Box1[0][Left_index+1];
            yo<=Box1[1][Left_index+1];
        end else if(xo==Edge_pairs3[0][Left_index-1]&&Left_index!=0) begin
            xo<=Box1[0][Left_index+1];
            yo<=Box1[1][Left_index+1];
        end else if(xo<Edge_pairs3[0][Left_index-1]&&Left_index!=0)begin 
            xo<=xo+1;
            yo<=yo;
        end else begin 
            xo<=9;
            yo<=9;
        end
    end else begin 
        xo <= 0;
        yo <= 0;
end  
end

endmodule 

module DYDX (x0,x1,y0,y1,dx,dy);
    input [7:0] x0,x1,y0,y1;
    output [7:0] dx,dy;
    assign dx=(x1>x0)?(x1-x0):(x0-x1);
    assign dy=(y1>y0)?(y1-y0):(y0-y1);
endmodule 

///////////////



////////////////
module CC(
    //Input Port
    clk,
    rst_n,
	in_valid,
	mode,
    xi,
    yi,

    //Output Port
    out_valid,
	xo,
	yo
    );

input               clk, rst_n, in_valid;
input       [1:0]   mode;
input       [7:0]   xi, yi;  

output reg          out_valid;
output reg  signed [7:0]   xo, yo;
//==============================================//
//             Parameter and Integer            //
//==============================================//
parameter   IDLE    = 'd0,
            INPUT   = 'd1,
            COMP    = 'd2,
            OUTPUT  = 'd3;
integer     i,j;
integer     ctr;
reg signed [7:0] A [0:1];
reg signed [7:0]  B [0:1];
reg signed [7:0]C [0:1],D [0:1];

reg [2:0] next_state, curr_state;

wire CS_IDLE   = (curr_state == IDLE );
wire NS_INPUT  = (next_state == INPUT&&curr_state!=INPUT);
wire CS_INPUT  = (curr_state == INPUT);

wire CS_COMP  =  (curr_state == COMP);
wire NS_COMP  =  (next_state == COMP&&curr_state!=COMP);

wire CS_OUTPUT = (curr_state == OUTPUT);
wire NS_OUTPUT = (next_state == OUTPUT&&curr_state!=OUTPUT);
 
wire is_trapezoid_mode=   (mode==2'b00);
wire is_circle_line_mode= (mode==2'b01);
wire is_area_mode=        (mode==2'b10);

reg [15:0] Fraction_0,Fraction_1;
wire [7:0] Dy0,Dy1,Dy2,Dy3,Dx0,Dx1,Dx2,Dx3;
reg signed [15:0] Dhold[0:3];
reg signed [7:0] Edge_pairs0[0:1][0:20],Edge_pairs1[0:1][0:20],Edge_pairs2[0:1][0:20],Edge_pairs3[0:1][0:20];

genvar idx,jdx;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) curr_state <= IDLE;
    else       curr_state <= next_state;
end
//==============================================//
//              Next State Block                //
//==============================================//
always @(*) begin //next_state
    case(curr_state)
        IDLE:
            if(in_valid)                          next_state = INPUT;
            else                                  next_state = curr_state;
        INPUT:
            if(!in_valid)                         next_state = COMP;
            else                                  next_state = INPUT;
        COMP:
            if     (is_trapezoid_mode&&ctr==18)   next_state = OUTPUT;
            else if(is_circle_line_mode&&ctr==2)  next_state = OUTPUT;
            else if(is_area_mode&&ctr==18)        next_state = OUTPUT;
            else                                  next_state = COMP;
        OUTPUT: 
            if     (is_trapezoid_mode&&ctr==161)    next_state = IDLE;
            else if(is_circle_line_mode)  next_state = IDLE;
            else if(is_area_mode&&ctr==5)         next_state = IDLE;
            else                                  next_state = OUTPUT;
           
        default:                                  next_state = curr_state;
    endcase
end
////////////////////////
// wire signed [6:0] Tangent_m = (A[1] - B[1]) / (A[0] - B[0]);
// wire signed [6:0] b_ = A[1] - (A[1] - B[1]) / (A[0] - B[0]) * A[0] ;// # Y-intercept of the line

// // # Calculate the coefficients for the circle equation ((x-h)^2 + (y-k)^2 = r^2)
// wire signed[6:0] h = C[0];
// wire signed[6:0]k = C[1];
// wire signed[10:0]r = ((D[0] - C[0])**2 + (D[1] - C[1])**2)**0.5; // # Radius of the circle

//     // # Calculate the coefficients for the quadratic equation (Ax^2 + Bx + C = 0)
// wire signed[8:0] A_ = 1 + (A[1] - B[1]) / (A[0] - B[0])**2;
// wire signed[10:0] B_ = 2 * ((A[1] - B[1]) / (A[0] - B[0]) * (b_ - C[1]) - C[1]);
// wire signed[10:0] C_ = C[0]**2 + (b_ - C[1])**2 - r**2;
// wire signed [9:0]  discriminant = B_**2 - 4 * A_ * C_;
 reg signed [16:0]       m_ =(A[1] - B[1]) / (A[0] - B[0]); // # Slope of the line
 reg signed [16:0]      b =A[1] - (A[0]*(A[1] - B[1]) / (A[0] - B[0]))  ;
// Calculate the coefficients for the circle equation ((x-h)^2 + (y-k)^2 = r^2)
reg signed [16:0] h = C[0];
reg signed [16:0] k = C[1];
reg signed [16:0]r_squared = (D[0] - C[0])**2 + (D[1] - C[1])**2;
reg signed [16:0] B_squared =(2 * m_ * ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0])) - k) - 2 * h)**2;
reg signed [16:0] A_squared = 4 * (1 + m_**2) * (h**2 + ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0])) - k)**2 - r_squared);
reg signed [17:0] discriminant =(((2 * m_ * ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0]))) - k) - 2 * h)**2 - 4 * (1 + m_**2) * (h**2 + ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0]) - k)**2 - r_squared)));
reg [1:0] yy;
reg signed [7:0] mdta;
always @(posedge clk or negedge rst_n) begin//ctr
	if(!rst_n) begin
		yy<=0;
    mdta<=0;
	end
	else begin 
    if(CS_COMP&&ctr==3) begin  
      yy<=(B_squared<0&&A_squared>0||discriminant<0)?2'b00:(discriminant==0)?2'b01:2'b10;
      mdta<=(A[0] != B[0])?(A[1] - B[1]) / (A[0] - B[0]):0;
    end else begin 
      yy<=yy;
      mdta<=mdta;
    end
  end
end
always @(posedge clk or negedge rst_n) begin//ctr
	if(!rst_n) begin
    m_<=0;
    b<=0;
    h<=0;
    k<=0;
    r_squared<=0;
    B_squared<=0;
    A_squared<=0;
    discriminant<=0;   
	end
	else begin 
    if(CS_COMP&&ctr==3) begin  
      m_ =(A[1] - B[1]) / (A[0] - B[0]); // # Slope of the line
      b =A[1] - (A[0]*(A[1] - B[1]) / (A[0] - B[0]))  ;
      h = C[0];
      k = C[1];
      r_squared = (D[0] - C[0])**2 + (D[1] - C[1])**2;
      B_squared =(2 * m_ * ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0])) - k) - 2 * h)**2;
      A_squared = 4 * (1 + m_**2) * (h**2 + ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0])) - k)**2 - r_squared);
      discriminant =(((2 * m_ * ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0]))) - k) - 2 * h)**2 - 4 * (1 + m_**2) * (h**2 + ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0]) - k)**2 - r_squared)));
    end else begin 
      m_<=m_;
      b<=b;
      h<=h;
      k<=k;
      r_squared<=r_squared;
      B_squared<=B_squared;
      A_squared<=A_squared;
      discriminant<=discriminant;

    end
  end
end
always @(posedge clk or negedge rst_n) begin//ctr
	if(!rst_n) begin
		ctr <= 0;
	end
	else begin
		case(curr_state)
			INPUT: begin
				if(in_valid==0&&ctr==4) begin
					ctr<= 0;
				end
				else if(next_state==COMP) begin
					ctr <= 0;
				end
				else begin
					ctr <= ctr+1;
				end
			end 
			COMP: begin
				if(next_state==OUTPUT) begin
					ctr <= 0;
				end
				else begin
					ctr <= ctr+1;
				end
			end
			OUTPUT: begin
        if(next_state==IDLE) begin
				ctr<=0;
        end else begin 
          ctr<=ctr+1;
        end
			end
		default: ctr <= 0;
		endcase
	end
	end
//==============================================//
//                  Input Block                 //
//==============================================//

  wire [7:0] DY0,DY1,DY2,DY3,DX0,DX1,DX2,DX3,DX4,DY4;
  assign Dx_AB=(B[0]>A[0])?(B[0]-A[0]):(A[0]-B[0]);
  assign Dx_CD=(D[0]>C[0])?(D[0]-C[0]):(C[0]-D[0]);
  assign Dx_DA= (A[0]>D[0])?(A[0]-D[0]):(D[0]-A[0]);
  assign Dx_BC=(C[0]>B[0])?(C[0]-B[0]):(B[0]-C[0]);
  assign Dx_AC=(C[0]>A[0])?(C[0]-A[0]):(A[0]-C[0]);
  assign Dy_AB=(B[1]>A[1])?(B[1]-A[1]):(A[1]-B[1]);
  assign Dy_CD=(D[1]>C[1])?(D[1]-C[1]):(C[1]-D[1]);
  assign Dy_BC=(C[1]>B[1])?(C[1]-B[1]):(B[1]-C[1]);
  assign Dy_DA=(A[1]>D[1])?(A[1]-D[1]):(D[1]-A[1]);
  assign Dy_AC=(C[1]>A[1])?(C[1]-A[1]):(A[1]-C[1]);

  wire isparallel_AB_CD=((B[1]-A[1])/(B[0]-A[0]))==((D[1]-C[1])/(D[0]-C[0]));//parallel means ACBD
  wire isparallel_BC_DA=((C[1]-B[1])/(C[0]-B[0]))==((A[1]-D[1])/(A[0]-D[0]));//if true then operate on abcd
  // wire isparallel_AC_BD=((C[1]-A[1])/(C[0]-A[0]))==((B[1]-D[1])/(B[0]-D[0]));//if true then operate on abcd

  wire [1:0]Plot_line_AB=(Dx_AB>Dy_AB)?(A[0]>B[0]?1:0):(A[1]>B[1]?2:3);
  wire [1:0]Plot_line_CD=(Dx_CD>Dy_CD)?(C[0]>D[0]?1:0):(C[1]>D[1]?2:3);
  wire [1:0]Plot_line_DA=(Dx_DA>Dy_DA)?(D[0]>A[0]?1:0):(D[1]>A[1]?2:3);
  wire [1:0]Plot_line_BC=(Dx_BC>Dy_BC)?(B[0]>C[0]?1:0):(B[1]>C[1]?2:3);



  DYDX DYDX0(.x0(A[0]),.x1(B[0]),.y0(A[1]),.y1(B[1]),.dx(DX0),.dy(DY0));
  DYDX DYDX1(.x0(C[0]),.x1(D[0]),.y0(C[1]),.y1(D[1]),.dx(DX1),.dy(DY1));
  DYDX DYDX2(.x0(D[0]),.x1(B[0]),.y0(D[1]),.y1(B[1]),.dx(DX3),.dy(DY3));
  DYDX DYDX3(.x0(C[0]),.x1(A[0]),.y0(C[1]),.y1(A[1]),.dx(DX2),.dy(DY2));

generate //input ABCD
    for(idx=0;idx<2;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        A[idx]<=0;
        B[idx]<=0;
        C[idx]<=0;
        D[idx]<=0;
    end else begin 
        if(NS_INPUT&&ctr==0) begin
            A[0]<=xi;
            A[1]<=yi;
        end else if(CS_INPUT&&ctr==0) begin
            B[0]<=xi;
            B[1]<=yi;
        end else if(CS_INPUT&&ctr==1) begin
            C[0]<=xi;
            C[1]<=yi;
        end else if(CS_INPUT&&ctr==2) begin
            D[0]<=xi;
            D[1]<=yi;
        end else begin 
            A[idx]<=A[idx];
            B[idx]<=B[idx];
            C[idx]<=C[idx];
            D[idx]<=D[idx];
        end
        end
    end 
endgenerate
//xompute and fill the edge pairs
wire dx_0,dx_1,dx_2,dx_3,dy_0,dy_1,dy_2,dy_3;//follows <0
wire signed [0:1] xi_0,xi_1,xi_2,xi_3,yi_0,yi_1,yi_2,yi_3;
assign dx_0 =(DX0<0)?1:0;
assign xi_0 =(dx_0)?-1:1;
assign dy_0 =(DY0<0)?1:0;
assign yi_0 =(dy_0)?-1:1;
assign dx_1 =(DX1<0)?1:0;
assign xi_1 =(dx_1)?-1:1;
assign dy_1 =(DY1<0)?1:0;
assign yi_1 =(dy_1)?-1:1;
assign dx_2 =(DX2<0)?1:0;
assign xi_2 =(dx_2)?-1:1;
assign dy_2 =(DY2<0)?1:0;
assign yi_2 =(dy_2)?-1:1;
assign dx_3 =((D[0]-B[0])<0)?1:0;
assign xi_3 =(dx_3)?-1:1;
assign dy_3 =((D[1]-B[1])<0)?1:0;//(D[0]-B[0])
assign yi_3 =(dy_3)?-1:1;
//–1 < m < 1, x0 < x1
generate //Dhold[0]
    for(idx=0;idx<4;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Dhold[0]=0;
    end else begin 
        if(CS_COMP&&ctr==0) begin//abcd
            Dhold[0]<=2*((dy_0)?(-DY0):DY0)-DX0;//AB
        end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[0]>0)begin 
                Dhold[0]<=Dhold[0]-2*DX0;
            end else begin 
                Dhold[0]<=Dhold[0]+2*DY0;
            end
        end else begin 
            Dhold[0]<=Dhold[0];
        end
        end
    end
endgenerate
generate//Dhold[1] 
    for(idx=0;idx<4;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Dhold[1]=0;
    end else begin 
        if(CS_COMP&&ctr==0) begin//abcd
            Dhold[1]<=2*((dy_1)?(-DY1):DY1)-DX1;//AB
        end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[1]>0)begin 
                Dhold[1]<=Dhold[1]-2*DX1;
            end else begin 
                Dhold[1]<=Dhold[1]+2*DY1;
            end
        end else begin 
            Dhold[1]<=Dhold[1];
        end
        end
    end
endgenerate
generate//Dhold[2] 
    for(idx=0;idx<4;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Dhold[2]=0;
    end else begin 
        if(CS_COMP&&ctr==0) begin//abcd
            Dhold[2]<=2*((dx_2)?(-DX2):DX2)-DY2;//AC
        end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[2]>0)begin 
                Dhold[2]<=Dhold[2]-2*((A[1]-C[1])-(A[0]-C[0]));
            end else if (Dhold[2]==0)begin 
                Dhold[2]<=Dhold[2]+2*(A[0]-C[0]);
            end else begin
                Dhold[2]<=Dhold[2]+2*(A[0]-C[0]);
            end
        end else begin 
            Dhold[2]<=Dhold[2];
        end
        end
    end
endgenerate
generate//Dhold[3] 
    for(idx=0;idx<4;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Dhold[3]<=0;
    end else begin 
        if(CS_COMP&&ctr==0) begin//abcd
            Dhold[3]<=2*((dx_3)?(-DX3):DX3)-DY3;//AC
        end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[3]>=0)begin 
                Dhold[3]<=Dhold[3]-2*(DY3-DX3);//D[0]),.x1(B[0]),.y0(D[1]),.y1(B[1])
            end else begin 
                Dhold[3]<=Dhold[3]+2*(D[0]-B[0]);
            end
        end else begin 
            Dhold[3]<=Dhold[3];
        end
        end
    end
endgenerate
generate //Edge_pairs0
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs0[idx][jdx]<=0;
        Edge_pairs1[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs0[0][0]<=A[0];
            Edge_pairs0[1][0]<=A[1];
            // Edge_pairs1[0][0]<=C[0];
            // Edge_pairs1[0][1]<=C[1];
            // Edge_pairs1[1][0]<=D[0];
            // Edge_pairs1[1][1]<=D[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
            if(Dhold[0]>0)begin 
                Edge_pairs0[0][ctr]<=Edge_pairs0[0][ctr-1]+1;
                Edge_pairs0[1][ctr]<=Edge_pairs0[1][ctr-1]+yi_0;
            end else begin 
                Edge_pairs0[0][ctr]<=Edge_pairs0[0][ctr-1]+1;
                Edge_pairs0[1][ctr]<=Edge_pairs0[1][ctr-1];
            end
        end else begin 
            Edge_pairs0[idx][jdx]<=Edge_pairs0[idx][jdx];
            Edge_pairs1[idx][jdx]<=Edge_pairs1[idx][jdx];
        end
        end
    end
endgenerate
generate //Edge_pairs1
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs1[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs1[0][0]<=C[0];
            Edge_pairs1[1][0]<=C[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
            if(Dhold[1]>0)begin 
                Edge_pairs1[0][ctr]<=Edge_pairs1[0][ctr-1]+1;
                Edge_pairs1[1][ctr]<=Edge_pairs1[1][ctr-1]+yi_1;
            end else begin 
                Edge_pairs1[0][ctr]<=Edge_pairs1[0][ctr-1]+1;
                Edge_pairs1[1][ctr]<=Edge_pairs1[1][ctr-1];
            end
        end else begin 
            Edge_pairs1[idx][jdx]<=Edge_pairs1[idx][jdx];
        end
        end
    end
endgenerate

wire [9:0] m=((Edge_pairs2[1][ctr-1]+1)-C[0]);//denominateur
wire signed [9:0] mmm=(Edge_pairs2[1][ctr-1]+1)-C[0];
wire [9:0] Reference= (A[1]-C[1])/(A[0]-C[0]);

generate //Edge_pairs2
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs2[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs2[0][0]<=C[0];
            Edge_pairs2[1][0]<=C[1];
         end else if(CS_COMP&&ctr!=0&&ctr!=0) begin
            //m=A[1]-C[0]/A[0]-C[0];

             if(mmm==Reference||mmm==2*Reference)
             begin 
                Edge_pairs2[0][ctr]<=Edge_pairs2[0][ctr-1]+1;
                Edge_pairs2[1][ctr]<=Edge_pairs2[1][ctr-1]+1;
             end else begin 
                Edge_pairs2[0][ctr]<=Edge_pairs2[0][ctr-1];
                Edge_pairs2[1][ctr]<=Edge_pairs2[1][ctr-1]+1;
             end
        end else begin 
            Edge_pairs2[idx][jdx]<=Edge_pairs2[idx][jdx];
        end
        end
    end
endgenerate
generate //Edge_pairs3
    for(idx=0;idx<2;idx=idx+1)
    for(jdx=0;jdx<21;jdx=jdx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        Edge_pairs3[idx][jdx]<=0;
    end else begin 
        if(CS_COMP&&ctr==0&&isparallel_BC_DA) begin//abcd
            Edge_pairs3[0][0]<=D[0]-1;
            Edge_pairs3[1][0]<=D[1];
         end else if(CS_COMP&&ctr!=0) begin
            if(Dhold[3]>=0)begin 
                Edge_pairs3[0][ctr]<=Edge_pairs3[0][ctr-1]+(((D[0]-B[0])>0)?-1:1);
                Edge_pairs3[1][ctr]<=Edge_pairs3[1][ctr-1]+1;
            end else begin 
                Edge_pairs3[0][ctr]<=Edge_pairs3[0][ctr-1];
                Edge_pairs3[1][ctr]<=Edge_pairs3[1][ctr-1]+1;
            end
        end else begin 
            Edge_pairs3[idx][jdx]<=Edge_pairs3[idx][jdx];
        end
    end
    end
endgenerate


always@(*) begin//Fraction_1
    if(!rst_n) 
        Fraction_0=0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
       case (m)
            2: Fraction_0 = 16'b0100000000000000;
            3: Fraction_0 = 16'b0010101010101010;
            4: Fraction_0 = 16'b0010000000000000;
            5: Fraction_0 = 16'b0001100110011001;
            6: Fraction_0 = 16'b0001010101010101;
            7: Fraction_0 = 16'b0001000000000000;
            8: Fraction_0 = 16'b0000110011001100;
            9: Fraction_0 = 16'b0000101010101010;
            10: Fraction_0 = 16'b0000100000000000;
            11: Fraction_0 = 16'b0000011001100110;
            12: Fraction_0 = 16'b0000010101010101;
            13: Fraction_0 = 16'b0000010000000000;
            14: Fraction_0 = 16'b0000001100110011;
            15: Fraction_0 = 16'b0000001010101010;
            16: Fraction_0 = 16'b0000001000000000;
            17: Fraction_0 = 16'b0000000110011001;
            18: Fraction_0 = 16'b0000000101010101;
            19: Fraction_0 = 16'b0000000100000000;
            20: Fraction_0 = 16'b0000000011001100;
            default: Fraction_0 = 16'b0000000000000000;
       endcase
    end
    else begin
        Fraction_0 = 0;
    end
end
always@(*) begin//Fraction_1
    if(!rst_n) 
        Fraction_1 =0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
       case (m)
             2: Fraction_1  = 16'b0100000000000000;
            3: Fraction_1  =  16'b0010101010101010;
            4: Fraction_1  =  16'b0010000000000000;
            5: Fraction_1  =  16'b0001100110011001;
            6: Fraction_1  =  16'b0001010101010101;
            7: Fraction_1  =  16'b0001000000000000;
            8: Fraction_1  =  16'b0000110011001100;
            9: Fraction_1  =  16'b0000101010101010;
            10: Fraction_1  = 16'b0000100000000000;
            11: Fraction_1  = 16'b0000011001100110;
            12: Fraction_1  = 16'b0000010101010101;
            13: Fraction_1  = 16'b0000010000000000;
            14: Fraction_1  = 16'b0000001100110011;
            15: Fraction_1  = 16'b0000001010101010;
            16: Fraction_1  = 16'b0000001000000000;
            17: Fraction_1  = 16'b0000000110011001;
            18: Fraction_1  = 16'b0000000101010101;
            19: Fraction_1  = 16'b0000000100000000;
            20: Fraction_1  = 16'b0000000011001100;
       default: Fraction_1  = 16'b0000000000000000;
       endcase
    end
    else begin
        Fraction_1  = 0;
    end
end


//==============================================//
//                  Output Block                //
//==============================================//
always@(posedge clk or negedge rst_n) begin//out_valid
    if(!rst_n) 
        out_valid <= 0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
        out_valid <= 1;
    end
    else begin
        out_valid <= 0;
    end
end

reg [4:0]value;
reg [4:0]Left_index;
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        value<=0;
        Left_index<=0;
    end else begin 
        if(CS_OUTPUT)begin 
            if(ctr==0)begin 
                value<=0;
            end else if(xo==Edge_pairs3[0][Left_index]&&ctr!=0)begin 
                value<=0;
            end   else begin
                value<=value+1;
            end
        end else begin 
        value<=0;
end
end
end
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        Left_index<=0;
    end else begin 
        if(CS_OUTPUT)begin 
            if(ctr<5)begin 
                Left_index<=0;
            end  else if(value==0&&ctr>5)begin 
                  Left_index<=Left_index+1;
            end  else begin
                 Left_index<=Left_index;
            end 
        end  else begin 
            value<=0;
end
end
end
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        xo <= 0; /* remember to reset */
        yo <= 0;
    end else if(curr_state==OUTPUT)begin 
      case(mode)
      'b00:begin //trapezoid
        if(ctr==0)begin 
            xo<=C[0];//Edge_pairs2[0][0];
            yo<=C[1];//Edge_pairs2[1][0];
        end else if(xo<D[0]&&Left_index==0&&D[0]>0)begin 
            xo<=xo+1;
            yo<=yo;
        end else if(xo<D[0]&&Left_index==0&&D[0]<0)begin 
            xo<=-(xo)+1;
            yo<=-(yo);
        end else if(xo==D[0]&&Left_index==0) begin
            xo<=Edge_pairs2[0][Left_index+1];
            yo<=Edge_pairs2[1][Left_index+1];
        end else if(xo==Edge_pairs3[0][Left_index-1]&&Left_index!=0) begin
            xo<=Edge_pairs2[0][Left_index+1];
            yo<=Edge_pairs2[1][Left_index+1];
        end else if(xo<Edge_pairs3[0][Left_index-1]&&Left_index!=0)begin 
            xo<=xo+1;
            yo<=yo;
        end else begin 
            xo<=9;
            yo<=9;
        end 
    end
    'b01:begin //circle
        xo<=0;
        yo<=yy;
    end
endcase 
end
end

endmodule 

module DYDX (x0,x1,y0,y1,dx,dy);
    input [7:0] x0,x1,y0,y1;
    output [7:0] dx,dy;
    assign dx=(x1>x0)?(x1-x0):(x0-x1);
    assign dy=(y1>y0)?(y1-y0):(y0-y1);
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////



module CC(
    //Input Port
    clk,
    rst_n,
	in_valid,
	mode,
    xi,
    yi,

    //Output Port
    out_valid,
	xo,
	yo
    );
    input               clk, rst_n, in_valid;
input       [1:0]   mode;
input       [7:0]   xi, yi;  

output reg          out_valid;
output reg  signed [7:0]   xo, yo;
reg [1:0] mod;
reg signed [7:0] A [0:1];
reg signed [7:0]  B [0:1];
reg signed [7:0]C [0:1],D [0:1];

parameter   IDLE    = 'd0,
            INPUT   = 'd1,
            COMP    = 'd2,
            OUTPUT  = 'd3;
integer     i,j;
integer     ctr;
genvar idx,jdx;
reg [2:0] next_state, curr_state;

reg signed [16:0] m_;
reg signed [16:0] b;
reg signed [16:0] h;
reg signed [16:0] k;
reg signed [16:0] r_squared, distance,radius;
reg signed [16:0] B_squared;
reg signed [16:0] A_squared;
reg signed [23:0] discriminant;
reg signed  [7:0]  mdta;
reg [1:0] yy;
wire CS_IDLE   = (curr_state == IDLE );
wire NS_INPUT  = (next_state == INPUT&&curr_state!=INPUT);
wire CS_INPUT  = (curr_state == INPUT);

wire CS_COMP  =  (curr_state == COMP);
wire NS_COMP  =  (next_state == COMP&&curr_state!=COMP);

wire CS_OUTPUT = (curr_state == OUTPUT);
wire NS_OUTPUT = (next_state == OUTPUT&&curr_state!=OUTPUT);
 
wire is_trapezoid_mode=   (mod==2'b00);
wire is_circle_line_mode= (mod==2'b01);
wire is_area_mode=        (mod==2'b10);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) curr_state <= IDLE;
    else       curr_state <= next_state;
end

always @(posedge clk or negedge rst_n) begin//
	if(!rst_n) begin
    mod<=0;   
	end
	else begin 
     if(CS_INPUT&&ctr==2) begin 
     mod<=mode;
    end else begin 
      mod<=mod;
    end
  end
end


always @(*) begin //next_state
    case(curr_state)
        IDLE:
            if(in_valid)                          next_state = INPUT;
            else                                  next_state = curr_state;
        INPUT:
            if(!in_valid)                         next_state = COMP;
            else                                  next_state = INPUT;
        COMP:
            if     (is_trapezoid_mode&&ctr==18)   next_state = OUTPUT;
            else if(is_circle_line_mode&&ctr==2)  next_state = OUTPUT;
            else if(is_area_mode&&ctr==18)        next_state = OUTPUT;
            else                                  next_state = COMP;
        OUTPUT: 
            if     (is_trapezoid_mode&&ctr==161)    next_state = IDLE;
            else if(is_circle_line_mode)  next_state = IDLE;
            else if(is_area_mode&&ctr==5)         next_state = IDLE;
            else                                  next_state = OUTPUT;
           
        default:                                  next_state = curr_state;
    endcase
end

always @(posedge clk or negedge rst_n) begin//ctr
	if(!rst_n) begin
		ctr <= 0;
	end
	else begin
		case(curr_state)
			INPUT: begin
				if(in_valid==0&&ctr==4) begin
					ctr<= 0;
				end
				else if(next_state==COMP) begin
					ctr <= 0;
				end
				else begin
					ctr <= ctr+1;
				end
			end 
			COMP: begin
				if(next_state==OUTPUT) begin
					ctr <= 0;
				end
				else begin
					ctr <= ctr+1;
				end
			end
			OUTPUT: begin
        if(next_state==IDLE) begin
				ctr<=0;
        end else begin 
          ctr<=ctr+1;
        end
			end
		default: ctr <= 0;
		endcase
	end
	end
// always @(posedge clk or negedge rst_n) begin//
// 	if(!rst_n) begin
//     m_<=0;
//     b<=0;
//     h<=0;
//     k<=0;  
// 	end
// 	else begin 
//     if(CS_COMP&&ctr==0) begin  
//       dx=B[0]-A[0];
//       dy=B[1]-A[1];
//       m_=-(D[0]-C[0])/(D[1]-C[1]);
//     end else if (CS_COMP&&ctr==1)begin 
//       dr_squared=dx**2+dy**2;
//       Big_D= A[0]*B[1]-B[0]*A[1];
//     end else if (CS_COMP&&ctr==2)begin
//       r_squared=dr_squared/4;
//       discriminant=(x0 - C[0])^2 + (y0 - k)^2 - ((x2 - x1)(C[1] - C[0]) - (x1 - x0)(C[1] - C[0]))^2 / ((x2 - x1)^2 + (C[1] - C[2])^2);
//     end
//   end
// end
generate //input ABCD
    for(idx=0;idx<2;idx=idx+1)
    always@(posedge clk or negedge rst_n) begin//points x and y
    if(!rst_n) begin 
        A[idx]<=0;
        B[idx]<=0;
        C[idx]<=0;
        D[idx]<=0;
    end else begin 
        if(NS_INPUT&&ctr==0) begin
            A[0]<=xi;
            A[1]<=yi;
        end else if(CS_INPUT&&ctr==0) begin
            B[0]<=xi;
            B[1]<=yi;
        end else if(CS_INPUT&&ctr==1) begin
            C[0]<=xi;
            C[1]<=yi;
        end else if(CS_INPUT&&ctr==2) begin
            D[0]<=xi;
            D[1]<=yi;
        end else begin 
            A[idx]<=A[idx];
            B[idx]<=B[idx];
            C[idx]<=C[idx];
            D[idx]<=D[idx];
        end
        end
    end 
endgenerate
always @(posedge clk or negedge rst_n) begin//
	if(!rst_n) begin
    m_<=0;
    b<=0; 
	end
	else begin 
    if(CS_COMP&&ctr==0) begin  
      m_ <=(B[1] - A[1])/(B[0] - A[0])  ; // # Slope of the line
      b <=A[1]-(((((B[1] - A[1]))))/(B[0] - A[0]))*A[0];
    end else begin 
      m_<=m_;
      b<=b;
    end
  end
end
always @(posedge clk or negedge rst_n) begin//
	if(!rst_n) begin
    r_squared<=0;
    B_squared<=0; 
    distance<=0;

	end
	else begin 
     if(CS_COMP&&ctr==1) begin  
      r_squared = ((D[0] - C[0])*(D[0] - C[0])) + ((D[1] - C[1])*(D[1] - C[1]));
  //    B_squared =(2 * m_ * ((A[1] - A[0]*(A[1] - B[1]) / (A[0] - B[0])) - C[1]) - 2 * C[0])**2;
     // distance<= -C[0]+A[0]; B[0]-A[0]
      end else begin 
      r_squared<=r_squared;
      B_squared<=B_squared;
    end
  end
end
always @(posedge clk or negedge rst_n) begin//
	if(!rst_n) begin
    discriminant<=0;   
	end
	else begin 
     if(CS_COMP&&ctr==2) begin 
      discriminant<=( (B[0]-A[0])*(C[1]-A[1])-(B[1]-A[1])*(C[0]-A[0]))**2/((A[1]-A[0])**2);// m_*C[0]+(-1)*C[1]+b;
     // discriminant =  B_squared-A_squared;
    end else begin 
      discriminant<=discriminant;
    end
  end
end
always @(posedge clk or negedge rst_n) begin//
	if(!rst_n) begin
    A_squared<=0;
	end
	else begin 
     if(CS_COMP&&ctr==1) begin 
      A_squared = 4 * ((1 + m_**2) * (C[0]**2 + ((A[1] - A[0]*(A[1] - B[1])) / (A[0] - B[0])) - C[1])**2 - r_squared); 
    end else begin 
      A_squared<=A_squared;
    end
  end
end
always @(posedge clk or negedge rst_n) begin//yy
	if(!rst_n) begin
		yy<=0;
    mdta<=0;
	end
	else begin 
    if(CS_COMP&&ctr==3) begin  
      yy<=(/*B_squared<0&&A_squared>0||*/discriminant==r_squared)?2'b01:(discriminant>r_squared)?2'b00:2'b10;
      mdta<=(A[0] != B[0])?(A[1] - B[1]) / (A[0] - B[0]):0;
    end else begin 
      yy<=yy;
      mdta<=mdta;
    end
  end
end
always@(posedge clk or negedge rst_n) begin//out_valid
    if(!rst_n) 
        out_valid <= 0; /* remember to reset */
    else if(curr_state==OUTPUT)begin
        out_valid <= 1;
    end
    else begin
        out_valid <= 0;
    end
end
// always@(posedge clk or negedge rst_n) begin //xo,yo
//     if(!rst_n)begin 
//         Left_index<=0;
//     end else begin 
//         if(CS_OUTPUT)begin 
//             if(ctr<5)begin 
//                 Left_index<=0;
//             end  else if(value==0&&ctr>5)begin 
//                   Left_index<=Left_index+1;
//             end  else begin
//                  Left_index<=Left_index;
//             end 
//         end  else begin 
//             value<=0;
// end
// end
// end
always@(posedge clk or negedge rst_n) begin //xo,yo
    if(!rst_n)begin 
        xo <= 0; /* remember to reset */
        yo <= 0;
    end else if(curr_state==OUTPUT)begin 
      case(mod)
    //   'b00:begin //trapezoid
    //     if(ctr==0)begin 
    //         xo<=C[0];//Edge_pairs2[0][0];
    //         yo<=C[1];//Edge_pairs2[1][0];
    //     end else if(xo<D[0]&&Left_index==0&&D[0]>0)begin 
    //         xo<=xo+1;
    //         yo<=yo;
    //     end else if(xo<D[0]&&Left_index==0&&D[0]<0)begin 
    //         xo<=-(xo)+1;
    //         yo<=-(yo);
    //     end else if(xo==D[0]&&Left_index==0) begin
    //         xo<=Edge_pairs2[0][Left_index+1];
    //         yo<=Edge_pairs2[1][Left_index+1];
    //     end else if(xo==Edge_pairs3[0][Left_index-1]&&Left_index!=0) begin
    //         xo<=Edge_pairs2[0][Left_index+1];
    //         yo<=Edge_pairs2[1][Left_index+1];
    //     end else if(xo<Edge_pairs3[0][Left_index-1]&&Left_index!=0)begin 
    //         xo<=xo+1;
    //         yo<=yo;
    //     end else begin 
    //         xo<=9;
    //         yo<=9;
    //     end 
    // end
    'b01:begin //circle
        xo<=0;
        yo<=yy;
    end
    default:begin 
        xo<=0;
        yo<=0;
    end
endcase 
end
end

endmodule 