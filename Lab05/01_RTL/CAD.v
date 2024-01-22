module CAD(

    clk,
    rst_n,
    in_valid,
	in_valid2,
	matrix_size,
    matrix,
    matrix_idx,
    mode,

    out_valid,
    out_value
);

input clk, rst_n, in_valid, in_valid2;
input signed [7:0] matrix;
input [3:0]  matrix_idx;
input [1:0]  matrix_size;
input mode;
output reg out_valid, out_value;
reg WEB_, WEB_0, WEB_K,WEB_1,WEB_2,WEB_3,WEB_4,WEB_5,WEB_6,WEB_7,WEB_8,WEB_9,WEB_10,WEB_11,WEB_12,WEB_13,WEB_14,WEB_15,WEB_16,WEB_17,OE_1,CS_1, L_max;;
reg [25:0] K1,K2,K3,K4,K5,K6,K73,K24,K25,ctr_10,rps_t,plk_td1, plk_td2, plk_td3, plk_td4, plk_td5, plk_td6;
//reg [10:0]K8,K9,K10,K11,K12,K13,K14,K15,K16,K17,K18,K19,K20,K21,K22,K2;
reg signed [15:0] tot, tot1, tot2, tot3, tot4;
reg signed [19:0] lmax;
reg [2:0] ctr_0;
reg [10:0] Addr, Addr0;
reg signed [31:0] DI_1, DI_2,temp;
reg [6:0] Addr1;
reg signed [19:0] total;
reg [20:0] mr_1_reg, mr_2_reg, mr_3_reg, mr_4_reg, mr_5_reg;
reg [3:0] CS_ROW, CS_COL, CS_COL_, CS_COL_1, CS_COL_2, ctr, ctr_5, ctr_4, ctr_2;
wire signed [31:0] Data_Img1, Data_Img;
reg signed [39:0] DI_;
wire signed [39:0] Data_k;
reg signed  [10:0] pld_1, pld_2, pld_3, pld_4,tan_1, tan_2, tan_3, tan_4, row1, row2, row3, row4, row5;
wire signed [10:0] pon1 = Data_k[39:32], pon2 = Data_k[31:24], pon3 = Data_k[23:16], pon4 = Data_k[15:8], pon5 = Data_k[7:0],mac1 = Data_Img[31:24], mac2 = Data_Img[23:16], mac3 = Data_Img[15:8], mac4 = Data_Img[7:0];
wire signed [10:0] Data_Img1_part1 = Data_Img1[31:24], Data_Img1_part2 = Data_Img1[23:16], Data_Img1_part3 = Data_Img1[15:8], Data_Img1_part4 = Data_Img1[7:0];
reg [12:0] CS_INV_, CS_INV2, CS_INV1, CS_INV,ctr_9;
reg [10:0] ctr_3,datak1, datak2, datak3, datak4, datak5;
reg [4:0] CS_OUT,diffect, value_trace,ctr_end,mand_;
reg signed [19:0] p_value, out_reg;
reg calcu_start, de_calcu_start;
reg data_flag,set_on,operation,ctr_b_1, index_1, wordline, wordline_0, wordline_1, ctr_b_z,plkm, limit,paddle;
wire[3:0] index=matrix_idx;
reg [2:0] CS_TOP, wrdl, wrd_1, wrd_2, wrd_3;
reg [17:0] set_vd, set_valend,pwr_up;
wire signed [19:0] Divg;
reg signed [7:0] x_1, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10;
wire signed [15:0] mr_1 = x_1 * x_2;
wire signed [15:0] mr_2 = x_3 * x_4;
wire signed [15:0] mr_3 = x_5 * x_6;
wire signed [15:0] mr_4 = x_7 * x_8;
wire signed [15:0] mr_5 = x_9 * x_10;
wire CS_IN;
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pwr_up <= 15'd0;
        set_on <=0;
    end
    else if (pwr_up == set_valend) begin
        set_on <=0;
        pwr_up <= 15'd0;
    end
    else if(in_valid2) begin
        set_on <=1;
        pwr_up <= pwr_up + 1'd1;
    end
    else if(set_on) begin
        pwr_up <= pwr_up + 1'd1;
          set_on <= set_on;
    end
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_flag <=1;
        set_vd <=3928;
        set_valend <=3944;
        ctr_end <=2;
        value_trace <=0;
    end
    else if (pwr_up == set_vd) begin
        data_flag <=1;
    end
    else if (in_valid && data_flag) begin
        value_trace <= matrix_size;
        data_flag <=0;
    end
    else if (in_valid2 && plkm) begin
        if (mode == 0) begin
            if (value_trace == 0) begin
                ctr_end <=0;
                set_vd <=88;
                set_valend <=104;
            end
            else if (value_trace ==1) begin
                ctr_end <=1;
                set_vd <=728;
                set_valend <=744;
            end
            else if (value_trace == 2) begin
                ctr_end <=3;
                set_vd <=3928;
                set_valend <=3944;
            end
        end
        else begin 
            if (value_trace == 0) begin
                ctr_end <=0;
                set_vd <=2881; 
                set_valend <=2890;
            end
            else if (value_trace ==1) begin
                ctr_end <=1;
                set_vd <=7991;
                set_valend <=8010;
            end
            else if (value_trace == 2) begin
                ctr_end <=3;
                set_vd <=25911;
                set_valend <=25930;
            end
        end
    end
