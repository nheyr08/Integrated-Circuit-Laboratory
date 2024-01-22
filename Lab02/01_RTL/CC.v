

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

input       clk, rst_n, in_valid;
input       [1:0]   mode;
input       [7:0]   xi, yi;  
output reg  out_valid;
output reg  signed [7:0] xo, yo;

//declarations
reg  flag;
reg [23:0] D_2, R_2;
reg [1:0] step,mod;
reg signed [16:0] Area_K;
reg signed [8:0] Delt_Y1, Delt_X1, Delt_X2, Delt_Y2;
reg signed [7:0] A_x, A_y, B_x, B_y, C_x, C_y, D_x, D_y;

wire is_trapezoid_mode=   (mod==2'b00);
wire is_circle_line_mode= (mod==2'b01);
wire is_area_mode=        (mod==2'b10);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin//reset all signals
        xo = 'b0;
        yo = 'b0;
        C_x<=0;
        C_y<=0;
        D_x=0;
        D_y=0;
        A_x<=0;
        A_y<=0;
        B_x<=0;
        B_y<=0;
        step <= 'b0;
        mod <= 'b0;
        Delt_Y1 = 'b0;
        Delt_X1 = 'b0;
        Delt_X2 = 'b0;
        Delt_Y2 = 'b0;
        D_2 = 'b0;
        R_2 = 'b0;
        Area_K = 'b0;
        flag <= 'b0;
        out_valid = 'b0;

    end else if (in_valid) begin
        begin
            case (step)//control flow
                'b00: begin 
                    A_x <= xi; 
                    A_y <= yi; 
                    step <= 'b01; 
                    mod <= mode;
                end
                'b01: begin 
                    B_x <= xi; 
                    B_y <= yi; 
                    step <= 'b10; 
                    
                end
                'b10: begin 
                    C_x <= xi; 
                    C_y <= yi;
                     step <= 'b11;
                end
                'b11: begin 
                    D_x = xi; 
                    D_y = yi;
                     flag <=    'b1;
                end 
            endcase
        end
    end else if (step == 2'b11) begin 
        out_valid = 'b1;
            if(is_trapezoid_mode) begin//trapex computation
                if (flag) begin
                    xo = C_x;
                    yo = C_y;
                    flag <='b0;
                    D_y = D_x;
                    Delt_Y1 = (A_y - C_y);
                    Delt_X2 = B_x - D_x;
                    Delt_X1 = A_x - C_x;
                end else begin
                    if ((xo == D_y) && (yo != A_y)) begin
                        yo = yo + 1;
                        Delt_Y2 = yo - C_y;
                        Area_K = Delt_X1 * Delt_Y2;
                        xo = C_x + (Area_K / Delt_Y1);
                        if (((Area_K % Delt_Y1 )!= 0) && ((Area_K<0) ^ (Delt_Y1<0)) && (Area_K != 0)) 
                            xo = xo - 1;
                        Area_K = Delt_X2 * Delt_Y2;
                        D_y = D_x + (Area_K / Delt_Y1);
                        if (((Area_K % Delt_Y1) != 0) && ((Area_K<0) ^ (Delt_Y1<0)) && (Area_K != 0)) 
                            D_y = D_y - 1;
                    end else if ((xo == D_y) && (yo == A_y)) begin
                        step <= 'b0;
                        flag <= 'b1;
                        out_valid = 'b0;
                        {xo, yo} = {8'b00000000, 8'b00000000}; 
                    end else begin
                        xo = xo + 1;
                    end
                end
            end else if(is_area_mode) begin//area computation
                step <= 'b0;
                Area_K = ((((A_x*B_y )+ B_x*C_y + C_x*D_y + D_x*A_y) - (A_y*B_x + B_y*C_x + C_y*D_x + D_y*A_x)) / 2);
                Area_K = (Area_K <0 )? -Area_K : Area_K; 
                {xo, yo} = {Area_K[15:8], Area_K[7:0]};//output
            end else if(is_circle_line_mode) begin//circle computation
                R_2 = ((D_x - C_x)**2 + (D_y - C_y)**2) * ((A_x - B_x)**2 + (A_y - B_y)**2);
                D_2 = ((A_x - B_x)*(C_y - A_y) - (A_y - B_y)*(C_x - A_x))**2;
                step <= 'b0;
                if (D_2 < R_2)begin 
                    {xo, yo} = {8'b00000000, 8'b00000001}; 
                end else if (D_2 == R_2)
                    {xo, yo} = {8'b00000000, 8'b00000010}; 
                else
                    {xo, yo} = {8'b00000000, 8'b00000000}; 
            end
    end else begin //default output
        out_valid = 'b0;
        {xo, yo}  = {8'b00000000, 8'b00000000};
    end
end

endmodule  