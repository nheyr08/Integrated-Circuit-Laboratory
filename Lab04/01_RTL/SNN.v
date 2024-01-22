//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Siamese Neural Network 
//   Author     		: Betsaleel Henry (henrybetsaleel@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SNN.v
//   Module Name : SNN
//   Release version : V1.0 (Release Date: 2023-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

// `include "/usr/synthesis/dw/sim_ver/DW_fp_addsub.v"
// `include "/usr/synthesis/dw/sim_ver/DW_fp_mult.v"
// `include "/usr/synthesis/dw/sim_ver/DW_fp_sum3"
// `include "/usr/synthesis/dw/sim_ver/DW_fp_sum4"
// `include "/usr/synthesis/dw/sim_ver/DW_fp_cmp"
// `include "/usr/synthesis/dw/sim_ver/DW_fp_mac"
// `include "/usr/synthesis/dw/sim_ver/DW_fp_div"
// `include "/usr/synthesis/dw/sim_ver/DW_fp_exp"

module SNN(
    //Input Port
    clk,
    rst_n,
    in_valid,
    Img,
    Kernel,
	Weight,
    Opt,

    //Output Port
    out_valid,
    out
    );


//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point parameter
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;
parameter inst_rnd = 3'b000;

input rst_n, clk, in_valid;
input [inst_sig_width+inst_exp_width:0] Img, Kernel, Weight;
input [1:0] Opt;

output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;

//input
reg [inst_sig_width+inst_exp_width:0] img1_1, img1_2, img1_3, img1_4, img1_5, img1_6, img1_7, img1_8, img1_9, img1_10, img1_11, img1_12, img1_13, img1_14, img1_15, img1_16;
reg [1:0] kernel_shift;
reg [inst_sig_width+inst_exp_width:0] cov_1, cov_2, cov_3, cov_4, cov_5, cov_6, cov_7, cov_8, cov_9, cov_10, cov_11, cov_12, cov_13, cov_14, cov_15, cov_16;
reg [inst_sig_width+inst_exp_width:0] max_1, max_2, max_3, max_4;
reg [inst_sig_width+inst_exp_width:0] p_1, p_2, p_3, p_4;

reg [inst_sig_width+inst_exp_width:0] kernel1, kernel2, kernel3, kernel4, kernel5, kernel6, kernel7, kernel8, kernel9, kernel10, kernel11, kernel12, kernel13, kernel14, kernel15, kernel16, kernel17, kernel18, kernel19, kernel20, kernel21, kernel22, kernel23, kernel24, kernel25, kernel26, kernel27;
reg [inst_sig_width+inst_exp_width:0] weight1, weight2, weight3, weight4;
reg [1:0] opt_save;

reg [6:0] tim;
reg time_start;