end
always@(*) total = tot + tot1 + tot2 + tot3 + tot4 + lmax;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ctr_0 <= 0;
    end
    else if (in_valid) begin
        if (ctr_0 == 0) begin
            ctr_0 <= 1;
        end
        else if (ctr_0 == 1) begin
            ctr_0 <= 2;
        end
        else if (ctr_0 == 2) begin
            ctr_0 <= 3;
        end
        else if (ctr_0 == 3) begin
            if (CS_IN) begin
                ctr_0 <= 0;
            end
            else begin
                ctr_0 <= 4;
            end
        end
        else if (ctr_0 == 4) begin
            ctr_0 <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin

        temp <= 32'b0;
    end
    else if (in_valid) begin
        if (ctr_0 == 0) begin
            temp[31:24] <= matrix;
        end
        else if (ctr_0 == 1) begin
            temp[23:16] <= matrix;
        end
        else if (ctr_0 == 2) begin
            temp[15:8] <= matrix;
        end
        else if (ctr_0 == 3) begin
            temp[7:0] <= matrix;
        end
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rps_t <=0;
        diffect <=0;
    end
    else if (in_valid2 && mode == 1'b1 && plkm) begin
        if (value_trace == 0) begin
            rps_t <= index * 128 +28;
            diffect <=0;
        end
        else if (value_trace == 1) begin
            rps_t <= index * 128 +61;
            diffect <=1;
        end
        else if (value_trace == 2) begin
            rps_t <= index * 128 +127;
            diffect <=3;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        operation <=0;
    end
    else if (in_valid2 && plkm) begin
        operation <= mode;
    end
end

assign CS_IN = (ctr_9 !=16);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wordline <=0;
        wordline_0 <=0;
        wordline_1 <=0;
    end
    else begin
        wordline <= index_1;
        wordline_0 <= wordline;
        wordline_1 <= wordline_0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CS_INV2 <=0;
        CS_INV1 <=0;
        CS_INV <=0;
    end
    else begin
        CS_INV2 <= CS_INV_;
        CS_INV1 <= CS_INV2;
        CS_INV <= CS_INV1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CS_COL <=0;
    end
    else begin
        CS_COL <= CS_ROW;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CS_COL_ <=0;
    end
    else begin
        CS_COL_ <= CS_COL;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CS_COL_1 <=0;
    end
    else begin
        CS_COL_1 <= CS_COL_;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CS_COL_2 <=0;
    end
    else begin
        CS_COL_2 <= CS_COL_1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        Addr <=0;
        Addr0 <=0;

        DI_1 <=0;

        DI_2 <=0;;
        Addr1 <=0;;

        DI_ <=0;;
        WEB_ <=1;

        WEB_0 <=1;

        WEB_K <=1;

        ctr_10 <=0;
        ctr_3 <=0;
        limit <=1;

        paddle <=1;
        ctr_9 <=0;
    end
    else if (in_valid) begin
        if (ctr_0 == 0) begin
            WEB_ <=1; 
            WEB_0 <=1; 
            WEB_K <=1; 
        end
        else if (CS_IN && (ctr_0 == 3)) begin
            if (limit) begin
                Addr <= (ctr_9 * 128) + ctr_10; 
                DI_1 <= {temp[31:8], matrix};
                limit <=0;

                WEB_ <=0; 

            end
            else begin
                Addr0 <= (ctr_9 * 128) + ctr_10; 
                DI_2 <= {temp[31:8], matrix};
                limit <=1;

                WEB_0 <=0;

                if (value_trace == 2'd0) begin 
                    if (ctr_10 == 11'd28) begin

                        ctr_10 <=0;
                        ctr_9 <= ctr_9 +1; 
                    end
                    else begin
                        ctr_10 <= ctr_10 +4; 
                    end
                end
                else if (value_trace == 2'd1) begin //16*16
                    if (paddle) begin
                        ctr_10 <= ctr_10 +1; 
                        paddle <=0;
                    end
                    else begin
                        if (ctr_10 == 11'd61) begin

                            ctr_10 <=0;
                            ctr_9 <= ctr_9 +1; 
                        end
                        else begin
                            ctr_10 <= ctr_10 +3; 

                        end
                        paddle <=1;
                    end
                end
                else begin 
                    if (ctr_10 == 11'd127) begin

                        ctr_10 <=0;
                        ctr_9 <= ctr_9 +1; 
                    end
                    else begin
                        ctr_10 <= ctr_10 +1; 
                    end
                end
            end
        end
        else if (!CS_IN && (ctr_0 == 4))begin

            WEB_K <=0;

            Addr1 <= ctr_3;
            DI_ <= {temp, matrix};
            ctr_3 <= ctr_3 + 1; 
        end
    end
    else if(in_valid2) begin
        if (plkm) begin

            Addr <= index * 128; 
            Addr0 <= index * 128;

        end
        else begin
            Addr1 <= index *5; 

        end
    end
    else if (pwr_up == set_vd) begin
        Addr <=0;
        Addr0 <=0;
        DI_1 <=0;
        DI_2 <=0;;
        Addr1 <=0;;
        DI_ <=0;;
        WEB_ <=1;
        WEB_0 <=1;
        WEB_K <=1;
        ctr_10 <=0;
        ctr_3 <=0;
        limit <=1;
        paddle <=1;
        ctr_9 <=0;
    end
    else if(ctr_b_1) begin
        if (CS_TOP == 4) begin
            if(mand_ == 0 || mand_ ==1) begin
                Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                Addr0 <= plk_td1;
            end
            else begin
                Addr <= (index_1) ? plk_td2 +1 : plk_td2;
                Addr0 <= plk_td2;
            end
            Addr1 <= datak1;
        end
        else if (CS_TOP == 0) begin
            if(mand_ == 0 || mand_ ==1) begin
                Addr <= (index_1) ? plk_td2 +1 : plk_td2;
                Addr0 <= plk_td2;
            end
            else begin
                Addr <= (index_1) ? plk_td3 +1 : plk_td3;
                Addr0 <= plk_td3;
            end
            Addr1 <= datak2;
        end
        else if (CS_TOP == 1) begin
            if(mand_ == 0 || mand_ ==1) begin
                Addr <= (index_1) ? plk_td3 +1 : plk_td3;
                Addr0 <= plk_td3;
            end
            else begin
                Addr <= (index_1) ? plk_td4 +1 : plk_td4;
                Addr0 <= plk_td4;
            end
            Addr1 <= datak3;
        end
        else if (CS_TOP == 2) begin
            if(mand_ == 0 || mand_ ==1) begin
                Addr <= (index_1) ? plk_td4 +1 : plk_td4;
                Addr0 <= plk_td4;
            end
            else begin
                Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                Addr0 <= plk_td5;
            end
            Addr1 <= datak4;
        end
        else if (CS_TOP == 3) begin
            if(mand_ == 0 || mand_ ==1) begin
                Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                Addr0 <= plk_td5;
            end
            else begin
                Addr <= (index_1) ? plk_td6 +1 : plk_td6;
                Addr0 <= plk_td6;
            end
            Addr1 <= datak5;
        end

    end
    else if (ctr_b_z) begin
        if(CS_ROW==0) begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak5;
                end
            end else if(CS_ROW== 1) begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td2 +1 : plk_td2;
                    Addr0 <= plk_td2;
                    Addr1 <= datak5;
                end
            end else if(CS_ROW== 2)begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td2 +1 : plk_td2;
                    Addr0 <= plk_td2;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td3 +1 : plk_td3;
                    Addr0 <= plk_td3;
                    Addr1 <= datak5;
                end
            end else if(CS_ROW== 3) begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td2 +1 : plk_td2;
                    Addr0 <= plk_td2;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td3 +1 : plk_td3;
                    Addr0 <= plk_td3;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td4 +1 : plk_td4;
                    Addr0 <= plk_td4;
                    Addr1 <= datak5;
                end
            end else if(CS_ROW== 4)begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td2 +1 : plk_td2;
                    Addr0 <= plk_td2;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td3 +1 : plk_td3;
                    Addr0 <= plk_td3;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td4 +1 : plk_td4;
                    Addr0 <= plk_td4;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak5;
                end
            end else if(CS_ROW== 5) begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td1 +1 : plk_td1;
                    Addr0 <= plk_td1;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td2 +1 : plk_td2;
                    Addr0 <= plk_td2;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td3 +1 : plk_td3;
                    Addr0 <= plk_td3;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td4 +1 : plk_td4;
                    Addr0 <= plk_td4;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak5;
                end
            end else if(CS_ROW== 6)begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td2 +1 : plk_td2;
                    Addr0 <= plk_td2;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td3 +1 : plk_td3;
                    Addr0 <= plk_td3;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td4 +1 : plk_td4;
                    Addr0 <= plk_td4;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak5;
                end
            end else if(CS_ROW== 7)begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td3 +1 : plk_td3;
                    Addr0 <= plk_td3;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td4 +1 : plk_td4;
                    Addr0 <= plk_td4;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak5;
                end
            end else if(CS_ROW== 8)begin
                if (CS_INV_ == 0) begin
                    Addr <= (index_1) ? plk_td4 +1 : plk_td4;
                    Addr0 <= plk_td4;
                    Addr1 <= datak1;
                end
                else if (CS_INV_ == 1) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak2;
                end
                else if (CS_INV_ == 2) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak3;
                end
                else if (CS_INV_ == 3) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak4;
                end
                else if (CS_INV_ == 4) begin
                    Addr <= (index_1) ? plk_td5 +1 : plk_td5;
                    Addr0 <= plk_td5;
                    Addr1 <= datak5;
                end
            end
    end
    else if (!in_valid && !in_valid2) begin
        WEB_ <=1; 
        WEB_0 <=1; 
        WEB_K <=1; 
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mand_ <=0;
    end
    else if (pwr_up == set_vd) begin
        mand_ <=0;
    end
    else if (ctr_b_1 && CS_TOP == 3) begin
        if (mand_ == 0) begin
            mand_ <=1;
        end
        else if (mand_ ==1) begin
            mand_ <= 2;
        end
        else if (mand_ == 2) begin
            mand_ <= 3;
        end
        else if (mand_ == 3) begin
            mand_ <= 0;
        end
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ctr <=0;
    end
    else if (pwr_up == set_vd) begin
        ctr <=0;
    end
    else if (ctr_b_z && CS_INV_ == 4) begin
        if (ctr ==0) begin
            ctr <=1;
        end
        else if (ctr ==1) begin
            ctr <=2;
        end
        else if (ctr ==2) begin
            ctr <=3;
        end
        else if (ctr ==3) begin
            ctr <=4;
        end

        else if (ctr ==4) begin
            ctr <=5;
        end
        else if (ctr ==5) begin
            ctr <=6;
        end
        else if (ctr ==6) begin
            ctr <=7;
        end
        else if (ctr ==7) begin
            if (plk_td1[1:0] == ctr_end) begin
                ctr <=12;
            end
            else begin
                ctr <=8;
            end
        end
        else if (ctr ==8) begin
            ctr <=9;
        end
        else if (ctr ==9) begin
            ctr <=10;
        end
        else if (ctr ==10) begin
            ctr <=11;
        end
        else if (ctr ==11) begin
            ctr <=4;
        end

        else if (ctr ==12) begin
            ctr <=13;
        end
        else if (ctr ==13) begin
            ctr <=14;
        end
        else if (ctr ==14) begin
            ctr <=15;
        end
        else if (ctr ==15) begin
            ctr <=0;
        end
    end
end
//<>>>>>>>>>
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CS_ROW <=0;
    end
    else if (pwr_up == set_vd) begin
        CS_ROW <=0;
    end
    else if (ctr_b_z && ctr ==15 && CS_INV_ ==4) begin
        if (CS_ROW ==0) begin
            CS_ROW <=1;
        end
        else if (CS_ROW ==1) begin
            CS_ROW <=2;
        end
        else if (CS_ROW ==2) begin
            CS_ROW <=3;
        end
        else if (CS_ROW ==3) begin
            CS_ROW <=4;
        end
        else if (CS_ROW ==4) begin
            if (plk_td5 == rps_t) begin
                CS_ROW <=5;
            end
            else begin
                CS_ROW <=4;
            end
        end
        else if (CS_ROW ==5) begin
            CS_ROW <=6;
        end
        else if (CS_ROW ==6) begin
            CS_ROW <=7;
        end
        else if (CS_ROW ==7) begin
            CS_ROW <=8;
        end
        else if (CS_ROW ==8) begin
            CS_ROW <=9;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CS_TOP <=0;
    end
    else if (pwr_up == set_vd) begin
        CS_TOP <=0;
    end
    else if (ctr_b_1) begin
        if (CS_TOP == 0) begin
            CS_TOP <= 1;
        end else if (CS_TOP == 1) begin
            CS_TOP <= 2;
        end else if (CS_TOP == 2) begin
            CS_TOP <= 3;
        end else if (CS_TOP == 3) begin
            CS_TOP <= 4;
        end else if (CS_TOP == 4) begin
            CS_TOP <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        CS_INV_ <=0;
    end
    else if (pwr_up == set_vd) begin
        CS_INV_ <=0;
    end
    else if (ctr_b_z) begin
        if (CS_INV_ == 0) begin
            CS_INV_ <= 1;
        end else if (CS_INV_ == 1) begin
            CS_INV_ <= 2;
        end else if (CS_INV_ == 2) begin
            CS_INV_ <= 3;
        end else if (CS_INV_ == 3) begin
            CS_INV_ <= 4;
        end else if (CS_INV_ == 4) begin
            CS_INV_ <= 5;
        end else if (CS_INV_ == 5) begin
            CS_INV_ <= 6;
        end else if (CS_INV_ == 6) begin
            CS_INV_ <= 7;
        end else if (CS_INV_ == 7) begin
            CS_INV_ <= 8;
        end else if (CS_INV_ == 8) begin
            CS_INV_ <= 9;
        end else if (CS_INV_ == 9) begin
            CS_INV_ <= 10;
        end else if (CS_INV_ == 10) begin
            CS_INV_ <= 11;
        end else if (CS_INV_ == 11) begin
            CS_INV_ <= 12;
        end else if (CS_INV_ == 12) begin
            CS_INV_ <= 13;
        end else if (CS_INV_ == 13) begin
            CS_INV_ <= 14;
        end else if (CS_INV_ == 14) begin
            CS_INV_ <= 15;
        end else if (CS_INV_ == 15) begin
            CS_INV_ <= 16;
        end else if (CS_INV_ == 16) begin
            CS_INV_ <= 17;
        end else if (CS_INV_ == 17) begin
            CS_INV_ <= 18;
        end else if (CS_INV_ == 18) begin
            CS_INV_ <= 19;
        end else if (CS_INV_ == 19) begin
            CS_INV_ <= 0;
        end
    end
end
//<>>>>>>>>>
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        datak1 <=0;
    end
    else if(in_valid2 && !plkm) begin
        if (operation == 0) begin
            datak1 <= index *5; 
        end 
        else begin
            datak1 <= index *5 +4; 
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        datak2 <=0;
    end
    else if(in_valid2 && !plkm) begin
        if (operation == 0) begin
            datak2 <= index *5 +1;
        end 
        else begin
            datak2 <= index *5 +3;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        datak3 <=0;
    end
    else if(in_valid2 && !plkm) begin
        if (operation == 0) begin
            datak3 <= index *5 +2;
        end 
        else begin
            datak3 <= index *5 +2;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        datak4 <=0;
    end
    else if(in_valid2 && !plkm) begin
        if (operation == 0) begin
            datak4 <= index *5 +3;
        end 
        else begin
            datak4 <= index *5 +1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        datak5 <=0;
    end
    else if(in_valid2 && !plkm) begin
        if (operation == 0) begin
            datak5 <= index *5 +4;
        end 
        else begin
            datak5 <= index *5;
        end
    end
end
T_o1 S0(
    .A0(Addr[0]), 
    .A1(Addr[1]), 
    .A2(Addr[2]), 
    .A3(Addr[3]), 
    .A4(Addr[4]), 
    .A5(Addr[5]), 
    .A6(Addr[6]), 
    .A7(Addr[7]), 
    .A8(Addr[8]), 
    .A9(Addr[9]), 
    .A10(Addr[10]),
    .DO0(Data_Img1[0]), 
    .DO1(Data_Img1[1]), 
    .DO2(Data_Img1[2]), 
    .DO3(Data_Img1[3]), 
    .DO4(Data_Img1[4]), 
    .DO5(Data_Img1[5]), 
    .DO6(Data_Img1[6]), 
    .DO7(Data_Img1[7]), 
    .DO8(Data_Img1[8]), 
    .DO9(Data_Img1[9]), 
    .DO10(Data_Img1[10]), 
    .DO11(Data_Img1[11]), 
    .DO12(Data_Img1[12]), 
    .DO13(Data_Img1[13]), 
    .DO14(Data_Img1[14]), 
    .DO15(Data_Img1[15]), 
    .DO16(Data_Img1[16]), 
    .DO17(Data_Img1[17]), 
    .DO18(Data_Img1[18]), 
    .DO19(Data_Img1[19]), 
    .DO20(Data_Img1[20]), 
    .DO21(Data_Img1[21]), 
    .DO22(Data_Img1[22]), 
    .DO23(Data_Img1[23]), 
    .DO24(Data_Img1[24]), 
    .DO25(Data_Img1[25]), 
    .DO26(Data_Img1[26]), 
    .DO27(Data_Img1[27]), 
    .DO28(Data_Img1[28]), 
    .DO29(Data_Img1[29]), 
    .DO30(Data_Img1[30]), 
    .DO31(Data_Img1[31]),
    .DI0(DI_1[0]), 
    .DI1(DI_1[1]), 
    .DI2(DI_1[2]), 
    .DI3(DI_1[3]), 
    .DI4(DI_1[4]), 
    .DI5(DI_1[5]), 
    .DI6(DI_1[6]), 
    .DI7(DI_1[7]), 
    .DI8(DI_1[8]), 
    .DI9(DI_1[9]), 
    .DI10(DI_1[10]), 
    .DI11(DI_1[11]), 
    .DI12(DI_1[12]), 
    .DI13(DI_1[13]), 
    .DI14(DI_1[14]), 
    .DI15(DI_1[15]), 
    .DI16(DI_1[16]), 
    .DI17(DI_1[17]), 
    .DI18(DI_1[18]), 
    .DI19(DI_1[19]), 
    .DI20(DI_1[20]), 
    .DI21(DI_1[21]), 
    .DI22(DI_1[22]), 
    .DI23(DI_1[23]), 
    .DI24(DI_1[24]), 
    .DI25(DI_1[25]), 
    .DI26(DI_1[26]), 
    .DI27(DI_1[27]), 
    .DI28(DI_1[28]), 
    .DI29(DI_1[29]), 
    .DI30(DI_1[30]), 
    .DI31(DI_1[31]),
    .CK(clk), 
    .WEB(WEB_), 
    .OE(1'b1), 
    .CS(1'b1)
);

T_o2 S1(
    .A0(Addr0[0]), 
    .A1(Addr0[1]), 
    .A2(Addr0[2]), 
    .A3(Addr0[3]), 
    .A4(Addr0[4]), 
    .A5(Addr0[5]), 
    .A6(Addr0[6]), 
    .A7(Addr0[7]), 
    .A8(Addr0[8]), 
    .A9(Addr0[9]), 
    .A10(Addr0[10]),
    .DO0(Data_Img[0]), 
    .DO1(Data_Img[1]), 
    .DO2(Data_Img[2]), 
    .DO3(Data_Img[3]), 
    .DO4(Data_Img[4]), 
    .DO5(Data_Img[5]), 
    .DO6(Data_Img[6]), 
    .DO7(Data_Img[7]), 
    .DO8(Data_Img[8]), 
    .DO9(Data_Img[9]), 
    .DO10(Data_Img[10]), 
    .DO11(Data_Img[11]), 
    .DO12(Data_Img[12]), 
    .DO13(Data_Img[13]), 
    .DO14(Data_Img[14]), 
    .DO15(Data_Img[15]), 
    .DO16(Data_Img[16]), 
    .DO17(Data_Img[17]), 
    .DO18(Data_Img[18]), 
    .DO19(Data_Img[19]), 
    .DO20(Data_Img[20]), 
    .DO21(Data_Img[21]), 
    .DO22(Data_Img[22]), 
    .DO23(Data_Img[23]), 
    .DO24(Data_Img[24]), 
    .DO25(Data_Img[25]), 
    .DO26(Data_Img[26]), 
    .DO27(Data_Img[27]), 
    .DO28(Data_Img[28]), 
    .DO29(Data_Img[29]), 
    .DO30(Data_Img[30]), 
    .DO31(Data_Img[31]),
    .DI0(DI_2[0]), 
    .DI1(DI_2[1]), 
    .DI2(DI_2[2]), 
    .DI3(DI_2[3]), 
    .DI4(DI_2[4]), 
    .DI5(DI_2[5]), 
    .DI6(DI_2[6]), 
    .DI7(DI_2[7]), 
    .DI8(DI_2[8]), 
    .DI9(DI_2[9]), 
    .DI10(DI_2[10]), 
    .DI11(DI_2[11]), 
    .DI12(DI_2[12]), 
    .DI13(DI_2[13]), 
    .DI14(DI_2[14]), 
    .DI15(DI_2[15]), 
    .DI16(DI_2[16]), 
    .DI17(DI_2[17]), 
    .DI18(DI_2[18]), 
    .DI19(DI_2[19]), 
    .DI20(DI_2[20]), 
    .DI21(DI_2[21]), 
    .DI22(DI_2[22]), 
    .DI23(DI_2[23]), 
    .DI24(DI_2[24]), 
    .DI25(DI_2[25]), 
    .DI26(DI_2[26]), 
    .DI27(DI_2[27]), 
    .DI28(DI_2[28]), 
    .DI29(DI_2[29]), 
    .DI30(DI_2[30]), 
    .DI31(DI_2[31]),
    .CK(clk), 
    .WEB(WEB_0), 
    .OE(1'b1), 
    .CS(1'b1)
);
T_k3 S2(
    .A0(Addr1[0]), 
    .A1(Addr1[1]), 
    .A2(Addr1[2]), 
    .A3(Addr1[3]), 
    .A4(Addr1[4]), 
    .A5(Addr1[5]), 
    .A6(Addr1[6]),
    .DO0(Data_k[0]), 
    .DO1(Data_k[1]), 
    .DO2(Data_k[2]), 
    .DO3(Data_k[3]), 
    .DO4(Data_k[4]), 
    .DO5(Data_k[5]), 
    .DO6(Data_k[6]), 
    .DO7(Data_k[7]), 
    .DO8(Data_k[8]), 
    .DO9(Data_k[9]), 
    .DO10(Data_k[10]), 
    .DO11(Data_k[11]), 
    .DO12(Data_k[12]), 
    .DO13(Data_k[13]), 
    .DO14(Data_k[14]), 
    .DO15(Data_k[15]), 
    .DO16(Data_k[16]), 
    .DO17(Data_k[17]), 
    .DO18(Data_k[18]), 
    .DO19(Data_k[19]), 
    .DO20(Data_k[20]), 
    .DO21(Data_k[21]), 
    .DO22(Data_k[22]), 
    .DO23(Data_k[23]), 
    .DO24(Data_k[24]), 
    .DO25(Data_k[25]), 
    .DO26(Data_k[26]), 
    .DO27(Data_k[27]), 
    .DO28(Data_k[28]), 
    .DO29(Data_k[29]), 
    .DO30(Data_k[30]), 
    .DO31(Data_k[31]), 
    .DO32(Data_k[32]), 
    .DO33(Data_k[33]), 
    .DO34(Data_k[34]), 
    .DO35(Data_k[35]), 
    .DO36(Data_k[36]), 
    .DO37(Data_k[37]), 
    .DO38(Data_k[38]), 
    .DO39(Data_k[39]),
    .DI0(DI_[0]), 
    .DI1(DI_[1]), 
    .DI2(DI_[2]), 
    .DI3(DI_[3]), 
    .DI4(DI_[4]), 
    .DI5(DI_[5]), 
    .DI6(DI_[6]), 
    .DI7(DI_[7]), 
    .DI8(DI_[8]), 
    .DI9(DI_[9]), 
    .DI10(DI_[10]), 
    .DI11(DI_[11]), 
    .DI12(DI_[12]), 
    .DI13(DI_[13]), 
    .DI14(DI_[14]), 
    .DI15(DI_[15]), 
    .DI16(DI_[16]), 
    .DI17(DI_[17]), 
    .DI18(DI_[18]), 
    .DI19(DI_[19]), 
    .DI20(DI_[20]), 
    .DI21(DI_[21]), 
    .DI22(DI_[22]), 
    .DI23(DI_[23]), 
    .DI24(DI_[24]), 
    .DI25(DI_[25]), 
    .DI26(DI_[26]), 
    .DI27(DI_[27]), 
    .DI28(DI_[28]), 
    .DI29(DI_[29]), 
    .DI30(DI_[30]), 
    .DI31(DI_[31]), 
    .DI32(DI_[32]), 
    .DI33(DI_[33]), 
    .DI34(DI_[34]), 
    .DI35(DI_[35]), 
    .DI36(DI_[36]), 
    .DI37(DI_[37]), 
    .DI38(DI_[38]), 
    .DI39(DI_[39]),
    .CK(clk), 
    .WEB(WEB_K), 
    .OE(1'b1), 
    .CS(1'b1)
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ctr_b_1 <= 0;
    end
    else if(in_valid2 ==1) begin
        if (!plkm && operation == 0) begin
            ctr_b_1 <= 1'b1;
        end
    end
    else if (pwr_up == set_vd) begin
        ctr_b_1 <= 0;//x
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ctr_b_z <= 0;
    end
    else if(in_valid2 ==1) begin
        if (!plkm && operation == 1'b1) begin
            ctr_b_z <= 1'b1;
        end
    end
    else if (pwr_up == set_vd) begin
        ctr_b_z <= 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        plk_td1 <='b0;
        plk_td2 <='b0;
        plk_td3 <='b0;
        plk_td4 <='b0;
        plk_td5 <='b0;
        plk_td6 <='b0;

        plkm <=1;

        index_1 <= 0;
        wrdl <=0;
    end
    else if(in_valid2) begin
        if (plkm) begin
            plk_td1 <= index * 128;
            plk_td2 <= index * 128 +4;
            plk_td3 <= index * 128 +8;
            plk_td4 <= index * 128 +12;
            plk_td5 <= index * 128 +16;
            plk_td6 <= index * 128 +20;
            plkm <= 0;
            index_1 <= 0;
            wrdl <=0;
        end
    end
    else if (pwr_up == set_vd) begin
        plk_td1 <='b0;
        plk_td2 <='b0;
        plk_td3 <='b0;
        plk_td4 <='b0;
        plk_td5 <='b0;
        plk_td6 <='b0;
        plkm <=1;

        index_1 <= 0;
        wrdl <=0;
    end
    else if (ctr_b_z && CS_INV_ == 4) begin
        if (ctr ==11) begin
            plk_td1 <= plk_td1 +1;
            plk_td2 <= plk_td2 +1;
            plk_td3 <= plk_td3 +1;
            plk_td4 <= plk_td4 +1;
            plk_td5 <= plk_td5 +1;
            plk_td6 <= plk_td6 +1;

            if (index_1) begin
                index_1 <= !index_1;
            end
        end
        else if (ctr ==15) begin
            if (CS_ROW !=4) begin
                plk_td1 <= plk_td1 - diffect;
                plk_td2 <= plk_td2 - diffect;
                plk_td3 <= plk_td3 - diffect;
                plk_td4 <= plk_td4 - diffect;
                plk_td5 <= plk_td5 - diffect;
                plk_td6 <= plk_td6 - diffect;
            end
            else begin
                case(ctr_end)
                    0: begin

                        plk_td1 <= plk_td1 + 11'd4;
                        plk_td2 <= plk_td2 + 11'd4;
                        plk_td3 <= plk_td3 + 11'd4;
                        plk_td4 <= plk_td4 + 11'd4;
                        plk_td5 <= plk_td5 + 11'd4;
                        plk_td6 <= plk_td6 + 11'd4;
                    end
                   1: begin
                        plk_td1 <= plk_td1 + 11'd3;
                        plk_td2 <= plk_td2 + 11'd3;
                        plk_td3 <= plk_td3 + 11'd3;
                        plk_td4 <= plk_td4 + 11'd3;
                        plk_td5 <= plk_td5 + 11'd3;
                        plk_td6 <= plk_td6 + 11'd3;
                    end
                    default: begin 
                        plk_td1 <= plk_td1 + 11'd1;
                        plk_td2 <= plk_td2 + 11'd1;
                        plk_td3 <= plk_td3 + 11'd1;
                        plk_td4 <= plk_td4 + 11'd1;
                        plk_td5 <= plk_td5 + 11'd1;
                        plk_td6 <= plk_td6 + 11'd1;
                    end
                endcase
            end
        end
        else if (ctr ==7) begin
            if (plk_td1[1:0] != ctr_end) begin
                index_1 <= !index_1;
            end
        end

    end
    else if (ctr_b_1 && CS_TOP == 3) begin

        if (mand_ == 0) begin
            wrdl <= wrdl +1;
        end
        else if (mand_ ==1) begin
            wrdl <= wrdl -1;
        end
        else if (mand_ == 2) begin
            wrdl <= wrdl +1;
        end
        else if (mand_ == 3) begin 
            if (wrdl == 3) begin
                wrdl <=0;

                if (!index_1) begin
                    if (plk_td1[1:0] == ctr_end) begin
                        if (ctr_end == 0) begin
                            plk_td1 <= plk_td1 +8;
                            plk_td2 <= plk_td2 +8;
                            plk_td3 <= plk_td3 +8;
                            plk_td4 <= plk_td4 +8;
                            plk_td5 <= plk_td5 +8;
                            plk_td6 <= plk_td6 +8;
                        end
                        else if (ctr_end ==1) begin
                            plk_td1 <= plk_td1 +7;
                            plk_td2 <= plk_td2 +7;
                            plk_td3 <= plk_td3 +7;
                            plk_td4 <= plk_td4 +7;
                            plk_td5 <= plk_td5 +7;
                            plk_td6 <= plk_td6 +7;
                        end
                        else begin 
                            plk_td1 <= plk_td1 +5;
                            plk_td2 <= plk_td2 +5;
                            plk_td3 <= plk_td3 +5;
                            plk_td4 <= plk_td4 +5;
                            plk_td5 <= plk_td5 +5;
                            plk_td6 <= plk_td6 +5;
                        end
                    end
                    else begin
                        index_1 <= !index_1;
                    end
                end
                else begin
                    index_1 <= !index_1;
                    plk_td1 <= plk_td1 +1;
                    plk_td2 <= plk_td2 +1;
                    plk_td3 <= plk_td3 +1;
                    plk_td4 <= plk_td4 +1;
                    plk_td5 <= plk_td5 +1;
                    plk_td6 <= plk_td6 +1;
                end
            end
            else begin
                wrdl <= wrdl +1; 
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wrd_1 <=0;
        wrd_2 <=0;
        wrd_3 <=0;
    end
    else begin
        wrd_1 <= wrdl;
        wrd_2 <= wrd_1;
        wrd_3 <= wrd_2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ctr_5 <=0;
        ctr_4 <=0;
        ctr_2 <=0;
    end
    else begin
        ctr_5 <= ctr;
        ctr_4 <= ctr_5;
        ctr_2 <= ctr_4;
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        row1 <=0;
        row2 <=0;
        row3 <=0;
        row4 <=0;
        row5 <=0;
    end
    else begin
        if (ctr_b_1) begin 
            row1 <= pon1;
            row2 <= pon2;
            row3 <= pon3;
            row4 <= pon4;
            row5 <= pon5;
        end
        else if (ctr_b_z) begin
            row1 <= pon5;
            row2 <= pon4;
            row3 <= pon3;
            row4 <= pon2;
            row5 <= pon1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tan_1 <=0;
        tan_2 <=0;
        tan_3 <=0;
        tan_4 <=0;
    end
    else begin
        tan_1 <= mac1;
        tan_2 <= mac2;
        tan_3 <= mac3;
        tan_4 <= mac4;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pld_1 <=0;
        pld_2 <=0;
        pld_3 <=0;
        pld_4 <=0;
    end
    else begin
        if (ctr_b_1) begin 
            pld_1 <= Data_Img1_part1;
            pld_2 <= Data_Img1_part2;
            pld_3 <= Data_Img1_part3;
            pld_4 <= Data_Img1_part4;
        end
        else if (ctr_b_z) begin
            pld_1 <= Data_Img1_part1;
            pld_2 <= Data_Img1_part2;
            pld_3 <= Data_Img1_part3;
            pld_4 <= Data_Img1_part4;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mr_1_reg <=0;
        mr_2_reg <=0;
        mr_3_reg <=0;
        mr_4_reg <=0;
        mr_5_reg <=0;
    end else if (ctr_b_1) begin
        mr_1_reg <= mr_1;
        mr_2_reg <= mr_2;
        mr_3_reg <= mr_3;
        mr_4_reg <= mr_4;
        mr_5_reg <= mr_5;
    end else if(ctr_b_z) begin
        mr_1_reg <= mr_1;
        mr_2_reg <= mr_2;
        mr_3_reg <= mr_3;
        mr_4_reg <= mr_4;
        mr_5_reg <= mr_5;
    end
end
always @(*) begin
    x_2 =0;
    x_4 =0;
    x_6 =0;
    x_8 =0;
    x_10 =0;
    x_1 =0;
    x_3 =0;
    x_5 =0;
    x_7 =0;
    x_9 =0;
    tot =0;
    tot1 =0;
    tot2 =0;
    tot3 =0;
    tot4 =0;

    if (ctr_b_1) begin
        if (!wordline_1) begin
            if (wrd_3 == 2'd0) begin
                x_1 = pld_1;
                x_3 = pld_2;
                x_5 = pld_3;
                x_7 = pld_4;
                x_9 = tan_1;
            end
            else if (wrd_3 == 2'd1) begin
                x_1 = pld_2;
                x_3 = pld_3;
                x_5 = pld_4;
                x_7 = tan_1;
                x_9 = tan_2;
            end
            else if (wrd_3 == 2'd2) begin
                x_1 = pld_3;
                x_3 = pld_4;
                x_5 = tan_1;
                x_7 = tan_2;
                x_9 = tan_3;
            end
            else if (wrd_3 == 2'd3) begin
                x_1 = pld_4;
                x_3 = tan_1;
                x_5 = tan_2;
                x_7 = tan_3;
                x_9 = tan_4;
            end
        end
        else begin
            if (wrd_3 == 2'd0) begin
                x_1 = tan_1;
                x_3 = tan_2;
                x_5 = tan_3;
                x_7 = tan_4;
                x_9 = pld_1;
            end
            else if (wrd_3 == 2'd1) begin
                x_1 = tan_2;
                x_3 = tan_3;
                x_5 = tan_4;
                x_7 = pld_1;
                x_9 = pld_2;
            end
            else if (wrd_3 == 2'd2) begin
                x_1 = tan_3;
                x_3 = tan_4;
                x_5 = pld_1;
                x_7 = pld_2;
                x_9 = pld_3;
            end
            else if (wrd_3 == 2'd3) begin
                x_1 = tan_4;
                x_3 = pld_1;
                x_5 = pld_2;
                x_7 = pld_3;
                x_9 = pld_4;
            end
        end

    end
    else if (ctr_b_z) begin
        if (ctr_2 == 4'd0) begin
            x_1 =0;
            x_3 =0;
            x_5 =0;
            x_7 =0;
            x_9 = pld_1;
        end
        else if (ctr_2 == 4'd1) begin
            x_1 =0;
            x_3 =0;
            x_5 =0;
            x_7 = pld_1;
            x_9 = pld_2;
        end
        else if (ctr_2 == 4'd2) begin
            x_1 =0;
            x_3 =0;
            x_5 = pld_1;
            x_7 = pld_2;
            x_9 = pld_3;
        end
        else if (ctr_2 == 4'd3) begin
            x_1 =0;
            x_3 = pld_1;
            x_5 = pld_2;
            x_7 = pld_3;
            x_9 = pld_4;
        end
        else if (ctr_2 == 4'd4) begin
            x_1 = pld_1;
            x_3 = pld_2;
            x_5 = pld_3;
            x_7 = pld_4;
            x_9 = tan_1;
        end
        else if (ctr_2 == 4'd5) begin
            x_1 = pld_2;
            x_3 = pld_3;
            x_5 = pld_4;
            x_7 = tan_1;
            x_9 = tan_2;
        end
        else if (ctr_2 == 4'd6) begin
            x_1 = pld_3;
            x_3 = pld_4;
            x_5 = tan_1;
            x_7 = tan_2;
            x_9 = tan_3;
        end
        else if (ctr_2 == 4'd7) begin
            x_1 = pld_4;
            x_3 = tan_1;
            x_5 = tan_2;
            x_7 = tan_3;
            x_9 = tan_4;
        end
        else if (ctr_2 == 4'd8) begin
            x_1 = tan_1;
            x_3 = tan_2;
            x_5 = tan_3;
            x_7 = tan_4;
            x_9 = pld_1;
        end
        else if (ctr_2 == 4'd9) begin
            x_1 = tan_2;
            x_3 = tan_3;
            x_5 = tan_4;
            x_7 = pld_1;
            x_9 = pld_2;
        end
        else if (ctr_2 == 4'd10) begin
            x_1 = tan_3;
            x_3 = tan_4;
            x_5 = pld_1;
            x_7 = pld_2;
            x_9 = pld_3;
        end
        else if (ctr_2 == 4'd11) begin
            x_1 = tan_4;
            x_3 = pld_1;
            x_5 = pld_2;
            x_7 = pld_3;
            x_9 = pld_4;
        end
        else if (ctr_2 == 4'd12) begin
            x_1 = tan_1;
            x_3 = tan_2;
            x_5 = tan_3;
            x_7 = tan_4;
            x_9 =0;
        end
        else if (ctr_2 == 4'd13) begin
            x_1 = tan_2;
            x_3 = tan_3;
            x_5 = tan_4;
            x_7 =0;
            x_9 =0;
        end
        else if (ctr_2 == 4'd14) begin
            x_1 = tan_3;
            x_3 = tan_4;
            x_5 =0;
            x_7 =0;
            x_9 =0;
        end
        else if (ctr_2 == 4'd15) begin
            x_1 = tan_4;
            x_3 =0;
            x_5 =0;
            x_7 =0;
            x_9 =0;
        end
    end
    x_2 = row1;
    x_4 = row2;
    x_6 = row3;
    x_8 = row4;
    x_10 = row5;
    tot = mr_1_reg;
    tot1 = mr_2_reg;
    tot2 = mr_3_reg;
    tot3 = mr_4_reg;
    tot4 = mr_5_reg;
end
//<....................................................>
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lmax <=0;
    end
    else if (pwr_up == set_vd) begin
        lmax <= lmax;
    end
    else begin
        if(ctr_b_1) begin
            if (CS_TOP == 0) begin
                lmax <= total;
            end else if (CS_TOP == 1) begin
                lmax <= total;
            end else if (CS_TOP == 2) begin
                lmax <=0;
            end else if (CS_TOP == 3) begin
                lmax <= total;
            end else if (CS_TOP == 4) begin
                lmax <= total;
            end
        end
        else if (ctr_b_z) begin
            if (CS_COL_1 == 4'd0) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <=0;
                end else if (CS_INV == 2) begin
                    lmax <=0;
                end else if (CS_INV == 3) begin
                    lmax <=0;
                end else if (CS_INV == 4) begin
                    lmax <=0;
                end
            end else if (CS_COL_1 == 4'd1) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <=0;
                end else if (CS_INV == 2) begin
                    lmax <=0;
                end else if (CS_INV == 3) begin
                    lmax <=0;
                end else if (CS_INV == 4) begin
                    lmax <= total;
                end
            end else if (CS_COL_1 == 4'd2) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <=0;
                end else if (CS_INV == 2) begin
                    lmax <=0;
                end else if (CS_INV == 3) begin
                    lmax <= total;
                end else if (CS_INV == 4) begin
                    lmax <= total;
                end
            end else if (CS_COL_1 == 4'd3) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <=0;
                end else if (CS_INV == 2) begin
                    lmax <= total;
                end else if (CS_INV == 3) begin
                    lmax <= total;
                end else if (CS_INV == 4) begin
                    lmax <= total;
                end
            end else if (CS_COL_1 == 4'd4) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <= total;
                end else if (CS_INV == 2) begin
                    lmax <= total;
                end else if (CS_INV == 3) begin
                    lmax <= total;
                end else if (CS_INV == 4) begin
                    lmax <= total;
                end
            end else if (CS_COL_1 == 4'd5) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <= total;
                end else if (CS_INV == 2) begin
                    lmax <= total;
                end else if (CS_INV == 3) begin
                    lmax <= total;
                end else if (CS_INV == 4) begin
                    lmax <= total;
                end
            end else if (CS_COL_1 == 4'd6) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <= total;
                end else if (CS_INV == 2) begin
                    lmax <= total;
                end else if (CS_INV == 3) begin
                    lmax <= total;
                end else if (CS_INV == 4) begin
                    lmax <= lmax;
                end
            end else if (CS_COL_1 == 4'd7) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <= total;
                end else if (CS_INV == 2) begin
                    lmax <= total;
                end else if (CS_INV == 3) begin
                    lmax <= lmax;
                end else if (CS_INV == 4) begin
                    lmax <= lmax;
                end
            end else if (CS_COL_1 == 4'd8) begin
                if (CS_INV == 0) begin
                    lmax <=0;
                end else if (CS_INV == 1) begin
                    lmax <= total;
                end else if (CS_INV == 2) begin
                    lmax <= lmax;
                end else if (CS_INV == 3) begin
                    lmax <= lmax;
                end else if (CS_INV == 4) begin
                    lmax <= lmax;
                end
            end
        end
    end
end
//<.....

assign Divg = (total > p_value) ? total : p_value;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        CS_OUT <=0;
        calcu_start <=0;
        p_value <= 524288;
        out_valid <= 0;
        out_value <= 0;
        out_reg <=0;
        de_calcu_start <= 0;
    end
    else if (pwr_up == set_valend) begin
        out_valid <=0;
        out_value <=0;
    end
    else if (pwr_up >= set_vd) begin
        CS_OUT <=0;
        calcu_start <=0;
        de_calcu_start <=0;
        p_value <= 524288;
        out_reg <= out_reg >> 1;
        out_value <= out_reg[0];
    end
    else if (CS_TOP == 2 && calcu_start) begin

        if (CS_OUT == 0) begin
            CS_OUT <=1;
            p_value <= Divg;
        end
        else if (CS_OUT ==1) begin
            CS_OUT <= 2;
            p_value <= Divg;
        end
        else if (CS_OUT == 2) begin
            CS_OUT <= 3;
            p_value <= Divg;
        end
        else if (CS_OUT == 3) begin
            CS_OUT <= 0;
            p_value <= 524288;
            out_reg <= Divg >> 1;

            out_valid <=1;
            out_value <= Divg[0];
        end

        if (out_valid && !(CS_OUT == 3)) begin
            out_value <= out_reg[0];
            out_reg <= out_reg >> 1;
        end
    end
    else if (CS_TOP == 2 && !calcu_start) begin
        calcu_start <=1;
    end
    else if (out_valid && calcu_start && !(CS_TOP == 2 && CS_OUT == 3)) begin
        out_value <= out_reg[0];
        out_reg <= out_reg >> 1;
    end
    else if (CS_INV == 5'd5) begin
        out_valid <=1;
        if (CS_COL_2 == 4'd0) begin
            out_value <= total[0];
            out_reg <= total >> 1;
        end
        else if (CS_COL_2 == 4'd1) begin
            out_value <= total[0];
            out_reg <= total >> 1;
        end
        else if (CS_COL_2 == 4'd2) begin
            out_value <= total[0];
            out_reg <= total >> 1;    
        end
        else if (CS_COL_2 == 4'd3) begin
            out_value <= total[0];
            out_reg <= total >> 1;        
        end
        else if (CS_COL_2 == 4'd4) begin
            out_value <= total[0];
            out_reg <= total >> 1;        
        end
        else if (CS_COL_2 == 4'd5) begin
            out_value <= lmax[0];
            out_reg <= lmax >> 1;        
        end
        else if (CS_COL_2 == 4'd6) begin
            out_value <= lmax[0];
            out_reg <= lmax >> 1;      
        end
        else if (CS_COL_2 == 4'd7) begin
            out_value <= lmax[0];
            out_reg <= lmax >> 1;        
        end
        else if (CS_COL_2 == 4'd8) begin
            out_value <= lmax[0];
            out_reg <= lmax >> 1;        
        end
    end
    else if (out_valid) begin
        out_value <= out_reg[0];
        out_reg <= out_reg >> 1;

    end

end

endmodule