//time
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        time_start <= 'b0;
        tim <= 'd1;
    end
    else if(tim == 'd113) begin
        time_start <= 'b0;
        tim <= 'd1;
    end
    // else if(time_start) begin
    //     tim <= tim + 1;
    // end
    else if(in_valid || time_start) begin
        time_start <= 'b1;
        tim <= tim + 1'd1;
    end
end

//input
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        weight1 <= 'b0;
        weight2 <= 'b0;
        weight3 <= 'b0;
        weight4 <= 'b0;

        kernel1 <= 'b0;
        kernel2 <= 'b0;
        kernel3 <= 'b0;
        kernel4 <= 'b0;
        kernel5 <= 'b0;
        kernel6 <= 'b0;
        kernel7 <= 'b0;
        kernel8 <= 'b0;
        kernel9 <= 'b0;
        kernel10 <= 'b0;
        kernel11 <= 'b0;
        kernel12 <= 'b0;
        kernel13 <= 'b0;
        kernel14 <= 'b0;
        kernel15 <= 'b0;
        kernel16 <= 'b0;
        kernel17 <= 'b0;
        kernel18 <= 'b0;
        kernel19 <= 'b0;
        kernel20 <= 'b0;
        kernel21 <= 'b0;
        kernel22 <= 'b0;
        kernel23 <= 'b0;
        kernel24 <= 'b0;
        kernel25 <= 'b0;
        kernel26 <= 'b0;
        kernel27 <= 'b0;

        opt_save <= 'b0;
    end
    else if(tim == 'd113) begin
        weight1 <= 'b0;
        weight2 <= 'b0;
        weight3 <= 'b0;
        weight4 <= 'b0;

        kernel1 <= 'b0;
        kernel2 <= 'b0;
        kernel3 <= 'b0;
        kernel4 <= 'b0;
        kernel5 <= 'b0;
        kernel6 <= 'b0;
        kernel7 <= 'b0;
        kernel8 <= 'b0;
        kernel9 <= 'b0;
        kernel10 <= 'b0;
        kernel11 <= 'b0;
        kernel12 <= 'b0;
        kernel13 <= 'b0;
        kernel14 <= 'b0;
        kernel15 <= 'b0;
        kernel16 <= 'b0;
        kernel17 <= 'b0;
        kernel18 <= 'b0;
        kernel19 <= 'b0;
        kernel20 <= 'b0;
        kernel21 <= 'b0;
        kernel22 <= 'b0;
        kernel23 <= 'b0;
        kernel24 <= 'b0;
        kernel25 <= 'b0;
        kernel26 <= 'b0;
        kernel27 <= 'b0;

        opt_save <= 'b0;
    end
    else if (tim == 'd1) begin
        kernel1 <= Kernel;
        weight1 <= Weight;
        opt_save <= Opt;
    end
    else if (tim == 'd2) begin
        kernel2 <= Kernel;
        weight2 <= Weight;
    end
    else if (tim == 'd3) begin
        kernel3 <= Kernel;
        weight3 <= Weight;
    end
    else if (tim == 'd4) begin
        kernel4 <= Kernel;
        weight4 <= Weight;
    end
    else if (tim == 'd5) begin
        kernel5 <= Kernel;
    end
    else if (tim == 'd6) begin
        kernel6 <= Kernel;
    end
    else if (tim == 'd7) begin
        kernel7 <= Kernel;
    end
    else if (tim == 'd8) begin
        kernel8 <= Kernel;
    end
    else if (tim == 'd9) begin
        kernel9 <= Kernel;
    end
    else if (tim == 'd10) begin
        kernel10 <= Kernel;
    end
    else if (tim == 'd11) begin
        kernel11 <= Kernel;
    end
    else if (tim == 'd12) begin
        kernel12 <= Kernel;
    end
    else if (tim == 'd13) begin
        kernel13 <= Kernel;
    end
    else if (tim == 'd14) begin
        kernel14 <= Kernel;
    end
    else if (tim == 'd15) begin
        kernel15 <= Kernel;
    end
    else if (tim == 'd16) begin
        kernel16 <= Kernel;
    end
    else if (tim == 'd17) begin
        kernel17 <= Kernel;
    end
    else if (tim == 'd18) begin
        kernel18 <= Kernel;
    end
    else if (tim == 'd19) begin
        kernel19 <= Kernel;
    end
    else if (tim == 'd20) begin
        kernel20 <= Kernel;
    end
    else if (tim == 'd21) begin
        kernel21 <= Kernel;
    end
    else if (tim == 'd22) begin
        kernel22 <= Kernel;
    end
    else if (tim == 'd23) begin
        kernel23 <= Kernel;
    end
    else if (tim == 'd24) begin
        kernel24 <= Kernel;
    end
    else if (tim == 'd25) begin
        kernel25 <= Kernel;
    end
    else if (tim == 'd26) begin
        kernel26 <= Kernel;
    end
    else if (tim == 'd27) begin
        kernel27 <= Kernel;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        img1_1 <= 'b0;
        img1_2 <= 'b0;
        img1_3 <= 'b0;
        img1_4 <= 'b0;
        img1_5 <= 'b0;
        img1_6 <= 'b0;
        img1_7 <= 'b0;
        img1_8 <= 'b0;
        img1_9 <= 'b0;
        img1_10 <= 'b0;
        img1_11 <= 'b0;
        img1_12 <= 'b0;
        img1_13 <= 'b0;
        img1_14 <= 'b0;
        img1_15 <= 'b0;
        img1_16 <= 'b0;
    end
    else if(tim == 'd113) begin
        img1_1 <= 'b0;
        img1_2 <= 'b0;
        img1_3 <= 'b0;
        img1_4 <= 'b0;
        img1_5 <= 'b0;
        img1_6 <= 'b0;
        img1_7 <= 'b0;
        img1_8 <= 'b0;
        img1_9 <= 'b0;
        img1_10 <= 'b0;
        img1_11 <= 'b0;
        img1_12 <= 'b0;
        img1_13 <= 'b0;
        img1_14 <= 'b0;
        img1_15 <= 'b0;
        img1_16 <= 'b0;
    end
    else begin
        if (tim[3:0] == 'd1) begin// (tim == 'd1 || tim == 'd17 || tim == 'd33 || tim == 'd49 || tim == 'd65 || tim == 'd81) begin // fast
            img1_1 <= Img;
        end
        else if (tim[3:0] == 'd2) begin//(tim == 'd2 || tim == 'd18 || tim == 'd34 || tim == 'd50 || tim == 'd66 || tim == 'd82) begin
            img1_2 <= Img;
        end
        else if (tim[3:0] == 'd3) begin//(tim == 'd3 || tim == 'd19 || tim == 'd35 || tim == 'd51 || tim == 'd67 || tim == 'd83) begin
            img1_3 <= Img;
        end
        else if (tim[3:0] == 'd4) begin//(tim == 'd4 || tim == 'd20 || tim == 'd36 || tim == 'd52 || tim == 'd68 || tim == 'd84) begin
            img1_4 <= Img;
        end
        else if (tim[3:0] == 'd5) begin//(tim == 'd5 || tim == 'd21 || tim == 'd37 || tim == 'd53 || tim == 'd69 || tim == 'd85) begin
            img1_5 <= Img;
        end
        else if (tim[3:0] == 'd6) begin//(tim == 'd6 || tim == 'd22 || tim == 'd38 || tim == 'd54 || tim == 'd70 || tim == 'd86) begin
            img1_6 <= Img;
        end
        else if (tim[3:0] == 'd7) begin//(tim == 'd7 || tim == 'd23 || tim == 'd39 || tim == 'd55 || tim == 'd71 || tim == 'd87) begin
            img1_7 <= Img;
        end
        else if (tim[3:0] == 'd8) begin//(tim == 'd8 || tim == 'd24 || tim == 'd40 || tim == 'd56 || tim == 'd72 || tim == 'd88) begin
            img1_8 <= Img;
        end
        else if (tim[3:0] == 'd9) begin//(tim == 'd9 || tim == 'd25 || tim == 'd41 || tim == 'd57 || tim == 'd73 || tim == 'd89) begin
            img1_9 <= Img;
        end
        else if (tim[3:0] == 'd10) begin//(tim == 'd10 || tim == 'd26 || tim == 'd42 || tim == 'd58 || tim == 'd74 || tim == 'd90) begin
            img1_10 <= Img;
        end
        else if (tim[3:0] == 'd11) begin//(tim == 'd11 || tim == 'd27 || tim == 'd43 || tim == 'd59 || tim == 'd75 || tim == 'd91) begin
            img1_11 <= Img;
        end
        else if (tim[3:0] == 'd12) begin//(tim == 'd12 || tim == 'd28 || tim == 'd44 || tim == 'd60 || tim == 'd76 || tim == 'd92) begin
            img1_12 <= Img;
        end
        else if (tim[3:0] == 'd13) begin//(tim == 'd13 || tim == 'd29 || tim == 'd45 || tim == 'd61 || tim == 'd77 || tim == 'd93) begin
            img1_13 <= Img;
        end
        else if (tim[3:0] == 'd14) begin//(tim == 'd14 || tim == 'd30 || tim == 'd46 || tim == 'd62 || tim == 'd78 || tim == 'd94) begin
            img1_14 <= Img;
        end
        else if (tim[3:0] == 'd15) begin//(tim == 'd15 || tim == 'd31 || tim == 'd47 || tim == 'd63 || tim == 'd79 || tim == 'd95) begin
            img1_15 <= Img;
        end
        else if (tim[3:0] == 'd0) begin//(tim == 'd16 || tim == 'd32 || tim == 'd48 || tim == 'd64 || tim == 'd80 || tim == 'd96) begin
            img1_16 <= Img;
        end
    end
end

//conv
reg [inst_sig_width+inst_exp_width:0] mult_a1, mult_b1;
reg [inst_sig_width+inst_exp_width:0] mult_a2, mult_b2;
reg [inst_sig_width+inst_exp_width:0] mult_a3, mult_b3;
reg [inst_sig_width+inst_exp_width:0] mult_a4, mult_b4;
reg [inst_sig_width+inst_exp_width:0] mult_a5, mult_b5;
reg [inst_sig_width+inst_exp_width:0] mult_a6, mult_b6;
reg [inst_sig_width+inst_exp_width:0] mult_a7, mult_b7;
reg [inst_sig_width+inst_exp_width:0] mult_a8, mult_b8;
reg [inst_sig_width+inst_exp_width:0] mult_a9, mult_b9;
wire [inst_sig_width+inst_exp_width:0] mult_z1, mult_z2, mult_z3, mult_z4, mult_z5, mult_z6, mult_z7, mult_z8, mult_z9;
// reg [inst_sig_width+inst_exp_width:0]

DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_1 (
	.a(mult_a1), .b(mult_b1), .rnd(inst_rnd), .z(mult_z1));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_2 (
	.a(mult_a2), .b(mult_b2), .rnd(inst_rnd), .z(mult_z2));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_3 (
	.a(mult_a3), .b(mult_b3), .rnd(inst_rnd), .z(mult_z3));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_4 (
	.a(mult_a4), .b(mult_b4), .rnd(inst_rnd), .z(mult_z4));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_5 (
	.a(mult_a5), .b(mult_b5), .rnd(inst_rnd), .z(mult_z5));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_6 (
	.a(mult_a6), .b(mult_b6), .rnd(inst_rnd), .z(mult_z6));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_7 (
	.a(mult_a7), .b(mult_b7), .rnd(inst_rnd), .z(mult_z7));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_8 (
	.a(mult_a8), .b(mult_b8), .rnd(inst_rnd), .z(mult_z8));
DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mult_9 (
	.a(mult_a9), .b(mult_b9), .rnd(inst_rnd), .z(mult_z9));

reg [inst_sig_width+inst_exp_width:0] sum3_a1, sum3_b1, sum3_c1;
reg [inst_sig_width+inst_exp_width:0] sum3_a2, sum3_b2, sum3_c2;
reg [inst_sig_width+inst_exp_width:0] sum3_a3, sum3_b3, sum3_c3;
wire [inst_sig_width+inst_exp_width:0] sum3_z1, sum3_z2, sum3_z3;

reg [inst_sig_width+inst_exp_width:0] sum3_z1_save, sum3_z2_save, sum3_z3_save;

DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) sum3_1 (
	.a(sum3_a1), .b(sum3_b1), .c(sum3_c1), .rnd(inst_rnd), .z(sum3_z1));
DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) sum3_2 (
	.a(sum3_a2), .b(sum3_b2), .c(sum3_c2), .rnd(inst_rnd), .z(sum3_z2));
DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) sum3_3 (
	.a(sum3_a3), .b(sum3_b3), .c(sum3_c3), .rnd(inst_rnd), .z(sum3_z3));

always @(*) begin
    // if(!rst_n) begin
    //     kernel_shift = 2'b00;
    // end
    // else if (tim == 'd57) begin
    //     kernel_shift = 2'b00;
    // end
    // else if (tim == 'd25 || tim == 'd73) begin
    //     kernel_shift = 2'b01;
    // end
    // else if (tim == 'd41 || tim == 'd89) begin
    //     kernel_shift = 2'b10;
    // end
    //kernel
    if (kernel_shift == 2'b00) begin
        mult_b1 = kernel1;
        mult_b2 = kernel2;
        mult_b3 = kernel3;
        mult_b4 = kernel4;
        mult_b5 = kernel5;
        mult_b6 = kernel6;
        mult_b7 = kernel7;
        mult_b8 = kernel8;
        mult_b9 = (tim == 'd9) ? Kernel : kernel9;
    end
    else if (kernel_shift == 2'b01) begin
        mult_b1 = kernel10;
        mult_b2 = kernel11;
        mult_b3 = kernel12;
        mult_b4 = kernel13;
        mult_b5 = kernel14;
        mult_b6 = kernel15;
        mult_b7 = kernel16;
        mult_b8 = kernel17;
        mult_b9 = kernel18;
    end
    else if(kernel_shift == 2'b10) begin
        mult_b1 = kernel19;
        mult_b2 = kernel20;
        mult_b3 = kernel21;
        mult_b4 = kernel22;
        mult_b5 = kernel23;
        mult_b6 = kernel24;
        mult_b7 = kernel25;
        mult_b8 = kernel26;
        mult_b9 = kernel27;
    end
    else begin
        mult_b1 = 'b0;
        mult_b2 = 'b0;
        mult_b3 = 'b0;
        mult_b4 = 'b0;
        mult_b5 = 'b0;
        mult_b6 = 'b0;
        mult_b7 = 'b0;
        mult_b8 = 'b0;
        mult_b9 = 'b0;
    end

    //img
    if (tim[3:0] == 'd9) begin//(tim == 'd9 || tim == 'd25 || tim == 'd41 || tim == 'd57 || tim == 'd73 || tim == 'd89) begin //1 // fast
        mult_a1 = (opt_save[0]) ? 'b0 : img1_1;
        mult_a2 = (opt_save[0]) ? 'b0 : img1_1;
        mult_a3 = (opt_save[0]) ? 'b0 : img1_2;
        mult_a4 = (opt_save[0]) ? 'b0 : img1_1;
        mult_a5 = img1_1;
        mult_a6 = img1_2;
        mult_a7 = (opt_save[0]) ? 'b0 : img1_5;
        mult_a8 = img1_5;
        mult_a9 = img1_6;
    end
    else if(tim[3:0] == 'd10) begin//(tim == 'd10 || tim == 'd26 || tim == 'd42 || tim == 'd58 || tim == 'd74 || tim == 'd90) begin //2
        mult_a1 = (opt_save[0]) ? 'b0 : img1_1;
        mult_a2 = (opt_save[0]) ? 'b0 : img1_2;
        mult_a3 = (opt_save[0]) ? 'b0 : img1_3;
        mult_a4 = img1_1;
        mult_a5 = img1_2;
        mult_a6 = img1_3;
        mult_a7 = img1_5;
        mult_a8 = img1_6;
        mult_a9 = img1_7;
    end
    else if(tim[3:0] == 'd11) begin//(tim == 'd11 || tim == 'd27 || tim == 'd43 || tim == 'd59 || tim == 'd75 || tim == 'd91) begin //3
        mult_a1 = (opt_save[0]) ? 'b0 : img1_2;
        mult_a2 = (opt_save[0]) ? 'b0 : img1_3;
        mult_a3 = (opt_save[0]) ? 'b0 : img1_4;
        mult_a4 = img1_2;
        mult_a5 = img1_3;
        mult_a6 = img1_4;
        mult_a7 = img1_6;
        mult_a8 = img1_7;
        mult_a9 = img1_8;
    end
    else if(tim[3:0] == 'd12) begin//(tim == 'd12 || tim == 'd28 || tim == 'd44 || tim == 'd60 || tim == 'd76 || tim == 'd92) begin //4
        mult_a1 = (opt_save[0]) ? 'b0 : img1_3;
        mult_a2 = (opt_save[0]) ? 'b0 : img1_4;
        mult_a3 = (opt_save[0]) ? 'b0 : img1_4;
        mult_a4 = img1_3;
        mult_a5 = img1_4;
        mult_a6 = (opt_save[0]) ? 'b0 : img1_4;
        mult_a7 = img1_7;
        mult_a8 = img1_8;
        mult_a9 = (opt_save[0]) ? 'b0 : img1_8;
    end
    else if(tim[3:0] == 'd13) begin//(tim == 'd13 || tim == 'd29 || tim == 'd45 || tim == 'd61 || tim == 'd77 || tim == 'd93) begin //5
        mult_a1 = (opt_save[0]) ? 'b0 : img1_1;
        mult_a2 = img1_1;
        mult_a3 = img1_2;
        mult_a4 = (opt_save[0]) ? 'b0 : img1_5;
        mult_a5 = img1_5;
        mult_a6 = img1_6;
        mult_a7 = (opt_save[0]) ? 'b0 : img1_9;
        mult_a8 = img1_9;
        mult_a9 = img1_10;
    end
    else if(tim[3:0] == 'd14) begin//(tim == 'd14 || tim == 'd30 || tim == 'd46 || tim == 'd62 || tim == 'd78 || tim == 'd94) begin //6
        mult_a1 = img1_1;
        mult_a2 = img1_2;
        mult_a3 = img1_3;
        mult_a4 = img1_5;
        mult_a5 = img1_6;
        mult_a6 = img1_7;
        mult_a7 = img1_9;
        mult_a8 = img1_10;
        mult_a9 = img1_11;
    end
    else if(tim[3:0] == 'd15) begin//(tim == 'd15 || tim == 'd31 || tim == 'd47 || tim == 'd63 || tim == 'd79 || tim == 'd95) begin //7
        mult_a1 = img1_2;
        mult_a2 = img1_3;
        mult_a3 = img1_4;
        mult_a4 = img1_6;
        mult_a5 = img1_7;
        mult_a6 = img1_8;
        mult_a7 = img1_10;
        mult_a8 = img1_11;
        mult_a9 = img1_12;
    end
    else if(tim[3:0] == 'd0) begin//(tim == 'd16 || tim == 'd32 || tim == 'd48 || tim == 'd64 || tim == 'd80 || tim == 'd96) begin //8
        mult_a1 = img1_3;
        mult_a2 = img1_4;
        mult_a3 = (opt_save[0]) ? 'b0 : img1_4;
        mult_a4 = img1_7;
        mult_a5 = img1_8;
        mult_a6 = (opt_save[0]) ? 'b0 : img1_8;
        mult_a7 = img1_11;
        mult_a8 = img1_12;
        mult_a9 = (opt_save[0]) ? 'b0 : img1_12;
    end
    else if(tim[3:0] == 'd1 && tim != 'd1) begin//(tim == 'd17 || tim == 'd33 || tim == 'd49 || tim == 'd65 || tim == 'd81 || tim == 'd97) begin //9
        mult_a1 = (opt_save[0]) ? 'b0 : img1_5;
        mult_a2 = img1_5;
        mult_a3 = img1_6;
        mult_a4 = (opt_save[0]) ? 'b0 : img1_9;
        mult_a5 = img1_9;
        mult_a6 = img1_10;
        mult_a7 = (opt_save[0]) ? 'b0 : img1_13;
        mult_a8 = img1_13;
        mult_a9 = img1_14;
    end
    else if(tim[3:0] == 'd2 && tim != 'd2) begin//(tim == 'd18 || tim == 'd34 || tim == 'd50 || tim == 'd66 || tim == 'd82 || tim == 'd98) begin //10
        mult_a1 = img1_5;
        mult_a2 = img1_6;
        mult_a3 = img1_7;
        mult_a4 = img1_9;
        mult_a5 = img1_10;
        mult_a6 = img1_11;
        mult_a7 = img1_13;
        mult_a8 = img1_14;
        mult_a9 = img1_15;
    end
    else if(tim[3:0] == 'd3 && tim != 'd3) begin//(tim == 'd19 || tim == 'd35 || tim == 'd51 || tim == 'd67 || tim == 'd83 || tim == 'd99) begin //11
        mult_a1 = img1_6;
        mult_a2 = img1_7;
        mult_a3 = img1_8;
        mult_a4 = img1_10;
        mult_a5 = img1_11;
        mult_a6 = img1_12;
        mult_a7 = img1_14;
        mult_a8 = img1_15;
        mult_a9 = img1_16;
    end
    else if(tim[3:0] == 'd4 && tim != 'd4) begin//(tim == 'd20 || tim == 'd36 || tim == 'd52 || tim == 'd68 || tim == 'd84 || tim == 'd100) begin //12
        mult_a1 = img1_7;
        mult_a2 = img1_8;
        mult_a3 = (opt_save[0]) ? 'b0 : img1_8;
        mult_a4 = img1_11;
        mult_a5 = img1_12;
        mult_a6 = (opt_save[0]) ? 'b0 : img1_12;
        mult_a7 = img1_15;
        mult_a8 = img1_16;
        mult_a9 = (opt_save[0]) ? 'b0 : img1_16;
    end
    else if(tim[3:0] == 'd5 && tim != 'd5) begin//(tim == 'd21 || tim == 'd37 || tim == 'd53 || tim == 'd69 || tim == 'd85 || tim == 'd101) begin //13
        mult_a1 = (opt_save[0]) ? 'b0 : img1_9;
        mult_a2 = img1_9;
        mult_a3 = img1_10;
        mult_a4 = (opt_save[0]) ? 'b0 : img1_13;
        mult_a5 = img1_13;
        mult_a6 = img1_14;
        mult_a7 = (opt_save[0]) ? 'b0 : img1_13;
        mult_a8 = (opt_save[0]) ? 'b0 : img1_13;
        mult_a9 = (opt_save[0]) ? 'b0 : img1_14;
    end
    else if(tim[3:0] == 'd6 && tim != 'd6) begin//(tim == 'd22 || tim == 'd38 || tim == 'd54 || tim == 'd70 || tim == 'd86 || tim == 'd102) begin //14
        mult_a1 = img1_9;
        mult_a2 = img1_10;
        mult_a3 = img1_11;
        mult_a4 = img1_13;
        mult_a5 = img1_14;
        mult_a6 = img1_15;
        mult_a7 = (opt_save[0]) ? 'b0 : img1_13;
        mult_a8 = (opt_save[0]) ? 'b0 : img1_14;
        mult_a9 = (opt_save[0]) ? 'b0 : img1_15;
    end
    else if(tim[3:0] == 'd7 && tim != 'd7) begin//(tim == 'd23 || tim == 'd39 || tim == 'd55 || tim == 'd71 || tim == 'd87 || tim == 'd103) begin //15
        mult_a1 = img1_10;
        mult_a2 = img1_11;
        mult_a3 = img1_12;
        mult_a4 = img1_14;
        mult_a5 = img1_15;
        mult_a6 = img1_16;
        mult_a7 = (opt_save[0]) ? 'b0 : img1_14;
        mult_a8 = (opt_save[0]) ? 'b0 : img1_15;
        mult_a9 = (opt_save[0]) ? 'b0 : img1_16;
    end
    else if(tim[3:0] == 'd8 && tim != 'd8) begin//(tim == 'd24 || tim == 'd40 || tim == 'd56 || tim == 'd72 || tim == 'd88 || tim == 'd104) begin //16
        mult_a1 = img1_11;
        mult_a2 = img1_12;
        mult_a3 = (opt_save[0]) ? 'b0 : img1_12;
        mult_a4 = img1_15;
        mult_a5 = img1_16;
        mult_a6 = (opt_save[0]) ? 'b0 : img1_16;
        mult_a7 = (opt_save[0]) ? 'b0 : img1_15;
        mult_a8 = (opt_save[0]) ? 'b0 : img1_16;
        mult_a9 = (opt_save[0]) ? 'b0 : img1_16;
        // kernel_shift = (kernel_shift == 2'b00) ? 2'b01 : (kernel_shift == 2'b01) ? 2'b10 : 2'b00;
    end
    else begin
        mult_a1 = 'b0;
        mult_a2 = 'b0;
        mult_a3 = 'b0;
        mult_a4 = 'b0;
        mult_a5 = 'b0;
        mult_a6 = 'b0;
        mult_a7 = 'b0;
        mult_a8 = 'b0;
        mult_a9 = 'b0;
        // kernel_shift = (kernel_shift == 2'b00) ? 2'b01 : (kernel_shift == 2'b01) ? 2'b10 : 2'b00;
    end
    
    sum3_a1 = mult_z1;
    sum3_b1 = mult_z2;
    sum3_c1 = mult_z3;
    sum3_a2 = mult_z4;
    sum3_b2 = mult_z5;
    sum3_c2 = mult_z6;
    sum3_a3 = mult_z7;
    sum3_b3 = mult_z8;
    sum3_c3 = mult_z9;

    // sum3_z1_save = sum3_z1;
    // sum3_z2_save = sum3_z2;
    // sum3_z3_save = sum3_z3;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        kernel_shift <= 2'b00;
    end
    else if(tim == 'd113) begin
        kernel_shift <= 2'b00;
    end
    // else if (tim == 'd57) begin
    //     kernel_shift = 2'b00;
    // end
    // else if (tim == 'd25 || tim == 'd73) begin
    //     kernel_shift = 2'b01;
    // end
    // else if (tim == 'd41 || tim == 'd89) begin
    //     kernel_shift = 2'b10;
    // end
    else if(tim[3:0] == 'd8 && tim != 'd8) begin//(tim == 'd24 || tim == 'd40 || tim == 'd56 || tim == 'd72 || tim == 'd88 || tim == 'd104) begin //16 fast
        kernel_shift <= (kernel_shift == 2'b00) ? 2'b01 : (kernel_shift == 2'b01) ? 2'b10 : 2'b00;
    end
    // else begin
    //     sum3_z1_save <= sum3_z1;
    //     sum3_z2_save <= sum3_z2;
    //     sum3_z3_save <= sum3_z3;
    // end
end

always @(posedge clk) begin
    sum3_z1_save <= sum3_z1;
    sum3_z2_save <= sum3_z2;
    sum3_z3_save <= sum3_z3;
end

reg [inst_sig_width+inst_exp_width:0] sum4_a1, sum4_b1, sum4_c1, sum4_d1;
wire [inst_sig_width+inst_exp_width:0] sum4_z1;

DW_fp_sum4 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) sum4_1 (
	.a(sum4_a1), .b(sum4_b1), .c(sum4_c1), .d(sum4_d1), .rnd(inst_rnd), .z(sum4_z1));

reg [inst_sig_width+inst_exp_width:0] cmp_a1, cmp_b1;//, cmp_agtb1;
wire cmp_agtb1;

DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) cmp_1 (
	.a(cmp_a1), .b(cmp_b1), .agtb(cmp_agtb1));

//max fully
reg [inst_sig_width+inst_exp_width:0] mac_a1, mac_b1, mac_c1;
reg [inst_sig_width+inst_exp_width:0] mac_a2, mac_b2, mac_c2;
wire [inst_sig_width+inst_exp_width:0] mac_z1, mac_z2;

DW_fp_mac #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mac_1 (
	.a(mac_a1), .b(mac_b1), .c(mac_c1), .rnd(inst_rnd), .z(mac_z1));

DW_fp_mac #(inst_sig_width, inst_exp_width, inst_ieee_compliance) mac_2 (
	.a(mac_a2), .b(mac_b2), .c(mac_c2), .rnd(inst_rnd), .z(mac_z2));

reg [inst_sig_width+inst_exp_width:0] cmp_a2, cmp_b2;//, cmp_agtb2;
reg [inst_sig_width+inst_exp_width:0] cmp_a3, cmp_b3;//, cmp_agtb3;
// reg [inst_sig_width+inst_exp_width:0] cmp_a4, cmp_b4;//, cmp_agtb4;
wire cmp_agtb2, cmp_agtb3;//, cmp_agtb4;

DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) cmp_2 (
	.a(cmp_a2), .b(cmp_b2), .agtb(cmp_agtb2));

DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) cmp_3 (
	.a(cmp_a3), .b(cmp_b3), .agtb(cmp_agtb3));

// DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance) cmp_4 (
// 	.a(cmp_a4), .b(cmp_b4), .agtb(cmp_agtb4));

reg [inst_sig_width+inst_exp_width:0] fully1, fully2, fully3, fully4;

reg [3:0] nor_max, nor_min, nor_and;
reg [3:0] nor_and_wire;

reg [inst_sig_width+inst_exp_width:0] addsub_a1, addsub_a2, addsub_a3, addsub_a4;
reg [inst_sig_width+inst_exp_width:0] addsub_b1, addsub_b2, addsub_b3, addsub_b4;
reg addsub_op1, addsub_op2, addsub_op3, addsub_op4;
wire [inst_sig_width+inst_exp_width:0] addsub_z1, addsub_z2, addsub_z3, addsub_z4;

//min-max normalize
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) addsub_1 (
	.a(addsub_a1), .b(addsub_b1), .op(addsub_op1), .rnd(inst_rnd), .z(addsub_z1));

DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) addsub_2 (
	.a(addsub_a2), .b(addsub_b2), .op(addsub_op2), .rnd(inst_rnd), .z(addsub_z2));

DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) addsub_3 (
	.a(addsub_a3), .b(addsub_b3), .op(addsub_op3), .rnd(inst_rnd), .z(addsub_z3));

DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) addsub_4 (
	.a(addsub_a4), .b(addsub_b4), .op(addsub_op4), .rnd(inst_rnd), .z(addsub_z4));

reg [inst_sig_width+inst_exp_width:0] div_a1, div_b1;
reg [inst_sig_width+inst_exp_width:0] div_a2, div_b2;
wire [inst_sig_width+inst_exp_width:0] div_z1, div_z2;

DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance) div_1 (
	.a(div_a1), .b(div_b1), .rnd(inst_rnd), .z(div_z1));

DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance) div_2 (
	.a(div_a2), .b(div_b2), .rnd(inst_rnd), .z(div_z2));

//activation
reg [inst_sig_width+inst_exp_width:0] exp_a1, exp_a2;
wire [inst_sig_width+inst_exp_width:0] exp_z1, exp_z2;

DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) exp_1 (
	.a(exp_a1), .z(exp_z1));
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) exp_2 (
	.a(exp_a2), .z(exp_z2));


always @(*) begin
    if (tim == 'd48 || tim == 'd96) begin
        mac_a1 = max_1;
        mac_b1 = weight1;
        mac_c1 = fully1;
        mac_a2 = max_1;
        mac_b2 = weight2;
        mac_c2 = fully2;
    end
    else if (tim == 'd50 || tim == 'd98) begin
        mac_a1 = max_2;
        mac_b1 = weight3;
        mac_c1 = fully1;
        mac_a2 = max_2;
        mac_b2 = weight4;
        mac_c2 = fully2;
        // cmp_a2 = mac_z1;
        // cmp_b2 = mac_z2;
    end
    else if (tim == 'd56 || tim == 'd104) begin
        mac_a1 = max_3;
        mac_b1 = weight1;
        mac_c1 = fully3;
        mac_a2 = max_3;
        mac_b2 = weight2;
        mac_c2 = fully4;
    end
    else if (tim == 'd58 || tim == 'd106) begin
        mac_a1 = max_4;
        mac_b1 = weight3;
        mac_c1 = fully3;
        mac_a2 = max_4;
        mac_b2 = weight4;
        mac_c2 = fully4;
    end
    else begin
        mac_a1 = 1'b0;
        mac_b1 = 1'b0;
        mac_c1 = 1'b0;
        mac_a2 = 1'b0;
        mac_b2 = 1'b0;
        mac_c2 = 1'b0;
    end
end

always @(*) begin
    if (tim == 'd59 || tim == 'd107) begin
        nor_and_wire = nor_max | nor_min;
    end
    else begin
        nor_and_wire = 'b0;
    end
end

always @(*) begin
    if(tim == 'd112) begin
        sum4_a1 = {1'b0, addsub_z1[30:0]};
        sum4_b1 = {1'b0, addsub_z2[30:0]};
        sum4_c1 = {1'b0, addsub_z3[30:0]};
        sum4_d1 = {1'b0, addsub_z4[30:0]};
    end
    else if (tim[3:0] == 'd10)begin//tim == 'd10 || tim == 'd26 || tim == 'd42 || tim == 'd58 || tim == 'd74 || tim == 'd90) begin  // fast
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = (tim == 'd58) ? 'b0 : cov_1;
    end
    else if (tim[3:0] == 'd11)begin//(tim == 'd11 || tim == 'd27 || tim == 'd43 || tim == 'd59 || tim == 'd75 || tim == 'd91) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_2;
    end
    else if (tim[3:0] == 'd12)begin//(tim == 'd12 || tim == 'd28 || tim == 'd44 || tim == 'd60 || tim == 'd76 || tim == 'd92) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_3;
    end
    else if (tim[3:0] == 'd13)begin//(tim == 'd13 || tim == 'd29 || tim == 'd45 || tim == 'd61 || tim == 'd77 || tim == 'd93) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_4;
    end
    else if (tim[3:0] == 'd14)begin//(tim == 'd14 || tim == 'd30 || tim == 'd46 || tim == 'd62 || tim == 'd78 || tim == 'd94) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_5;
    end
    else if (tim[3:0] == 'd15)begin//(tim == 'd15 || tim == 'd31 || tim == 'd47 || tim == 'd63 || tim == 'd79 || tim == 'd95) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_6;
    end
    else if (tim[3:0] == 'd0) begin// && tim != 'd112)begin//(tim == 'd16 || tim == 'd32 || tim == 'd48 || tim == 'd64 || tim == 'd80 || tim == 'd96) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_7;
    end
    else if (tim[3:0] == 'd1 && tim != 'd1) begin//(tim == 'd17 || tim == 'd33 || tim == 'd49 || tim == 'd65 || tim == 'd81 || tim == 'd97) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_8;
    end
    else if (tim[3:0] == 'd2 && tim != 'd2) begin//(tim == 'd18 || tim == 'd34 || tim == 'd50 || tim == 'd66 || tim == 'd82 || tim == 'd98) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_9;
    end
    else if (tim[3:0] == 'd3 && tim != 'd3) begin//(tim == 'd19 || tim == 'd35 || tim == 'd51 || tim == 'd67 || tim == 'd83 || tim == 'd99) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_10;
    end
    else if (tim[3:0] == 'd4 && tim != 'd4) begin//(tim == 'd20 || tim == 'd36 || tim == 'd52 || tim == 'd68 || tim == 'd84 || tim == 'd100) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_11;
    end
    else if (tim[3:0] == 'd5 && tim != 'd5) begin//(tim == 'd21 || tim == 'd37 || tim == 'd53 || tim == 'd69 || tim == 'd85 || tim == 'd101) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_12;
    end
    else if (tim[3:0] == 'd6 && tim != 'd6) begin//(tim == 'd22 || tim == 'd38 || tim == 'd54 || tim == 'd70 || tim == 'd86 || tim == 'd102) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_13;
    end
    else if (tim[3:0] == 'd7 && tim != 'd7) begin//(tim == 'd23 || tim == 'd39 || tim == 'd55 || tim == 'd71 || tim == 'd87 || tim == 'd103) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_14;
    end
    else if (tim[3:0] == 'd8 && tim != 'd8) begin//(tim == 'd24 || tim == 'd40 || tim == 'd56 || tim == 'd72 || tim == 'd88 || tim == 'd104) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_15;
    end
    else if (tim[3:0] == 'd9 && tim != 'd9) begin//(tim == 'd25 || tim == 'd41 || tim == 'd57 || tim == 'd73 || tim == 'd89 || tim == 'd105) begin
        sum4_a1 = sum3_z1_save;
        sum4_b1 = sum3_z2_save;
        sum4_c1 = sum3_z3_save;
        sum4_d1 = cov_16;
    end
    else begin
        sum4_a1 = 1'b0;
        sum4_b1 = 1'b0;
        sum4_c1 = 1'b0;
        sum4_d1 = 1'b0;
    end
end

always @(*) begin
    if (tim == 'd42 || tim == 'd90) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_1;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd43 || tim == 'd91) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_1;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd44 || tim == 'd92) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_2;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd45 || tim == 'd93) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_2;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd46 || tim == 'd94) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_1;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd47 || tim == 'd95) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_1;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd48 || tim == 'd96) begin
        // if (tim == 'd48 || tim == 'd96) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_2;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd49 || tim == 'd97) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_2;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd50 || tim == 'd98) begin
        // if (tim == 'd50 || tim == 'd98) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_3;
        // end
        cmp_a2 = mac_z1;
        cmp_b2 = mac_z2;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
        
    end
    else if (tim == 'd51 || tim == 'd99) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_3;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd52 || tim == 'd100) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_4;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd53 || tim == 'd101) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_4;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd54 || tim == 'd102) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_3;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd55 || tim == 'd103) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_3;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd56 || tim == 'd104) begin
        // if (tim == 'd56 || tim == 'd104) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_4;
        // end
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd57 || tim == 'd105) begin
        cmp_a1 = sum4_z1;
        cmp_b1 = max_4;
        cmp_a2 = 'b0;
        cmp_b2 = 'b0;
        cmp_a3 = 'b0;
        cmp_b3 = 'b0;
    end
    else if (tim == 'd58 || tim == 'd106) begin
        cmp_a2 = mac_z1;
        cmp_b2 = mac_z2;
        cmp_a3 = (nor_max[3]) ? fully1 : fully2;
        cmp_b3 = (cmp_agtb2) ? mac_z1 : mac_z2;
        cmp_a1 = (nor_min[3]) ? fully1 : fully2;
        cmp_b1 = (cmp_agtb2) ? mac_z2 : mac_z1;
    end
    else begin
        cmp_a1 = 1'b0;
        cmp_b1 = 1'b0;
        cmp_a2 = 1'b0;
        cmp_b2 = 1'b0;
        cmp_a3 = 1'b0;
        cmp_b3 = 1'b0;
    end
end

always @(*) begin
    if (tim == 'd60 || tim == 'd108) begin
        div_a1 = max_3;
        div_b1 = max_1;
        div_a2 = max_4;
        div_b2 = max_1;
    end
    else if (tim == 'd63 || tim == 'd111) begin
        div_a1 = max_3;
        div_b1 = max_1;
        div_a2 = max_4;
        div_b2 = max_2;
    end
    else begin
        div_a1 = 1'b0;
        div_b1 = 1'b0;
        div_a2 = 1'b0;
        div_b2  = 1'b0;
    end
end

always @(*) begin
    if (tim == 'd61 || tim == 'd109) begin
        if (~opt_save[1]) begin // sigmoid
            exp_a1 = {~max_3[31], max_3[30:0]};
            exp_a2 = {~max_4[31], max_4[30:0]};
        end
        else begin // tanh
            exp_a1[31] = ~max_3[31];
            exp_a1[30:23] = max_3[30:23] + 1;
            exp_a1[22:0] = max_3[22:0];

            exp_a2[31] = ~max_4[31];
            exp_a2[30:23] = max_4[30:23] + 1;
            exp_a2[22:0] = max_4[22:0];
        end
    end
    else begin
        exp_a1 = 1'b0;
        exp_a2 = 1'b0;
    end
end

always @(*) begin
    if (tim == 'd59 || tim == 'd107) begin
        if (nor_and_wire == 4'b0011) begin
            addsub_a1 = fully1;
            addsub_a2 = fully2;
        end
        else if (nor_and_wire == 4'b0101) begin
            addsub_a1 = fully1;
            addsub_a2 = fully3;
        end
        else if (nor_and_wire == 4'b1001) begin
            addsub_a1 = fully2;
            addsub_a2 = fully3;
        end
        else if (nor_and_wire == 4'b0110) begin
            addsub_a1 = fully1;
            addsub_a2 = fully4;
        end
        else if (nor_and_wire == 4'b1010) begin
            addsub_a1 = fully2;
            addsub_a2 = fully4;
        end
        else begin //1100
            addsub_a1 = fully3;
            addsub_a2 = fully4;
        end
        addsub_b1 = max_2;
        addsub_b2 = max_2;
        addsub_op1 = 'b1;
        addsub_op2 = 'b1;
        addsub_a3 = max_1;
        addsub_b3 = max_2;
        addsub_op3 = 'b1;

        addsub_a4  = 'b0;
        addsub_b4  = 'b0;
        addsub_op4 = 'b0;
    end
    else if (tim == 'd62 || tim == 'd110) begin
        addsub_a1 = {1'd0, 8'd127, 23'd0}; // numer 1
        addsub_b1 = max_3;
        addsub_op1 = 1'b0;
        addsub_a2 = {1'd0, 8'd127, 23'd0};
        addsub_b2 = max_4;
        addsub_op2 = 1'b0;
        // if (opt_save[1]) begin // tanh // check
        addsub_a3 = {1'd0, 8'd127, 23'd0};
        addsub_b3 = max_3;
        addsub_op3 = 1'b1;
        addsub_a4 = {1'd0, 8'd127, 23'd0};
        addsub_b4 = max_4;
        addsub_op4 = 1'b1;
        // end
    end
    else if(tim == 'd112) begin
        addsub_a1 = p_1; // numer 1
        addsub_b1 = fully1;
        addsub_op1 = 1'b1;
        addsub_a2 = p_2; // numer 1
        addsub_b2 = fully2;
        addsub_op2 = 1'b1;
        addsub_a3 = p_3; // numer 1
        addsub_b3 = fully3;
        addsub_op3 = 1'b1;
        addsub_a4 = p_4; // numer 1
        addsub_b4 = fully4;
        addsub_op4 = 1'b1;
    end
    else begin
        addsub_a1 =  'b0;// numer 1
        addsub_b1 =  'b0;
        addsub_op1 = 'b0;
        addsub_a2 =  'b0;// numer 1
        addsub_b2 =  'b0;
        addsub_op2 = 'b0;
        addsub_a3 =  'b0;// numer 1
        addsub_b3 =  'b0;
        addsub_op3 = 'b0;
        addsub_a4 =  'b0;// numer 1
        addsub_b4 =  'b0;
        addsub_op4 = 'b0;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out <= 'b0;
        out_valid <= 'b0;
        cov_1 <= 'b0;
        cov_2 <= 'b0;
        cov_3 <= 'b0;
        cov_4 <= 'b0;
        cov_5 <= 'b0;
        cov_6 <= 'b0;
        cov_7 <= 'b0;
        cov_8 <= 'b0;
        cov_9 <= 'b0;
        cov_10 <= 'b0;
        cov_11 <= 'b0;
        cov_12 <= 'b0;
        cov_13 <= 'b0;
        cov_14 <= 'b0;
        cov_15 <= 'b0;
        cov_16 <= 'b0;

        //next
        p_1 <= fully1;
        p_2 <= fully2;
        p_3 <= fully3;
        p_4 <= fully4;

        max_1 <= {9'b111111111, 23'd0};
        max_2 <= {9'b111111111, 23'd0};
        max_3 <= {9'b111111111, 23'd0};
        max_4 <= {9'b111111111, 23'd0};

        fully1 <= 'b0;
        fully2 <= 'b0;
        fully3 <= 'b0;
        fully4 <= 'b0;

        nor_max <= 'b0;
        nor_min <= 'b0;
    end
    else if(tim == 'd58) begin
        cov_1 <= 'b0;
        cov_2 <= 'b0;
        cov_3 <= 'b0;
        cov_4 <= 'b0;
        cov_5 <= 'b0;
        cov_6 <= 'b0;
        cov_7 <= 'b0;
        cov_8 <= 'b0;
        cov_9 <= 'b0;
        cov_10 <= 'b0;
        cov_11 <= 'b0;
        cov_12 <= 'b0;
        cov_13 <= 'b0;
        cov_14 <= 'b0;
        cov_15 <= 'b0;
        cov_16 <= 'b0;

        cov_1 <= sum4_z1;
        // if (tim == 'd42 || tim == 'd90) begin
        //     max_1 <= (cmp_agtb1) ? sum4_z1 : max_1;
        // end

        fully3 <= mac_z1;
        fully4 <= mac_z2;
        nor_max <= (cmp_agtb3) ? ((nor_max[3]) ? 4'b1000 : 4'b0100) : ((cmp_agtb2) ? 4'b0010 : 4'b0001);
        nor_min <= (cmp_agtb1) ? ((cmp_agtb2) ? 4'b0001 : 4'b0010) : ((nor_min[3]) ? 4'b1000 : 4'b0100);
        max_1 <= (cmp_agtb3) ? ((nor_max[3]) ? fully1 : fully2) : ((cmp_agtb2) ? mac_z1 : mac_z2); //x_max
        max_2 <= (cmp_agtb1) ? ((cmp_agtb2) ? mac_z2 : mac_z1) : ((nor_min[3]) ? fully1 : fully2); //x_min
    end
    else if(tim == 'd113) begin
        cov_1 <= 'b0;
        cov_2 <= 'b0;
        cov_3 <= 'b0;
        cov_4 <= 'b0;
        cov_5 <= 'b0;
        cov_6 <= 'b0;
        cov_7 <= 'b0;
        cov_8 <= 'b0;
        cov_9 <= 'b0;
        cov_10 <= 'b0;
        cov_11 <= 'b0;
        cov_12 <= 'b0;
        cov_13 <= 'b0;
        cov_14 <= 'b0;
        cov_15 <= 'b0;
        cov_16 <= 'b0;

        p_1 <= fully1;
        p_2 <= fully2;
        p_3 <= fully3;
        p_4 <= fully4;

        max_1 <= {9'b111111111, 23'd0};
        max_2 <= {9'b111111111, 23'd0};
        max_3 <= {9'b111111111, 23'd0};
        max_4 <= {9'b111111111, 23'd0};

        fully1 <= 'b0;
        fully2 <= 'b0;
        fully3 <= 'b0;
        fully4 <= 'b0;

        nor_max <= 'b0;
        nor_min <= 'b0;

        out <= 'b0;
        out_valid <= 'b0;
    end
    else if (tim == 'd64) begin
        p_1 <= fully1;
        p_2 <= fully2;
        p_3 <= fully3;
        p_4 <= fully4;

        max_1 <= {9'b111111111, 23'd0};
        max_2 <= {9'b111111111, 23'd0};
        max_3 <= {9'b111111111, 23'd0};
        max_4 <= {9'b111111111, 23'd0};

        fully1 <= 'b0;
        fully2 <= 'b0;
        fully3 <= 'b0;
        fully4 <= 'b0;

        nor_max <= 'b0;
        nor_min <= 'b0;

        cov_7 <= sum4_z1;
        // if (tim == 'd48 || tim == 'd96) begin
        //     max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        // end
    end
    else if (tim == 'd10 || tim == 'd26 || tim == 'd42 || tim == 'd74 || tim == 'd90) begin
        cov_1 <= sum4_z1;
        if (tim == 'd42 || tim == 'd90) begin
            max_1 <= (cmp_agtb1) ? sum4_z1 : max_1;
        end
    end
    else if (tim == 'd59) begin
        nor_and <= nor_max | nor_min;

        cov_2 <= sum4_z1;
        // if (tim == 'd43 || tim == 'd91) begin
        //     max_1 <= (cmp_agtb1) ? sum4_z1 : max_1;
        // end

        max_3 <= addsub_z1; //middle x-x_min
        max_4 <= addsub_z2; //middle x-x_min
        max_1 <= addsub_z3; //x_max - x_min

        if (~opt_save[1]) begin
            if (nor_max[3]) begin
                fully1 <= {1'd0, 8'd126, 23'd3876520};
            end
            else if (nor_max[2]) begin
                fully2 <= {1'd0, 8'd126, 23'd3876520};
            end
            else if (nor_max[1]) begin
                fully3 <= {1'd0, 8'd126, 23'd3876520};
            end
            else begin
                fully4 <= {1'd0, 8'd126, 23'd3876520};
            end

            if (nor_min[3]) begin
                fully1 <= {1'd0, 8'd126, 23'd0};
            end
            else if (nor_min[2]) begin
                fully2 <= {1'd0, 8'd126, 23'd0};
            end
            else if (nor_min[1]) begin
                fully3 <= {1'd0, 8'd126, 23'd0};
            end
            else begin
                fully4 <= {1'd0, 8'd126, 23'd0};
            end
        end
        else begin
            if (nor_max[3]) begin
                fully1 <= {1'd0, 8'd126, 23'd4388822};
            end
            else if (nor_max[2]) begin
                fully2 <= {1'd0, 8'd126, 23'd4388822};
            end
            else if (nor_max[1]) begin
                fully3 <= {1'd0, 8'd126, 23'd4388822};
            end
            else begin
                fully4 <= {1'd0, 8'd126, 23'd4388822};
            end

            if (nor_min[3]) begin
                fully1 <= {1'd0, 8'd0, 23'd0};
            end
            else if (nor_min[2]) begin
                fully2 <= {1'd0, 8'd0, 23'd0};
            end
            else if (nor_min[1]) begin
                fully3 <= {1'd0, 8'd0, 23'd0};
            end
            else begin
                fully4 <= {1'd0, 8'd0, 23'd0};
            end
        end
    end
    else if (tim == 'd11 || tim == 'd27 || tim == 'd43 || tim == 'd75 || tim == 'd91) begin
        cov_2 <= sum4_z1;
        if (tim == 'd43 || tim == 'd91) begin
            max_1 <= (cmp_agtb1) ? sum4_z1 : max_1;
        end
    end
    else if (tim == 'd60) begin
        cov_3 <= sum4_z1;
        // if (tim == 'd44 || tim == 'd92) begin
        //     max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        // end

        max_3 <= div_z1; //middle x-x_min / x_max - x_min
        max_4 <= div_z2; //middle x-x_min / x_max - x_min
    end
    else if (tim == 'd12 || tim == 'd28 || tim == 'd44 || tim == 'd76 || tim == 'd92) begin
        cov_3 <= sum4_z1;
        if (tim == 'd44 || tim == 'd92) begin
            max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        end
    end
    else if (tim == 'd61) begin
        cov_4 <= sum4_z1;
        // if (tim == 'd45 || tim == 'd93) begin
        //     max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        // end

        max_3 <= exp_z1;
        max_4 <= exp_z2;
    end
    else if (tim == 'd13 || tim == 'd29 || tim == 'd45 || tim == 'd77 || tim == 'd93) begin
        cov_4 <= sum4_z1;
        if (tim == 'd45 || tim == 'd93) begin
            max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        end
    end
    else if (tim == 'd62) begin
        cov_5 <= sum4_z1;
        // if (tim == 'd46 || tim == 'd94) begin
        //     max_1 <= (cmp_agtb1) ? sum4_z1 : max_1;
        // end

        max_1 <= addsub_z1;
        max_2 <= addsub_z2;

        if (~opt_save[1]) begin // sigmoid
            max_3 <= {1'd0, 8'd127, 23'd0};
            max_4 <= {1'd0, 8'd127, 23'd0};
        end
        else begin // tanh
            max_3 <= addsub_z3;
            max_4 <= addsub_z4;
        end
    end
    else if (tim == 'd14 || tim == 'd30 || tim == 'd46 || tim == 'd78 || tim == 'd94) begin
        cov_5 <= sum4_z1;
        if (tim == 'd46 || tim == 'd94) begin
            max_1 <= (cmp_agtb1) ? sum4_z1 : max_1;
        end
    end
    else if (tim == 'd63) begin
        cov_6 <= sum4_z1;
        // if (tim == 'd47 || tim == 'd95) begin
        //     max_1 <= (cmp_agtb1) ? sum4_z1 : max_1;
        // end

        if (nor_and == 4'b0011) begin
            fully1 <= div_z1;
            fully2 <= div_z2;
        end
        else if (nor_and == 4'b0101) begin
            fully1 <= div_z1;
            fully3 <= div_z2;
        end
        else if (nor_and == 4'b1001) begin
            fully2 <= div_z1;
            fully3 <= div_z2;
        end
        else if (nor_and == 4'b0110) begin
            fully1 <= div_z1;
            fully4 <= div_z2;
        end
        else if (nor_and == 4'b1010) begin
            fully2 <= div_z1;
            fully4 <= div_z2;
        end
        else begin //1100
            fully3 <= div_z1;
            fully4 <= div_z2;
        end
    end
    else if (tim == 'd15 || tim == 'd31 || tim == 'd47 || tim == 'd79 || tim == 'd95) begin
        cov_6 <= sum4_z1;
        if (tim == 'd47 || tim == 'd95) begin
            max_1 <= (cmp_agtb1) ? sum4_z1 : max_1;
        end
    end
    else if (tim == 'd48) begin
        cov_7 <= sum4_z1;
        // if (tim == 'd48 || tim == 'd96) begin
        max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        // end

        fully1 <= mac_z1;
        fully2 <= mac_z2;
    end
    else if (tim == 'd96) begin
        cov_7 <= sum4_z1;
        // if (tim == 'd48 || tim == 'd96) begin
        max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        // end

        fully1 <= mac_z1;
        fully2 <= mac_z2;
    end
    else if (tim == 'd16 || tim == 'd32 || tim == 'd80) begin
        cov_7 <= sum4_z1;
        // if (tim == 'd48 || tim == 'd96) begin
        //     max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        // end
    end
    else if (tim == 'd17 || tim == 'd33 || tim == 'd49 || tim == 'd65 || tim == 'd81 || tim == 'd97) begin
        cov_8 <= sum4_z1;
        if (tim == 'd49 || tim == 'd97) begin
            max_2 <= (cmp_agtb1) ? sum4_z1 : max_2;
        end
    end
    else if (tim == 'd50) begin
        cov_9 <= sum4_z1;
        // if (tim == 'd50 || tim == 'd98) begin
        max_3 <= (cmp_agtb1) ? sum4_z1 : max_3;
        // end

        fully1 <= mac_z1;
        fully2 <= mac_z2;
        nor_max <= (cmp_agtb2) ? 4'b1000 : 4'b0100;
        nor_min <= (cmp_agtb2) ? 4'b0100 : 4'b1000;
    end
    else if (tim == 'd98) begin
        cov_9 <= sum4_z1;
        // if (tim == 'd98) begin
        max_3 <= (cmp_agtb1) ? sum4_z1 : max_3;
        // end

        fully1 <= mac_z1;
        fully2 <= mac_z2;
        nor_max <= (cmp_agtb2) ? 4'b1000 : 4'b0100;
        nor_min <= (cmp_agtb2) ? 4'b0100 : 4'b1000;
    end
    else if (tim == 'd18 || tim == 'd34 || tim == 'd66 || tim == 'd82) begin
        cov_9 <= sum4_z1;
    end
    else if (tim == 'd19 || tim == 'd35 || tim == 'd51 || tim == 'd67 || tim == 'd83 || tim == 'd99) begin
        cov_10 <= sum4_z1;
        if (tim == 'd51 || tim == 'd99) begin
            max_3 <= (cmp_agtb1) ? sum4_z1 : max_3;
        end
    end
    else if (tim == 'd20 || tim == 'd36 || tim == 'd52 || tim == 'd68 || tim == 'd84 || tim == 'd100) begin
        cov_11 <= sum4_z1;
        if (tim == 'd52 || tim == 'd100) begin
            max_4 <= (cmp_agtb1) ? sum4_z1 : max_4;
        end
    end
    else if (tim == 'd21 || tim == 'd37 || tim == 'd53 || tim == 'd69 || tim == 'd85 || tim == 'd101) begin
        cov_12 <= sum4_z1;
        if (tim == 'd53 || tim == 'd101) begin
            max_4 <= (cmp_agtb1) ? sum4_z1 : max_4;
        end
    end
    else if (tim == 'd22 || tim == 'd38 || tim == 'd54 || tim == 'd70 || tim == 'd86 || tim == 'd102) begin
        cov_13 <= sum4_z1;
        if (tim == 'd54 || tim == 'd102) begin
            max_3 <= (cmp_agtb1) ? sum4_z1 : max_3;
        end
    end
    else if (tim == 'd23 || tim == 'd39 || tim == 'd55 || tim == 'd71 || tim == 'd87 || tim == 'd103) begin
        cov_14 <= sum4_z1;
        if (tim == 'd55 || tim == 'd103) begin
            max_3 <= (cmp_agtb1) ? sum4_z1 : max_3;
        end
    end
    else if (tim == 'd56) begin
        cov_15 <= sum4_z1;
        // if (tim == 'd56 || tim == 'd104) begin
        max_4 <= (cmp_agtb1) ? sum4_z1 : max_4;
        // end

        fully3 <= mac_z1;
        fully4 <= mac_z2;
    end
    else if (tim == 'd104) begin
        cov_15 <= sum4_z1;
        // if (tim == 'd104) begin
        max_4 <= (cmp_agtb1) ? sum4_z1 : max_4;
        // end

        fully3 <= mac_z1;
        fully4 <= mac_z2;
    end
    else if (tim == 'd24 || tim == 'd40 || tim == 'd72 || tim == 'd88) begin
        cov_15 <= sum4_z1;
    end
    else if (tim == 'd25 || tim == 'd41 || tim == 'd57 || tim == 'd73 || tim == 'd89 || tim == 'd105) begin
        cov_16 <= sum4_z1;
        if (tim == 'd57 || tim == 'd105) begin
            max_4 <= (cmp_agtb1) ? sum4_z1 : max_4;
        end
    end
    else if (tim == 'd106) begin
        fully3 <= mac_z1;
        fully4 <= mac_z2;
        nor_max <= (cmp_agtb3) ? ((nor_max[3]) ? 4'b1000 : 4'b0100) : ((cmp_agtb2) ? 4'b0010 : 4'b0001);
        nor_min <= (cmp_agtb1) ? ((cmp_agtb2) ? 4'b0001 : 4'b0010) : ((nor_min[3]) ? 4'b1000 : 4'b0100);
        max_1 <= (cmp_agtb3) ? ((nor_max[3]) ? fully1 : fully2) : ((cmp_agtb2) ? mac_z1 : mac_z2); //x_max
        max_2 <= (cmp_agtb1) ? ((cmp_agtb2) ? mac_z2 : mac_z1) : ((nor_min[3]) ? fully1 : fully2); //x_min
    end
    else if (tim == 'd107) begin
        nor_and <= nor_max | nor_min;
        max_3 <= addsub_z1; //middle x-x_min
        max_4 <= addsub_z2; //middle x-x_min
        max_1 <= addsub_z3; //x_max - x_min

        if (~opt_save[1]) begin
            if (nor_max[3]) begin
                fully1 <= {1'd0, 8'd126, 23'd3876520};
            end
            else if (nor_max[2]) begin
                fully2 <= {1'd0, 8'd126, 23'd3876520};
            end
            else if (nor_max[1]) begin
                fully3 <= {1'd0, 8'd126, 23'd3876520};
            end
            else begin
                fully4 <= {1'd0, 8'd126, 23'd3876520};
            end

            if (nor_min[3]) begin
                fully1 <= {1'd0, 8'd126, 23'd0};
            end
            else if (nor_min[2]) begin
                fully2 <= {1'd0, 8'd126, 23'd0};
            end
            else if (nor_min[1]) begin
                fully3 <= {1'd0, 8'd126, 23'd0};
            end
            else begin
                fully4 <= {1'd0, 8'd126, 23'd0};
            end
        end
        else begin
            if (nor_max[3]) begin
                fully1 <= {1'd0, 8'd126, 23'd4388822};
            end
            else if (nor_max[2]) begin
                fully2 <= {1'd0, 8'd126, 23'd4388822};
            end
            else if (nor_max[1]) begin
                fully3 <= {1'd0, 8'd126, 23'd4388822};
            end
            else begin
                fully4 <= {1'd0, 8'd126, 23'd4388822};
            end

            if (nor_min[3]) begin
                fully1 <= {1'd0, 8'd0, 23'd0};
            end
            else if (nor_min[2]) begin
                fully2 <= {1'd0, 8'd0, 23'd0};
            end
            else if (nor_min[1]) begin
                fully3 <= {1'd0, 8'd0, 23'd0};
            end
            else begin
                fully4 <= {1'd0, 8'd0, 23'd0};
            end
        end
    end
    else if (tim == 'd108) begin
        max_3 <= div_z1; //middle x-x_min / x_max - x_min
        max_4 <= div_z2; //middle x-x_min / x_max - x_min
    end
    else if (tim == 'd109) begin
        max_3 <= exp_z1;
        max_4 <= exp_z2;
    end
    else if (tim == 'd110) begin
        max_1 <= addsub_z1;
        max_2 <= addsub_z2;

        if (~opt_save[1]) begin // sigmoid
            max_3 <= {1'd0, 8'd127, 23'd0};
            max_4 <= {1'd0, 8'd127, 23'd0};
        end
        else begin // tanh
            max_3 <= addsub_z3;
            max_4 <= addsub_z4;
        end
    end
    else if (tim == 'd111) begin // activate div
        if (nor_and == 4'b0011) begin
            fully1 <= div_z1;
            fully2 <= div_z2;
        end
        else if (nor_and == 4'b0101) begin
            fully1 <= div_z1;
            fully3 <= div_z2;
        end
        else if (nor_and == 4'b1001) begin
            fully2 <= div_z1;
            fully3 <= div_z2;
        end
        else if (nor_and == 4'b0110) begin
            fully1 <= div_z1;
            fully4 <= div_z2;
        end
        else if (nor_and == 4'b1010) begin
            fully2 <= div_z1;
            fully4 <= div_z2;
        end
        else begin //1100
            fully3 <= div_z1;
            fully4 <= div_z2;
        end
    end
    else if(tim == 'd112) begin
        out <= sum4_z1;
        out_valid <= 'b1;
    end
end
endmodule
