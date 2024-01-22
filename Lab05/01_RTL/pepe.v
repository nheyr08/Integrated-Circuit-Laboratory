module CAD(
// input
    clk,
    rst_n,
    in_valid,
	in_valid2,
	matrix_size,
    matrix,
    matrix_idx,
    mode,
	
// output
    out_valid,
    out_value
);

//input
input clk, rst_n, in_valid, in_valid2, mode;
input [1:0]  matrix_size;
input signed [7:0] matrix;
input [3:0]  matrix_idx;

//output
output reg out_valid, out_value;

//add multi
reg signed [7:0] mul1, mul2, mul3, mul4, mul5, mul6, mul7, mul8, mul9, mul10;
wire signed [15:0] mul_o1, mul_o2, mul_o3, mul_o4, mul_o5;

reg signed [15:0] add1, add2, add3, add4, add5;
reg signed [19:0] add6;
wire signed [19:0] add_o1;
wire signed [16:0] add_a1, add_a2;
wire signed [17:0] add_a4;
wire signed [19:0] add_a3;

assign mul_o1 = mul1 * mul2;
assign mul_o2 = mul3 * mul4;
assign mul_o3 = mul5 * mul6;
assign mul_o4 = mul7 * mul8;
assign mul_o5 = mul9 * mul10;

// assign add_a1 = add1 + add2;
// assign add_a2 = add3 + add4;
// assign add_a3 = {{4{add5[15]}}, add5} + add6;
// assign add_a4 = add_a1 + add_a2;
// assign add_o1 = {{2{add_a4[17]}}, add_a4} + add_a3;
// assign add_o1 = add1 + add2 + add3 + add4 + add5 + add6;
assign add_o1 = {{4{add1[15]}}, add1} + 
                {{4{add2[15]}}, add2} + 
                {{4{add3[15]}}, add3} + 
                {{4{add4[15]}}, add4} + 
                {{4{add5[15]}}, add5} + 
                add6;


reg [4:0] derow_state, derow_state_dey1, derow_state_dey2, derow_state_dey3;
reg in_valid2_first_input;

reg [14:0] tim;
reg [14:0] time_stop, time_stop2;
reg time_start;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tim <= 15'd0;
        time_start <= 'b0;
    end
    else if (tim == time_stop2) begin
        time_start <= 'b0;
        tim <= 15'd0;
    end
    else if(in_valid2 || time_start) begin
        time_start <= 'b1;
        tim <= tim + 1'd1;
    end
end

reg [1:0] matrix_size_save;
reg [1:0] image_mod_row_end;
reg matrix_size_save_flag;

reg [10:0] row5_sha_end;

always @(posedge clk or negedge rst_n) begin//speed
    if (!rst_n) begin
        matrix_size_save_flag <= 'b1;
        time_stop <= 'd3928;
        time_stop2 <= 'd3944;
        image_mod_row_end <= 'd2;
        matrix_size_save <= 'b0;
    end
    else if (tim == time_stop) begin
        matrix_size_save_flag <= 'b1;
    end
    // else if (tim == time_stop2) begin
    //     time_stop <= 'd16384;
    //     time_stop2 <= 'd16384;
    // end
    else if (in_valid && matrix_size_save_flag) begin
        matrix_size_save <= matrix_size;
        matrix_size_save_flag <= 'b0;
    end
    else if (in_valid2 && in_valid2_first_input) begin
        if (mode == 1'b0) begin
            case (matrix_size_save)
                2'b00: begin
                    image_mod_row_end <= 'd0;
                    time_stop <= 'd88;
                    time_stop2 <= 'd104;
                end
                2'b01: begin
                    image_mod_row_end <= 'd1;
                    time_stop <= 'd728;
                    time_stop2 <= 'd744;
                end
                2'b10: begin
                    image_mod_row_end <= 'd3;
                    time_stop <= 'd3928;
                    time_stop2 <= 'd3944;
                end
            endcase
        end
        else begin //mode1 deconv
            case (matrix_size_save)
                2'b00: begin
                    image_mod_row_end <= 'd0;
                    time_stop <= 'd2881; //change
                    time_stop2 <= 'd2890;//change
                end
                2'b01: begin
                    image_mod_row_end <= 'd1;
                    time_stop <= 'd7991;//change
                    time_stop2 <= 'd8010;//change
                end
                2'b10: begin
                    image_mod_row_end <= 'd3;
                    time_stop <= 'd25911;//change
                    time_stop2 <= 'd25930;//change
                end
            endcase
        end
    end
end

//sram
reg [10:0] addr1, addr2;
reg signed [31:0] di1, di2;
reg [6:0] addrk;
reg signed [39:0] ki;
reg web1, web2, web3;
wire signed [31:0] do1, do2;
wire signed [39:0] ko;

SRAM_IMAGE_2048_32_1_FIRST S0(.A0(addr1[0]),.A1(addr1[1]),.A2(addr1[2]),.A3(addr1[3]),.A4(addr1[4]),.A5(addr1[5]),.A6(addr1[6]),.A7(addr1[7]),.A8(addr1[8]),.A9(addr1[9]),.A10(addr1[10]),
                                .DO0(do1[0]),.DO1(do1[1]),.DO2(do1[2]),.DO3(do1[3]),.DO4(do1[4]),.DO5(do1[5]),.DO6(do1[6]),.DO7(do1[7]),.DO8(do1[8]),.DO9(do1[9]),.DO10(do1[10]),.DO11(do1[11]),.DO12(do1[12]),.DO13(do1[13]),.DO14(do1[14]),.DO15(do1[15]),.DO16(do1[16]),.DO17(do1[17]),.DO18(do1[18]),.DO19(do1[19]),.DO20(do1[20]),.DO21(do1[21]),.DO22(do1[22]),.DO23(do1[23]),.DO24(do1[24]),.DO25(do1[25]),.DO26(do1[26]),.DO27(do1[27]),.DO28(do1[28]),.DO29(do1[29]),.DO30(do1[30]),.DO31(do1[31]),
                                .DI0(di1[0]),.DI1(di1[1]),.DI2(di1[2]),.DI3(di1[3]),.DI4(di1[4]),.DI5(di1[5]),.DI6(di1[6]),.DI7(di1[7]),.DI8(di1[8]),.DI9(di1[9]),.DI10(di1[10]),.DI11(di1[11]),.DI12(di1[12]),.DI13(di1[13]),.DI14(di1[14]),.DI15(di1[15]),.DI16(di1[16]),.DI17(di1[17]),.DI18(di1[18]),.DI19(di1[19]),.DI20(di1[20]),.DI21(di1[21]),.DI22(di1[22]),.DI23(di1[23]),.DI24(di1[24]),.DI25(di1[25]),.DI26(di1[26]),.DI27(di1[27]),.DI28(di1[28]),.DI29(di1[29]),.DI30(di1[30]),.DI31(di1[31]),
                                .CK(clk),.WEB(web1),.OE(1'b1), .CS(1'b1));

SRAM_IMAGE_2048_32_1_SECOND S1(.A0(addr2[0]),.A1(addr2[1]),.A2(addr2[2]),.A3(addr2[3]),.A4(addr2[4]),.A5(addr2[5]),.A6(addr2[6]),.A7(addr2[7]),.A8(addr2[8]),.A9(addr2[9]),.A10(addr2[10]),
                                .DO0(do2[0]),.DO1(do2[1]),.DO2(do2[2]),.DO3(do2[3]),.DO4(do2[4]),.DO5(do2[5]),.DO6(do2[6]),.DO7(do2[7]),.DO8(do2[8]),.DO9(do2[9]),.DO10(do2[10]),.DO11(do2[11]),.DO12(do2[12]),.DO13(do2[13]),.DO14(do2[14]),.DO15(do2[15]),.DO16(do2[16]),.DO17(do2[17]),.DO18(do2[18]),.DO19(do2[19]),.DO20(do2[20]),.DO21(do2[21]),.DO22(do2[22]),.DO23(do2[23]),.DO24(do2[24]),.DO25(do2[25]),.DO26(do2[26]),.DO27(do2[27]),.DO28(do2[28]),.DO29(do2[29]),.DO30(do2[30]),.DO31(do2[31]),
                                .DI0(di2[0]),.DI1(di2[1]),.DI2(di2[2]),.DI3(di2[3]),.DI4(di2[4]),.DI5(di2[5]),.DI6(di2[6]),.DI7(di2[7]),.DI8(di2[8]),.DI9(di2[9]),.DI10(di2[10]),.DI11(di2[11]),.DI12(di2[12]),.DI13(di2[13]),.DI14(di2[14]),.DI15(di2[15]),.DI16(di2[16]),.DI17(di2[17]),.DI18(di2[18]),.DI19(di2[19]),.DI20(di2[20]),.DI21(di2[21]),.DI22(di2[22]),.DI23(di2[23]),.DI24(di2[24]),.DI25(di2[25]),.DI26(di2[26]),.DI27(di2[27]),.DI28(di2[28]),.DI29(di2[29]),.DI30(di2[30]),.DI31(di2[31]),
                                .CK(clk),.WEB(web2),.OE(1'b1), .CS(1'b1));

SRAM_KERNEL_80_40_1 S2(.A0(addrk[0]), .A1(addrk[1]), .A2(addrk[2]), .A3(addrk[3]), .A4(addrk[4]), .A5(addrk[5]), .A6(addrk[6]),
                           .DO0(ko[0]), .DO1(ko[1]), .DO2(ko[2]), .DO3(ko[3]), .DO4(ko[4]), .DO5(ko[5]), .DO6(ko[6]), .DO7(ko[7]), .DO8(ko[8]), .DO9(ko[9]), .DO10(ko[10]), .DO11(ko[11]), .DO12(ko[12]), .DO13(ko[13]), .DO14(ko[14]), .DO15(ko[15]), .DO16(ko[16]), .DO17(ko[17]), .DO18(ko[18]), .DO19(ko[19]), .DO20(ko[20]), .DO21(ko[21]), .DO22(ko[22]), .DO23(ko[23]), .DO24(ko[24]), .DO25(ko[25]), .DO26(ko[26]), .DO27(ko[27]), .DO28(ko[28]), .DO29(ko[29]), .DO30(ko[30]), .DO31(ko[31]), .DO32(ko[32]), .DO33(ko[33]), .DO34(ko[34]), .DO35(ko[35]), .DO36(ko[36]), .DO37(ko[37]), .DO38(ko[38]), .DO39(ko[39]),
                           .DI0(ki[0]), .DI1(ki[1]), .DI2(ki[2]), .DI3(ki[3]), .DI4(ki[4]), .DI5(ki[5]), .DI6(ki[6]), .DI7(ki[7]), .DI8(ki[8]), .DI9(ki[9]), .DI10(ki[10]), .DI11(ki[11]), .DI12(ki[12]), .DI13(ki[13]), .DI14(ki[14]), .DI15(ki[15]), .DI16(ki[16]), .DI17(ki[17]), .DI18(ki[18]), .DI19(ki[19]), .DI20(ki[20]), .DI21(ki[21]), .DI22(ki[22]), .DI23(ki[23]), .DI24(ki[24]), .DI25(ki[25]), .DI26(ki[26]), .DI27(ki[27]), .DI28(ki[28]), .DI29(ki[29]), .DI30(ki[30]), .DI31(ki[31]), .DI32(ki[32]), .DI33(ki[33]), .DI34(ki[34]), .DI35(ki[35]), .DI36(ki[36]), .DI37(ki[37]), .DI38(ki[38]), .DI39(ki[39]),
                           .CK(clk), .WEB(web3), .OE(1'b1), .CS(1'b1));


// reg [39:0] matrix_buffer;
reg signed [31:0] matrix_buffer;
reg [2:0] matrix_buffer_state;
wire input_is_image;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        matrix_buffer_state <= 3'd0;
    end
    else if (in_valid) begin
        case (matrix_buffer_state)
            3'd0: matrix_buffer_state <= 3'd1;
            3'd1: matrix_buffer_state <= 3'd2;
            3'd2: matrix_buffer_state <= 3'd3;
            3'd3: matrix_buffer_state <= (input_is_image) ? 3'd0 : 3'd4;
            3'd4: matrix_buffer_state <= 3'd0;
            // default: matrix_buffer_state <= 3'd0;
        endcase
    end
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        // matrix_buffer <= 40'b0;
        matrix_buffer <= 32'b0;
    end
    else if (in_valid) begin
        case (matrix_buffer_state)
            // 3'd0: matrix_buffer[39:32] <= matrix;
            // 3'd1: matrix_buffer[31:24] <= matrix;
            // 3'd2: matrix_buffer[23:16] <= matrix;
            // 3'd3: matrix_buffer[15:8] <= matrix;
            // 3'd4: matrix_buffer[7:0] <= matrix;
            3'd0: matrix_buffer[31:24] <= matrix;
            3'd1: matrix_buffer[23:16] <= matrix;
            3'd2: matrix_buffer[15:8] <= matrix;
            3'd3: matrix_buffer[7:0] <= matrix;
            // default: matrix_buffer <= 'd0;
        endcase
    end
end

reg [1:0] mode1_minusback;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row5_sha_end <= 'b0;
        mode1_minusback <= 'b0;
    end
    else if (in_valid2 && mode == 1'b1 && in_valid2_first_input) begin
        case (matrix_size_save)
            3'd0: begin
                row5_sha_end <= matrix_idx * 'd128 + 'd28;
                mode1_minusback <= 'd0;
            end
            3'd1: begin
                row5_sha_end <= matrix_idx * 'd128 + 'd61;
                mode1_minusback <= 'd1;
                // $display("row5_sha_end: %d", row5_sha_end);
            end
            3'd2: begin
                row5_sha_end <= matrix_idx * 'd128 + 'd127;
                mode1_minusback <= 'd3;
            end
        endcase
    end
end

reg image_input_shift;
reg [10:0] addr_count_i;
reg [6:0] addr_count_k;
reg image_16_input_shift;
reg [4:0] input_image_count;

reg [1:0] z_state;
reg [2:0] row_state;
reg [10:0] row1_start, row2_start, row3_start, row4_start, row5_start, row6_start;
reg [6:0] kernel1_start, kernel2_start, kernel3_start, kernel4_start, kernel5_start;
reg conv_start, sram_num, sram_num_dey1, sram_num_dey2, sram_num_dey3, deconv_start;
reg [2:0] row_num, row_num_dey1, row_num_dey2, row_num_dey3;

reg mode_save;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mode_save <= 'b0;
    end
    else if (in_valid2 && in_valid2_first_input) begin
        mode_save <= mode;
    end
end

// always @(*) begin
//     input_is_image = (input_image_count != 'd16);
// end
assign input_is_image = (input_image_count != 'd16);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sram_num_dey1 <= 'b0;
        sram_num_dey2 <= 'b0;
        sram_num_dey3 <= 'b0;
    end
    else begin
        sram_num_dey1 <= sram_num;
        sram_num_dey2 <= sram_num_dey1;
        sram_num_dey3 <= sram_num_dey2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        derow_state_dey1 <= 'b0;
        derow_state_dey2 <= 'b0;
        derow_state_dey3 <= 'b0;
    end
    else begin
        derow_state_dey1 <= derow_state;
        derow_state_dey2 <= derow_state_dey1;
        derow_state_dey3 <= derow_state_dey2;
    end
end

reg [3:0] sha_state, sha_state_dey1, sha_state_dey2, sha_state_dey3, sha_state_dey4;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sha_state_dey1 <= 'b0;
        sha_state_dey2 <= 'b0;
        sha_state_dey3 <= 'b0;
        sha_state_dey4 <= 'b0;
    end
    else begin
        sha_state_dey1 <= sha_state;
        sha_state_dey2 <= sha_state_dey1;
        sha_state_dey3 <= sha_state_dey2;
        sha_state_dey4 <= sha_state_dey3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr1 <= 'b0;
        addr2 <= 'b0;
        // do1 <= 'b0;
        di1 <= 'b0;
        // do2 <= 'b0;
        di2 <= 'b0;;
        addrk <= 'b0;;
        // ko <= 'b0;
        ki <= 'b0;;
        web1 <= 'b1;
        // oe1 <= 'b1;
        // cs1 <= 'b0;
        web2 <= 'b1;
        // oe2 <= 'b1;
        // cs2 <= 'b0;
        web3 <= 'b1;
        // oe3 <= 'b1;
        // cs3 <= 'b0;

        addr_count_i <= 'b0;
        addr_count_k <= 'b0;
        image_input_shift <= 'b1;
        // input_is_image <= 'b1;

        image_16_input_shift <= 'b1;
        input_image_count <= 'b0;
    end
    else if (in_valid) begin
        if (matrix_buffer_state == 3'd0) begin
            web1 <= 'b1; // first not write
            web2 <= 'b1; // sec not write
            web3 <= 'b1; // kernel not write
        end
        else if (input_is_image && (matrix_buffer_state == 3'd3)) begin
            if (image_input_shift) begin
                addr1 <= (input_image_count * 'd128) + addr_count_i; //add share, multi share
                di1 <= {matrix_buffer[31:8], matrix};
                image_input_shift <= 'b0;

                web1 <= 'b0; // first write
                // web2 <= 'b1; // sec not write
            end
            else begin
                addr2 <= (input_image_count * 'd128) + addr_count_i; //add share, multi share
                di2 <= {matrix_buffer[31:8], matrix};
                image_input_shift <= 'b1;

                // web1 <= 'b1; // first not write
                web2 <= 'b0; // sec write

                if (matrix_size_save == 2'd0) begin //8*8
                    if (addr_count_i == 11'd28) begin
                        // input_is_image = 'b0;
                        addr_count_i <= 'd0;
                        input_image_count <= input_image_count + 'd1; //add share
                    end
                    else begin
                        addr_count_i <= addr_count_i + 'd4; //add share
                    end
                end
                else if (matrix_size_save == 2'd1) begin //16*16
                    if (image_16_input_shift) begin
                        addr_count_i <= addr_count_i + 'd1; //add share
                        image_16_input_shift <= 'b0;
                    end
                    else begin
                        if (addr_count_i == 11'd61) begin
                            // input_is_image = 'b0;
                            addr_count_i <= 'd0;
                            input_image_count <= input_image_count + 'd1; //add share
                        end
                        else begin
                            addr_count_i <= addr_count_i + 'd3; //add share
                            // image_16_input_shift <= 'b1;
                        end
                        image_16_input_shift <= 'b1;
                    end
                end
                else begin //if (matrix_size_save == 'd2) begin //32*32
                    if (addr_count_i == 11'd127) begin
                        // input_is_image = 'b0;
                        addr_count_i <= 'd0;
                        input_image_count <= input_image_count + 'd1; //add share
                    end
                    else begin
                        addr_count_i <= addr_count_i + 'd1; //add share
                    end
                end
            end
        end
        else if (!input_is_image && (matrix_buffer_state == 3'd4))begin// && (addr_count_k != 'd79)) begin // no need buz in_valid to 0 will auto close
            // web1 <= 'b1; // first not write
            // web2 <= 'b1; // sec not write
            web3 <= 'b0;

            addrk <= addr_count_k;
            ki <= {matrix_buffer, matrix};
            addr_count_k <= addr_count_k + 1; //add share
        end
    end
    else if(in_valid2) begin
        if (in_valid2_first_input) begin
            // if (mode == 1'b0) begin
        // if (mode == 1'b0) begin
        //     if (in_valid2_first_input) begin
            addr1 <= matrix_idx * 'd128; //multi share
            addr2 <= matrix_idx * 'd128;
            // end
            // else begin
            //     addrk = matrix_idx * 'd5; //multi share
            // end
        end
        else begin
            addrk <= matrix_idx * 'd5; //multi share
            //deconv
        end
    end
    else if (tim == time_stop) begin
        addr1 <= 'b0;
        addr2 <= 'b0;
        // do1 <= 'b0;
        di1 <= 'b0;
        // do2 <= 'b0;
        di2 <= 'b0;;
        addrk <= 'b0;;
        // ko <= 'b0;
        ki <= 'b0;;
        web1 <= 'b1;
        // oe1 <= 'b1;
        // cs1 <= 'b0;
        web2 <= 'b1;
        // oe2 <= 'b1;
        // cs2 <= 'b0;
        web3 <= 'b1;
        // oe3 <= 'b1;
        // cs3 <= 'b0;

        addr_count_i <= 'b0;
        addr_count_k <= 'b0;
        image_input_shift <= 'b1;
        // input_is_image <= 'b1;

        image_16_input_shift <= 'b1;
        input_image_count <= 'b0;
    end
    else if(conv_start) begin
        // if (sram_num) begin
        // addr1 <= row1_start;
        // addr2 <= row1_start;
        case (row_state)
                3'd4: begin
                    if(z_state == 2'b00 || z_state == 2'b01) begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                    end
                    else begin
                        addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                        addr2 <= row2_start;
                    end
                    addrk <= kernel1_start;
                end
                3'd0: begin
                    if(z_state == 2'b00 || z_state == 2'b01) begin
                        addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                        addr2 <= row2_start;
                    end
                    else begin
                        addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                        addr2 <= row3_start;
                    end
                    addrk <= kernel2_start;
                end
                3'd1: begin
                    if(z_state == 2'b00 || z_state == 2'b01) begin
                        addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                        addr2 <= row3_start;
                    end
                    else begin
                        addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                        addr2 <= row4_start;
                    end
                    addrk <= kernel3_start;
                end
                3'd2: begin
                    if(z_state == 2'b00 || z_state == 2'b01) begin
                        addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                        addr2 <= row4_start;
                    end
                    else begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                    end
                    addrk <= kernel4_start;
                end
                3'd3: begin
                    if(z_state == 2'b00 || z_state == 2'b01) begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                    end
                    else begin
                        addr1 <= (sram_num) ? row6_start + 'd1 : row6_start;
                        addr2 <= row6_start;
                    end
                    addrk <= kernel5_start;
                end
        endcase
        // end
        // else begin
        //     addr1 <= row1_start + 1;
        //     addr2 <= row1_start;
        // end
    end
    else if (deconv_start) begin
        case (sha_state)
            4'd0: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel5_start;
                    end
                    // default: begin
                    //     addr1 <= addr1
                    //     addr2 <= addr2
                    //     addrk <= addrk
                    // end
                endcase
            end
            4'd1: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                        addr2 <= row2_start;
                        addrk <= kernel5_start;
                    end
                endcase
            end
            4'd2: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                        addr2 <= row2_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                        addr2 <= row3_start;
                        addrk <= kernel5_start;
                    end
                endcase
            end
            4'd3: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                        addr2 <= row2_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                        addr2 <= row3_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                        addr2 <= row4_start;
                        addrk <= kernel5_start;
                    end
                endcase
            end
            4'd4: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                        addr2 <= row2_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                        addr2 <= row3_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                        addr2 <= row4_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel5_start;
                    end
                endcase
            end
            4'd5: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row1_start + 'd1 : row1_start;
                        addr2 <= row1_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                        addr2 <= row2_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                        addr2 <= row3_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                        addr2 <= row4_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel5_start;
                    end
                endcase
                // case (derow_state)
                //     3'd0: begin
                //         addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                //         addr2 <= row2_start;
                //         addrk <= kernel1_start;
                //     end
                //     3'd1: begin
                //         addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                //         addr2 <= row3_start;
                //         addrk <= kernel2_start;
                //     end
                //     3'd2: begin
                //         addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                //         addr2 <= row4_start;
                //         addrk <= kernel3_start;
                //     end
                //     3'd3: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel4_start;
                //     end
                //     3'd4: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel5_start;
                //     end
                // endcase
            end
            4'd6: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row2_start + 'd1 : row2_start;
                        addr2 <= row2_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                        addr2 <= row3_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                        addr2 <= row4_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel5_start;
                    end
                endcase
                // case (derow_state)
                //     3'd0: begin
                //         addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                //         addr2 <= row3_start;
                //         addrk <= kernel1_start;
                //     end
                //     3'd1: begin
                //         addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                //         addr2 <= row4_start;
                //         addrk <= kernel2_start;
                //     end
                //     3'd2: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel3_start;
                //     end
                //     3'd3: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel4_start;
                //     end
                //     3'd4: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel5_start;
                //     end
                // endcase
            end
            4'd7: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row3_start + 'd1 : row3_start;
                        addr2 <= row3_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                        addr2 <= row4_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel5_start;
                    end
                endcase
                // case (derow_state)
                //     3'd0: begin
                //         addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                //         addr2 <= row4_start;
                //         addrk <= kernel1_start;
                //     end
                //     3'd1: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel2_start;
                //     end
                //     3'd2: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel3_start;
                //     end
                //     3'd3: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel4_start;
                //     end
                //     3'd4: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel5_start;
                //     end
                // endcase
            end
            4'd8: begin
                case (derow_state)
                    3'd0: begin
                        addr1 <= (sram_num) ? row4_start + 'd1 : row4_start;
                        addr2 <= row4_start;
                        addrk <= kernel1_start;
                    end
                    3'd1: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel2_start;
                    end
                    3'd2: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel3_start;
                    end
                    3'd3: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel4_start;
                    end
                    3'd4: begin
                        addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                        addr2 <= row5_start;
                        addrk <= kernel5_start;
                    end
                endcase
                // case (derow_state)
                //     3'd0: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel1_start;
                //     end
                //     3'd1: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel2_start;
                //     end
                //     3'd2: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel3_start;
                //     end
                //     3'd3: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel4_start;
                //     end
                //     3'd4: begin
                //         addr1 <= (sram_num) ? row5_start + 'd1 : row5_start;
                //         addr2 <= row5_start;
                //         addrk <= kernel5_start;
                //     end
                // endcase
            end
        endcase
    end
    else if (!in_valid && !in_valid2) begin
        web1 <= 'b1; // first not write
        web2 <= 'b1; // sec not write
        web3 <= 'b1; // kernel not write
    end
end

// reg [1:0] z_state;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        z_state <= 'b0;
    end
    else if (tim == time_stop) begin
        z_state <= 'b0;
    end
    else if (conv_start && row_state == 3'd3) begin
        case (z_state)
            2'b00: z_state <= 2'b01;
            2'b01: z_state <= 2'b10;
            2'b10: z_state <= 2'b11;
            2'b11: z_state <= 2'b00;
        endcase
    end
end

reg [3:0] yo_state, yo_state_dey1, yo_state_dey2, yo_state_dey3;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        yo_state <= 'd0;
    end
    else if (tim == time_stop) begin
        yo_state <= 'd0;
    end
    else if (deconv_start && derow_state == 3'd4) begin
        if (yo_state == 'd0) begin
            yo_state <= 'd1;
        end
        else if (yo_state == 'd1) begin
            yo_state <= 'd2;
        end
        else if (yo_state == 'd2) begin
            yo_state <= 'd3;
        end
        else if (yo_state == 'd3) begin
            yo_state <= 'd4;
        end
        //
        else if (yo_state == 'd4) begin
            yo_state <= 'd5;
        end
        else if (yo_state == 'd5) begin
            yo_state <= 'd6;
        end
        else if (yo_state == 'd6) begin
            yo_state <= 'd7;
        end
        else if (yo_state == 'd7) begin
            if (row1_start[1:0] == image_mod_row_end) begin
                yo_state <= 'd12;
            end
            else begin
                yo_state <= 'd8;
            end

        end
        //
        else if (yo_state == 'd8) begin
            yo_state <= 'd9;
        end
        else if (yo_state == 'd9) begin
            yo_state <= 'd10;
        end
        else if (yo_state == 'd10) begin
            yo_state <= 'd11;
        end
        else if (yo_state == 'd11) begin
            yo_state <= 'd4;
        end
        //
        else if (yo_state == 'd12) begin
            yo_state <= 'd13;
        end
        else if (yo_state == 'd13) begin
            yo_state <= 'd14;
        end
        else if (yo_state == 'd14) begin
            yo_state <= 'd15;
        end
        else if (yo_state == 'd15) begin
            yo_state <= 'd0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sha_state <= 'd0;
    end
    else if (tim == time_stop) begin
        sha_state <= 'd0;
    end
    else if (deconv_start && yo_state == 'd15 && derow_state == 'd4) begin
        if (sha_state == 'd0) begin
            sha_state <= 'd1;
        end
        else if (sha_state == 'd1) begin
            sha_state <= 'd2;
        end
        else if (sha_state == 'd2) begin
            sha_state <= 'd3;
        end
        else if (sha_state == 'd3) begin
            sha_state <= 'd4;
        end
        //
        else if (sha_state == 'd4) begin
            if (row5_start == row5_sha_end) begin
                sha_state <= 'd5;
            end
            else begin
                sha_state <= 'd4;
            end
        end
        //
        else if (sha_state == 'd5) begin
            sha_state <= 'd6;
        end
        else if (sha_state == 'd6) begin
            sha_state <= 'd7;
        end
        else if (sha_state == 'd7) begin
            sha_state <= 'd8;
        end
        else if (sha_state == 'd8) begin
            sha_state <= 'd9;
        end
        //
    end
end


// reg [2:0] row_state;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row_state <= 'd0;
    end
    // else if(in_valid2) begin
    //     if (mode == 1'b0 && !in_valid2_first_input) begin
    //         row_state <= 3'd1;
    //     end
    // end
    else if (tim == time_stop) begin
        row_state <= 'd0;
    end
    else if (conv_start) begin
        case (row_state)
            3'd0: row_state <= 3'd1;
            3'd1: row_state <= 3'd2;
            3'd2: row_state <= 3'd3;
            3'd3: row_state <= 3'd4;
            3'd4: row_state <= 3'd0;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        derow_state <= 'd0;
    end
    else if (tim == time_stop) begin
        derow_state <= 'd0;
    end
    else if (deconv_start) begin
        case (derow_state)
        //01234
            5'd0: derow_state <= 5'd1;
            5'd1: derow_state <= 5'd2;
            5'd2: derow_state <= 5'd3;
            5'd3: derow_state <= 5'd4;
            5'd4: derow_state <= 5'd5;
            5'd5: derow_state <= 5'd6;
            5'd6: derow_state <= 5'd7;
            5'd7: derow_state <= 5'd8;
            5'd8: derow_state <= 5'd9;
            5'd9: derow_state <= 5'd10;
            5'd10: derow_state <= 5'd11;
            5'd11: derow_state <= 5'd12;
            5'd12: derow_state <= 5'd13;
            5'd13: derow_state <= 5'd14;
            5'd14: derow_state <= 5'd15;
            5'd15: derow_state <= 5'd16;
            5'd16: derow_state <= 5'd17;
            5'd17: derow_state <= 5'd18;
            5'd18: derow_state <= 5'd19;
            5'd19: derow_state <= 5'd0;
        endcase
    end
end

// reg [10:0] row1_start, row2_start, row3_start, row4_start, row5_start, row6_start;
// reg [6:0] kernel1_start, kernel2_start, kernel3_start, kernel4_start, kernel5_start;
// reg in_valid2_first_input, conv_start, sram_num;
// reg [1:0] row_num;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        kernel1_start <= 'b0;
        kernel2_start <= 'b0;
        kernel3_start <= 'b0;
        kernel4_start <= 'b0;
        kernel5_start <= 'b0;
    end
    else if(in_valid2 && !in_valid2_first_input) begin
        if (mode_save == 1'b0) begin
            kernel1_start <= matrix_idx * 'd5; //multi share
            kernel2_start <= matrix_idx * 'd5 + 'd1;
            kernel3_start <= matrix_idx * 'd5 + 'd2;
            kernel4_start <= matrix_idx * 'd5 + 'd3;
            kernel5_start <= matrix_idx * 'd5 + 'd4;
        end 
        else begin
            kernel1_start <= matrix_idx * 'd5 + 'd4; //multi share
            kernel2_start <= matrix_idx * 'd5 + 'd3;
            kernel3_start <= matrix_idx * 'd5 + 'd2;
            kernel4_start <= matrix_idx * 'd5 + 'd1;
            kernel5_start <= matrix_idx * 'd5;
        end
        // if (!in_valid2_first_input) begin
        // //     if (mode == 1'b0) begin
        // //         kernel1_start <= 'b0;
        // //         kernel2_start <= 'b0;
        // //         kernel3_start <= 'b0;
        // //         kernel4_start <= 'b0;
        // //         kernel5_start <= 'b0;
        // //     end
        // //     else begin
        // //         kernel1_start <= matrix_idx * 'd5; //multi share
        // //         kernel2_start <= matrix_idx * 'd5 + 'd1;
        // //         kernel3_start <= matrix_idx * 'd5 + 'd2;
        // //         kernel4_start <= matrix_idx * 'd5 + 'd3;
        // //         kernel5_start <= matrix_idx * 'd5 + 'd4;
        // //     end
        // // end
        // // else if (mode == 1'b1) begin
        // //     //deconv
        // //     kernel1_start <= 'b0;
        // //     kernel2_start <= 'b0;
        // //     kernel3_start <= 'b0;
        // //     kernel4_start <= 'b0;
        // //     kernel5_start <= 'b0;
        // // end
        // // else begin
        //     kernel1_start <= matrix_idx * 'd5; //multi share
        //     kernel2_start <= matrix_idx * 'd5 + 'd1;
        //     kernel3_start <= matrix_idx * 'd5 + 'd2;
        //     kernel4_start <= matrix_idx * 'd5 + 'd3;
        //     kernel5_start <= matrix_idx * 'd5 + 'd4;
        //     // conv_start <= 1'b1;
        //     //deconv need change
        // end

        // if (mode == 1'b0) begin
        //     if (in_valid2_first_input) begin
        //         kernel1_start <= 'b0;
        //         kernel2_start <= 'b0;
        //         kernel3_start <= 'b0;
        //         kernel4_start <= 'b0;
        //         kernel5_start <= 'b0;
        //     end
        //     else begin
        //         kernel1_start <= matrix_idx * 'd5; //multi share
        //         kernel2_start <= matrix_idx * 'd5 + 'd1;
        //         kernel3_start <= matrix_idx * 'd5 + 'd2;
        //         kernel4_start <= matrix_idx * 'd5 + 'd3;
        //         kernel5_start <= matrix_idx * 'd5 + 'd4;
        //     end
        // end
        // else if (mode == 1'b1) begin
        //     //deconv
        //     kernel1_start <= 'b0;
        //     kernel2_start <= 'b0;
        //     kernel3_start <= 'b0;
        //     kernel4_start <= 'b0;
        //     kernel5_start <= 'b0;
        // end
        // else begin
        //     kernel1_start <= matrix_idx * 'd5; //multi share
        //     kernel2_start <= matrix_idx * 'd5 + 'd1;
        //     kernel3_start <= matrix_idx * 'd5 + 'd2;
        //     kernel4_start <= matrix_idx * 'd5 + 'd3;
        //     kernel5_start <= matrix_idx * 'd5 + 'd4;
        //     // conv_start <= 1'b1;
        //     //deconv need change
        // end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        conv_start <= 1'b0;
        deconv_start <= 1'b0;
    end
    else if(in_valid2 == 'b1) begin
        if (!in_valid2_first_input && mode_save == 1'b0) begin
            conv_start <= 1'b1;
        end
        else if (!in_valid2_first_input && mode_save == 1'b1) begin
            deconv_start <= 1'b1;
        end
        // if (mode == 1'b0) begin
        //     if (in_valid2_first_input == 'b1) begin
        //         conv_start <= 1'b0;
        //     end
        //     else begin
        //         conv_start <= 1'b1;
        //     end
        // end
        // else if (mode == 1'b1) begin
        //     conv_start <= 1'b0;
        // end
        // else begin
        //     conv_start <= 1'b1;
        // end
    end
    else if (tim == time_stop) begin
        conv_start <= 1'b0;//x
        deconv_start <= 1'b0;
    end
    // else begin
    //     conv_start <= conv_start;//x
    // end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        row1_start <='b0;
        row2_start <='b0;
        row3_start <='b0;
        row4_start <='b0;
        row5_start <='b0;
        row6_start <='b0;

        // kernel1_start <= 'b0;
        // kernel2_start <= 'b0;
        // kernel3_start <= 'b0;
        // kernel4_start <= 'b0;
        // kernel5_start <= 'b0;

        in_valid2_first_input <= 'b1;
        //conv_start <= 1'b0;//x
        sram_num <= 1'b0;
        row_num <= 'd0;
    end
    else if(in_valid2) begin
        if (in_valid2_first_input) begin
        //     if (mode == 1'b0) begin
        // // if (mode == 1'b0) begin
        // //     if (in_valid2_first_input) begin
            row1_start <= matrix_idx * 'd128; //multi share
            row2_start <= matrix_idx * 'd128 + 'd4;
            row3_start <= matrix_idx * 'd128 + 'd8;
            row4_start <= matrix_idx * 'd128 + 'd12;
            row5_start <= matrix_idx * 'd128 + 'd16;
            row6_start <= matrix_idx * 'd128 + 'd20;

            in_valid2_first_input <= 1'b0;
            sram_num <= 1'b0;
            row_num <= 'd0;
            //     // conv_start <= 1'b0;//x
            // end
            // else begin//mode == 1
            // //     kernel1_start = matrix_idx * 'd5; //multi share
            // //     kernel2_start = matrix_idx * 'd5 + 'd1;
            // //     kernel3_start = matrix_idx * 'd5 + 'd2;
            // //     kernel4_start = matrix_idx * 'd5 + 'd3;
            // //     kernel5_start = matrix_idx * 'd5 + 'd4;
            //     // conv_start <= 1'b1;//x
            // end
        end
        // else if (mode == 1'b1) begin
        //     //deconv
        //     // conv_start <= 1'b0;//x
        // end
        // else begin
        //     // kernel1_start <= matrix_idx * 'd5; //multi share
        //     // kernel2_start <= matrix_idx * 'd5 + 'd1;
        //     // kernel3_start <= matrix_idx * 'd5 + 'd2;
        //     // kernel4_start <= matrix_idx * 'd5 + 'd3;
        //     // kernel5_start <= matrix_idx * 'd5 + 'd4;
        //     // conv_start <= 1'b1;//x
        //     //deconv need change
        // end
    end
    else if (tim == time_stop) begin
        row1_start <='b0;
        row2_start <='b0;
        row3_start <='b0;
        row4_start <='b0;
        row5_start <='b0;
        row6_start <='b0;
        in_valid2_first_input <= 'b1;
        // conv_start <= 1'b0;//x
        sram_num <= 1'b0;
        row_num <= 'd0;
    end
    else if (deconv_start && derow_state == 3'd4) begin
        if (yo_state == 'd11) begin
            row1_start <= row1_start + 'd1;
            row2_start <= row2_start + 'd1;
            row3_start <= row3_start + 'd1;
            row4_start <= row4_start + 'd1;
            row5_start <= row5_start + 'd1;
            row6_start <= row6_start + 'd1;

            if (sram_num) begin
                sram_num <= ~sram_num;
            end
        end
        else if (yo_state == 'd15) begin
            if (sha_state != 'd4) begin
                row1_start <= row1_start - mode1_minusback;
                row2_start <= row2_start - mode1_minusback;
                row3_start <= row3_start - mode1_minusback;
                row4_start <= row4_start - mode1_minusback;
                row5_start <= row5_start - mode1_minusback;
                row6_start <= row6_start - mode1_minusback;
            end
            else begin
                case(image_mod_row_end)
                    2'b00: begin
                        // $display("row1_start: %d", row1_start);
                        row1_start <= row1_start + 11'd4;
                        row2_start <= row2_start + 11'd4;
                        row3_start <= row3_start + 11'd4;
                        row4_start <= row4_start + 11'd4;
                        row5_start <= row5_start + 11'd4;
                        row6_start <= row6_start + 11'd4;
                    end
                    2'b01: begin
                        row1_start <= row1_start + 11'd3;
                        row2_start <= row2_start + 11'd3;
                        row3_start <= row3_start + 11'd3;
                        row4_start <= row4_start + 11'd3;
                        row5_start <= row5_start + 11'd3;
                        row6_start <= row6_start + 11'd3;
                    end
                    default: begin //2'b11: begin
                        row1_start <= row1_start + 11'd1;
                        row2_start <= row2_start + 11'd1;
                        row3_start <= row3_start + 11'd1;
                        row4_start <= row4_start + 11'd1;
                        row5_start <= row5_start + 11'd1;
                        row6_start <= row6_start + 11'd1;
                    end
                endcase
            end
        end
        else if (yo_state == 'd7) begin
            if (row1_start[1:0] != image_mod_row_end) begin
                sram_num <= ~sram_num;
            end
        end
        // else if (yo_state == 'd11 && sram_num) begin
        //     sram_num <= ~sram_num;
        // end
    end
    else if (conv_start && row_state == 3'd3) begin
        // conv_start <= 1'b1;
        case(z_state)
            2'b00: row_num <= row_num + 'd1;
            2'b01: row_num <= row_num - 'd1;
            2'b10: row_num <= row_num + 'd1;
            2'b11: begin 
                if (row_num == 3'd3) begin
                    row_num <= 'd0;
                    // sram_num <= ~sram_num;
                    if (!sram_num) begin
                        if (row1_start[1:0] == image_mod_row_end) begin
                            case(image_mod_row_end)
                                2'b00: begin
                                    // $display("row1_start: %d", row1_start);
                                    row1_start <= row1_start + 'd8;
                                    row2_start <= row2_start + 'd8;
                                    row3_start <= row3_start + 'd8;
                                    row4_start <= row4_start + 'd8;
                                    row5_start <= row5_start + 'd8;
                                    row6_start <= row6_start + 'd8;
                                end
                                2'b01: begin
                                    row1_start <= row1_start + 'd7;
                                    row2_start <= row2_start + 'd7;
                                    row3_start <= row3_start + 'd7;
                                    row4_start <= row4_start + 'd7;
                                    row5_start <= row5_start + 'd7;
                                    row6_start <= row6_start + 'd7;
                                end
                                default: begin //2'b11: begin
                                    row1_start <= row1_start + 'd5;
                                    row2_start <= row2_start + 'd5;
                                    row3_start <= row3_start + 'd5;
                                    row4_start <= row4_start + 'd5;
                                    row5_start <= row5_start + 'd5;
                                    row6_start <= row6_start + 'd5;
                                end
                            endcase
                        end
                        else begin
                            sram_num <= ~sram_num;
                            // row1_start <= row1_start + 'd1;
                            // row2_start <= row2_start + 'd1;
                            // row3_start <= row3_start + 'd1;
                            // row4_start <= row4_start + 'd1;
                            // row5_start <= row5_start + 'd1;
                            // row6_start <= row6_start + 'd1;
                        end
                    end
                    else begin
                        // $display("row1_start: %d, sram_num: %d", row1_start, sram_num);
                        sram_num <= ~sram_num;
                        row1_start <= row1_start + 'd1;
                        row2_start <= row2_start + 'd1;
                        row3_start <= row3_start + 'd1;
                        row4_start <= row4_start + 'd1;
                        row5_start <= row5_start + 'd1;
                        row6_start <= row6_start + 'd1;
                    end
                end
                else begin
                    row_num <= row_num + 'd1; 
                end
            end
        endcase
    end
    // else if (deconv_start && derow_state == 3'd4) begin
    //     if (yo_state == 'd7) begin
    //         if (row1_start[1:0] != image_mod_row_end) begin
    //             sram_num <= ~sram_num;
    //         end
    //     end
    //     else if (yo_state == 'd7 && sram_num) begin
    //         sram_num <= ~sram_num;
    //     end
    // end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        row_num_dey1 <= 'b0;
        row_num_dey2 <= 'b0;
        row_num_dey3 <= 'b0;
    end
    else begin
        row_num_dey1 <= row_num;
        row_num_dey2 <= row_num_dey1;
        row_num_dey3 <= row_num_dey2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yo_state_dey1 <= 'b0;
        yo_state_dey2 <= 'b0;
        yo_state_dey3 <= 'b0;
    end
    else begin
        yo_state_dey1 <= yo_state;
        yo_state_dey2 <= yo_state_dey1;
        yo_state_dey3 <= yo_state_dey2;
    end
end

// always @(*) begin
//     if(!rst_n) begin
//         row1_start ='b0;
//         row2_start ='b0;
//         row3_start ='b0;
//         row4_start ='b0;
//         row5_start ='b0;
//         row6_start ='b0;
//         in_valid2_first_input = 'b1;
//         conv_start = 1'b0;
//         sram_num = 1'b0;
//         row_num = 'd0;
//     end
//     else if(in_valid2) begin
//         if (mode == 1'b0) begin
//             if (in_valid2_first_input) begin
//                 row1_start = matrix_idx * 'd128; //multi share
//                 row2_start = matrix_idx * 'd128 + 'd4;
//                 row3_start = matrix_idx * 'd128 + 'd8;
//                 row4_start = matrix_idx * 'd128 + 'd12;
//                 row5_start = matrix_idx * 'd128 + 'd16;
//                 row6_start = matrix_idx * 'd128 + 'd20;

//                 in_valid2_first_input = 1'b0;
//                 sram_num = 1'b0;
//                 row_num = 'd0;
//             end
//             // else begin
//             //     kernel1_start = matrix_idx * 'd5; //multi share
//             //     kernel2_start = matrix_idx * 'd5 + 'd1;
//             //     kernel3_start = matrix_idx * 'd5 + 'd2;
//             //     kernel4_start = matrix_idx * 'd5 + 'd3;
//             //     kernel5_start = matrix_idx * 'd5 + 'd4;
//             //     conv_start = 1'b1;
//             // end
//         end
//         else if (mode == 1'b1) begin
//             //deconv
//         end
//         else begin
//             kernel1_start = matrix_idx * 'd5; //multi share
//             kernel2_start = matrix_idx * 'd5 + 'd1;
//             kernel3_start = matrix_idx * 'd5 + 'd2;
//             kernel4_start = matrix_idx * 'd5 + 'd3;
//             kernel5_start = matrix_idx * 'd5 + 'd4;
//             conv_start = 1'b1;
//             //deconv need change
//         end
//     end
//     else if (conv_start && row_state == 3'd3) begin
//         case(z_state)
//             2'b00: row_num = row_num + 'd1;
//             2'b01: row_num = row_num - 'd1;
//             2'b10: row_num = row_num + 'd1;
//             2'b11: begin 
//                 if (row_num + 'd1 == 'd4) begin
//                     row_num = 'd0;
//                     // sram_num = ~sram_num;
//                     if (!sram_num) begin
//                         if (row1_start[1:0] == image_mod_row_end) begin
//                             case(image_mod_row_end)
//                                 2'b00: begin
//                                     // $display("row1_start: %d", row1_start);
//                                     row1_start = row1_start + 'd8;
//                                     row2_start = row2_start + 'd8;
//                                     row3_start = row3_start + 'd8;
//                                     row4_start = row4_start + 'd8;
//                                     row5_start = row5_start + 'd8;
//                                     row6_start = row6_start + 'd8;
//                                 end
//                                 2'b01: begin
//                                     row1_start = row1_start + 'd7;
//                                     row2_start = row2_start + 'd7;
//                                     row3_start = row3_start + 'd7;
//                                     row4_start = row4_start + 'd7;
//                                     row5_start = row5_start + 'd7;
//                                     row6_start = row6_start + 'd7;
//                                 end
//                                 default: begin //2'b11: begin
//                                     row1_start = row1_start + 'd5;
//                                     row2_start = row2_start + 'd5;
//                                     row3_start = row3_start + 'd5;
//                                     row4_start = row4_start + 'd5;
//                                     row5_start = row5_start + 'd5;
//                                     row6_start = row6_start + 'd5;
//                                 end
//                             endcase
//                         end
//                         else begin
//                             sram_num = ~sram_num;
//                             // row1_start = row1_start + 'd1;
//                             // row2_start = row2_start + 'd1;
//                             // row3_start = row3_start + 'd1;
//                             // row4_start = row4_start + 'd1;
//                             // row5_start = row5_start + 'd1;
//                             // row6_start = row6_start + 'd1;
//                         end
//                     end
//                     else begin
//                         row1_start = row1_start + 'd1;
//                         row2_start = row2_start + 'd1;
//                         row3_start = row3_start + 'd1;
//                         row4_start = row4_start + 'd1;
//                         row5_start = row5_start + 'd1;
//                         row6_start = row6_start + 'd1;
//                     end
//                 end
//                 else begin
//                     row_num = row_num + 'd1; 
//                 end
//             end
//         endcase
//     end
// end

reg signed [7:0] sfir1, sfir2, sfir3, sfir4;
reg signed [7:0] ssec1, ssec2, ssec3, ssec4;
reg signed [7:0] sk1, sk2, sk3, sk4, sk5;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sfir1 <= 'b0;
        sfir2 <= 'b0;
        sfir3 <= 'b0;
        sfir4 <= 'b0;

        ssec1 <= 'b0;
        ssec2 <= 'b0;
        ssec3 <= 'b0;
        ssec4 <= 'b0;

        sk1 <= 'b0;
        sk2 <= 'b0;
        sk3 <= 'b0;
        sk4 <= 'b0;
        sk5 <= 'b0;
    end
    else begin
        if (conv_start) begin //check
            sfir1 <= do1[31:24];
            sfir2 <= do1[23:16];
            sfir3 <= do1[15:8];
            sfir4 <= do1[7:0];

            ssec1 <= do2[31:24];
            ssec2 <= do2[23:16];
            ssec3 <= do2[15:8];
            ssec4 <= do2[7:0];

            sk1 <= ko[39:32];
            sk2 <= ko[31:24];
            sk3 <= ko[23:16];
            sk4 <= ko[15:8];
            sk5 <= ko[7:0];
        end
        else if (deconv_start) begin
            sfir1 <= do1[31:24];
            sfir2 <= do1[23:16];
            sfir3 <= do1[15:8];
            sfir4 <= do1[7:0];

            ssec1 <= do2[31:24];
            ssec2 <= do2[23:16];
            ssec3 <= do2[15:8];
            ssec4 <= do2[7:0];

            sk1 <= ko[7:0];
            sk2 <= ko[15:8];
            sk3 <= ko[23:16];
            sk4 <= ko[31:24];
            sk5 <= ko[39:32];
        end
    end
end

reg [15:0] mul_o1_save, mul_o2_save, mul_o3_save, mul_o4_save, mul_o5_save;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_o1_save <= 'b0;
        mul_o2_save <= 'b0;
        mul_o3_save <= 'b0;
        mul_o4_save <= 'b0;
        mul_o5_save <= 'b0;
    end
    else if (conv_start || deconv_start) begin
        mul_o1_save <= mul_o1;
        mul_o2_save <= mul_o2;
        mul_o3_save <= mul_o3;
        mul_o4_save <= mul_o4;
        mul_o5_save <= mul_o5;
    end
end

always @(*) begin//speed
    mul2 = 'b0;
    mul4 = 'b0;
    mul6 = 'b0;
    mul8 = 'b0;
    mul10 = 'b0;

    mul1 = 'b0;
    mul3 = 'b0;
    mul5 = 'b0;
    mul7 = 'b0;
    mul9 = 'b0;

    add1 = 'b0;
    add2 = 'b0;
    add3 = 'b0;
    add4 = 'b0;
    add5 = 'b0;

    if (conv_start) begin
        if (!sram_num_dey3) begin
            case (row_num_dey3)
                2'd0: begin
                    mul1 = sfir1;
                    mul3 = sfir2;
                    mul5 = sfir3;
                    mul7 = sfir4;
                    mul9 = ssec1;
                end
                2'd1: begin
                    mul1 = sfir2;
                    mul3 = sfir3;
                    mul5 = sfir4;
                    mul7 = ssec1;
                    mul9 = ssec2;
                end
                2'd2: begin
                    mul1 = sfir3;
                    mul3 = sfir4;
                    mul5 = ssec1;
                    mul7 = ssec2;
                    mul9 = ssec3;
                end
                2'd3: begin
                    mul1 = sfir4;
                    mul3 = ssec1;
                    mul5 = ssec2;
                    mul7 = ssec3;
                    mul9 = ssec4;
                end
            endcase
        end
        else begin
            case (row_num_dey3)
                2'd0: begin
                    mul1 = ssec1;
                    mul3 = ssec2;
                    mul5 = ssec3;
                    mul7 = ssec4;
                    mul9 = sfir1;
                end
                2'd1: begin
                    mul1 = ssec2;
                    mul3 = ssec3;
                    mul5 = ssec4;
                    mul7 = sfir1;
                    mul9 = sfir2;
                end
                2'd2: begin
                    mul1 = ssec3;
                    mul3 = ssec4;
                    mul5 = sfir1;
                    mul7 = sfir2;
                    mul9 = sfir3;
                end
                2'd3: begin
                    mul1 = ssec4;
                    mul3 = sfir1;
                    mul5 = sfir2;
                    mul7 = sfir3;
                    mul9 = sfir4;
                end
            endcase
        end

        // mul2 = sk1;
        // mul4 = sk2;
        // mul6 = sk3;
        // mul8 = sk4;
        // mul10 = sk5;

        // add1 = mul_o1_save;
        // add2 = mul_o2_save;
        // add3 = mul_o3_save;
        // add4 = mul_o4_save;
        // add5 = mul_o5_save;//speed

        // add1 = mul_o1;
        // add2 = mul_o2;
        // add3 = mul_o3;
        // add4 = mul_o4;
        // add5 = mul_o5;//speed

        // case (row_state)
        //     3'd0: add6 = add_o1;
        //     3'd1: add6 = 'b0;
        //     3'd2: add6 = add_o1;
        //     3'd3: add6 = add_o1;
        //     3'd4: add6 = add_o1;
        // endcase
    end
    else if (deconv_start) begin
        case (yo_state_dey3)
            4'd0: begin
                mul1 = 'd0;
                mul3 = 'd0;
                mul5 = 'd0;
                mul7 = 'd0;
                mul9 = sfir1;
            end
            4'd1: begin
                mul1 = 'd0;
                mul3 = 'd0;
                mul5 = 'd0;
                mul7 = sfir1;
                mul9 = sfir2;
            end
            4'd2: begin
                mul1 = 'd0;
                mul3 = 'd0;
                mul5 = sfir1;
                mul7 = sfir2;
                mul9 = sfir3;
            end
            4'd3: begin
                mul1 = 'd0;
                mul3 = sfir1;
                mul5 = sfir2;
                mul7 = sfir3;
                mul9 = sfir4;
            end
            4'd4: begin
                mul1 = sfir1;
                mul3 = sfir2;
                mul5 = sfir3;
                mul7 = sfir4;
                mul9 = ssec1;
            end
            4'd5: begin
                mul1 = sfir2;
                mul3 = sfir3;
                mul5 = sfir4;
                mul7 = ssec1;
                mul9 = ssec2;
            end
            4'd6: begin
                mul1 = sfir3;
                mul3 = sfir4;
                mul5 = ssec1;
                mul7 = ssec2;
                mul9 = ssec3;
            end
            4'd7: begin
                mul1 = sfir4;
                mul3 = ssec1;
                mul5 = ssec2;
                mul7 = ssec3;
                mul9 = ssec4;
            end
            4'd8: begin
                mul1 = ssec1;
                mul3 = ssec2;
                mul5 = ssec3;
                mul7 = ssec4;
                mul9 = sfir1;
            end
            4'd9: begin
                mul1 = ssec2;
                mul3 = ssec3;
                mul5 = ssec4;
                mul7 = sfir1;
                mul9 = sfir2;
            end
            4'd10: begin
                mul1 = ssec3;
                mul3 = ssec4;
                mul5 = sfir1;
                mul7 = sfir2;
                mul9 = sfir3;
            end
            4'd11: begin
                mul1 = ssec4;
                mul3 = sfir1;
                mul5 = sfir2;
                mul7 = sfir3;
                mul9 = sfir4;
            end
            4'd12: begin
                mul1 = ssec1;
                mul3 = ssec2;
                mul5 = ssec3;
                mul7 = ssec4;
                mul9 = 'd0;
            end
            4'd13: begin
                mul1 = ssec2;
                mul3 = ssec3;
                mul5 = ssec4;
                mul7 = 'd0;
                mul9 = 'd0;
            end
            4'd14: begin
                mul1 = ssec3;
                mul3 = ssec4;
                mul5 = 'd0;
                mul7 = 'd0;
                mul9 = 'd0;
            end
            4'd15: begin
                mul1 = ssec4;
                mul3 = 'd0;
                mul5 = 'd0;
                mul7 = 'd0;
                mul9 = 'd0;
            end
        endcase
    end
    mul2 = sk1;
    mul4 = sk2;
    mul6 = sk3;
    mul8 = sk4;
    mul10 = sk5;

    add1 = mul_o1_save;
    add2 = mul_o2_save;
    add3 = mul_o3_save;
    add4 = mul_o4_save;
    add5 = mul_o5_save;//speed
    // else begin
    //     //deconv
    //     mul2 = 'b0;
    //     mul4 = 'b0;
    //     mul6 = 'b0;
    //     mul8 = 'b0;
    //     mul10 = 'b0;

    //     mul1 = 'b0;
    //     mul3 = 'b0;
    //     mul5 = 'b0;
    //     mul7 = 'b0;
    //     mul9 = 'b0;
    // end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        add6 <= 'b0;
    end
    else if (tim == time_stop) begin
        add6 <= add6;
    end
    else begin
        // if (derow_state_dey3 == 1'b0) begin
        //     $display("add_o1: %d", add_o1);
        // end
        if(conv_start) begin
            case (row_state)
                3'd0: add6 <= add_o1;//speed
                3'd1: add6 <= add_o1;
                3'd2: add6 <= 'b0;
                3'd3: add6 <= add_o1;
                3'd4: add6 <= add_o1;
                // 3'd0: add6 <= add_o1;//speed
                // 3'd1: add6 <= 'b0;
                // 3'd2: add6 <= add_o1;
                // 3'd3: add6 <= add_o1;
                // 3'd4: add6 <= add_o1;
            endcase
        end
        else if (deconv_start) begin
            case (sha_state_dey3)
                4'd0: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= 'b0;
                        end
                        3'd2: begin
                            add6 <= 'b0;
                        end
                        3'd3: begin
                            add6 <= 'b0;
                        end
                        3'd4: begin
                            add6 <= 'b0;
                        end
                    endcase
                end
                4'd1: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= 'b0;
                        end
                        3'd2: begin
                            add6 <= 'b0;
                        end
                        3'd3: begin
                            add6 <= 'b0;
                        end
                        3'd4: begin
                            add6 <= add_o1;
                        end
                    endcase
                end
                4'd2: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= 'b0;
                        end
                        3'd2: begin
                            add6 <= 'b0;
                        end
                        3'd3: begin
                            add6 <= add_o1;
                        end
                        3'd4: begin
                            add6 <= add_o1;
                        end
                    endcase
                end
                4'd3: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= 'b0;
                        end
                        3'd2: begin
                            add6 <= add_o1;
                        end
                        3'd3: begin
                            add6 <= add_o1;
                        end
                        3'd4: begin
                            add6 <= add_o1;
                        end
                    endcase
                end
                4'd4: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= add_o1;
                        end
                        3'd2: begin
                            add6 <= add_o1;
                        end
                        3'd3: begin
                            add6 <= add_o1;
                        end
                        3'd4: begin
                            add6 <= add_o1;
                        end
                    endcase
                end
                4'd5: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= add_o1;
                        end
                        3'd2: begin
                            add6 <= add_o1;
                        end
                        3'd3: begin
                            add6 <= add_o1;
                        end
                        3'd4: begin
                            add6 <= add_o1;
                        end
                    endcase
                    // case (derow_state_dey3)
                    //     3'd0: begin
                    //         add6 <= 'b0;
                    //     end
                    //     3'd1: begin
                    //         add6 <= add_o1;
                    //     end
                    //     3'd2: begin
                    //         add6 <= add_o1;
                    //     end
                    //     3'd3: begin
                    //         add6 <= add_o1;
                    //     end
                    //     3'd4: begin
                    //         add6 <= add6;
                    //     end
                    // endcase
                end
                4'd6: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= add_o1;
                        end
                        3'd2: begin
                            add6 <= add_o1;
                        end
                        3'd3: begin
                            add6 <= add_o1;
                        end
                        3'd4: begin
                            add6 <= add6;
                        end
                    endcase
                    // case (derow_state_dey3)
                    //     3'd0: begin
                    //         add6 <= 'b0;
                    //     end
                    //     3'd1: begin
                    //         add6 <= add_o1;
                    //     end
                    //     3'd2: begin
                    //         add6 <= add_o1;
                    //     end
                    //     3'd3: begin
                    //         add6 <= add6;
                    //     end
                    //     3'd4: begin
                    //         add6 <= add6;
                    //     end
                    // endcase
                end
                4'd7: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= add_o1;
                        end
                        3'd2: begin
                            add6 <= add_o1;
                        end
                        3'd3: begin
                            add6 <= add6;
                        end
                        3'd4: begin
                            add6 <= add6;
                        end
                    endcase
                    // case (derow_state_dey3)
                    //     3'd0: begin
                    //         add6 <= 'b0;
                    //     end
                    //     3'd1: begin
                    //         add6 <= add_o1;
                    //     end
                    //     3'd2: begin
                    //         add6 <= add6;
                    //     end
                    //     3'd3: begin
                    //         add6 <= add6;
                    //     end
                    //     3'd4: begin
                    //         add6 <= add6;
                    //     end
                    // endcase
                end
                4'd8: begin
                    case (derow_state_dey3)
                        3'd0: begin
                            add6 <= 'b0;
                        end
                        3'd1: begin
                            add6 <= add_o1;
                        end
                        3'd2: begin
                            add6 <= add6;
                        end
                        3'd3: begin
                            add6 <= add6;
                        end
                        3'd4: begin
                            add6 <= add6;
                        end
                    endcase
                    // case (derow_state_dey3)
                    //     3'd0: begin
                    //         add6 <= 'b0;
                    //     end
                    //     3'd1: begin
                    //         add6 <= add6;
                    //     end
                    //     3'd2: begin
                    //         add6 <= add6;
                    //     end
                    //     3'd3: begin
                    //         add6 <= add6;
                    //     end
                    //     3'd4: begin
                    //         add6 <= add6;
                    //     end
                    // endcase
                end
            endcase
        end
    end
end

reg [1:0] output_state;
reg signed [19:0] max_pool, out_reg;
reg calcu_start, de_calcu_start;

wire signed [19:0] cmp_reg;

assign cmp_reg = (add_o1 > max_pool) ? add_o1 : max_pool;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        output_state <= 'b0;
        calcu_start <= 'b0;
        max_pool <= 20'b10000000000000000000;
        // output_start <= 'b0;

        out_valid <= 1'b0;
        out_value <= 1'b0;
        out_reg <= 'b0;
        // add6 <= 'b0;
        de_calcu_start <= 1'b0;
        // $display("rstn");
    end
    // else if (row_state == 3'd1) begin
    //     calcu_start <= 'b1;
    // end
    // else if (calcu_start && row_state == 3'd1) begin
    else if (tim == time_stop2) begin
        out_valid <= 'b0;
        out_value <= 'b0;
        // $display("bug1");
    end
    else if (tim >= time_stop) begin
        output_state <= 'b0;
        calcu_start <= 'b0;
        de_calcu_start <= 'b0;
        max_pool <= 20'b10000000000000000000;
        // output_start <= 'b0;

        out_reg <= out_reg >> 1;
        out_value <= out_reg[0];
        // $display("bug2");
    end
    else if (row_state == 3'd2 && calcu_start) begin//speed row_state == 3'd1
        // $display("out: %d", add_o1);
        case (output_state)
            2'b00: begin
                output_state <= 2'b01;
                max_pool <= cmp_reg;
            end
            2'b01: begin
                output_state <= 2'b10;
                max_pool <= cmp_reg;
            end
            2'b10: begin
                output_state <= 2'b11;
                max_pool <= cmp_reg;
            end
            2'b11: begin
                output_state <= 2'b00;
                max_pool <= 20'b10000000000000000000;
                out_reg <= cmp_reg >> 1;

                out_valid <= 'b1;
                out_value <= cmp_reg[0];
            end
        endcase
        // if (out_valid) begin
        //     out_value <= cmp_reg[19];
        //     out_reg <= out_reg << 1;
        // end
        if (out_valid && !(output_state == 2'b11)) begin//speed
            out_value <= out_reg[0];
            out_reg <= out_reg >> 1;
        end
        // $display("bug3");
    end
    else if (row_state == 3'd2 && !calcu_start) begin
        calcu_start <= 'b1;
        // if (out_valid && calcu_start && !(row_state == 3'd2 && output_state == 2'b11)) begin//speed
        //     out_value <= out_reg[0];
        //     out_reg <= out_reg >> 1;
        // end
        // $display("bug4");
    end
    else if (out_valid && calcu_start && !(row_state == 3'd2 && output_state == 2'b11)) begin//speed
        out_value <= out_reg[0];
        out_reg <= out_reg >> 1;
        // $display("bug5");
    end
    else if (derow_state_dey3 == 5'd5) begin// && de_calcu_start) begin//speed row_state == 3'd1
        out_valid <= 'b1;
        case (sha_state_dey4)
            4'd0: begin
                out_value <= add_o1[0];
                out_reg <= add_o1 >> 1;
                // $display("out0: %d", add_o1);
                // $display("time: %d", tim);
            end
            4'd1: begin
                out_value <= add_o1[0];
                out_reg <= add_o1 >> 1;
                // $display("out1: %d", add_o1);
                // $display("time: %d", tim);
            end
            4'd2: begin
                out_value <= add_o1[0];
                out_reg <= add_o1 >> 1;    
                // $display("out2: %d", add_o1);    
                // $display("time: %d", tim);
            end
            4'd3: begin
                out_value <= add_o1[0];
                out_reg <= add_o1 >> 1;        
                // $display("out3: %d", add_o1);
                // $display("time: %d", tim);
            end
            4'd4: begin
                out_value <= add_o1[0];
                out_reg <= add_o1 >> 1;        
                // $display("out4: %d", add_o1);
                // $display("time: %d", tim);
            end
            4'd5: begin
                out_value <= add6[0];
                out_reg <= add6 >> 1;        
                // $display("out5: %d", add6);
                // $display("time: %d", tim);
            end
            4'd6: begin
                out_value <= add6[0];
                out_reg <= add6 >> 1;      
                // $display("out6: %d", add6);  
                // $display("time: %d", tim);
            end
            4'd7: begin
                out_value <= add6[0];
                out_reg <= add6 >> 1;        
                // $display("out7: %d", add6);
                // $display("time: %d", tim);
            end
            4'd8: begin
                out_value <= add6[0];
                out_reg <= add6 >> 1;        
                // $display("out8: %d", add6);
                // $display("time: %d", tim);
            end
        endcase
        // if (out_valid) begin
        //     out_value <= out_reg[0];
        //     out_reg <= out_reg >> 1;
        //     // $display("bug5");
        // end
    end
    // else begin
    //     $display("bug6");
    //     $display(out_valid && de_calcu_start);
    // end
    // else if (deconv_start && tim == 'd4) begin
    //     de_calcu_start <= 1'b1;
    // end
    else if (out_valid) begin
        out_value <= out_reg[0];
        out_reg <= out_reg >> 1;
        // $display("bug5");
    end
    // else begin
    //     $display("outv: %d", out_valid);
    // end
    // $display("row_state: %d, tim: %d", row_state, tim);
end

// always @(posedge clk or negedge rst_n) begin
//     if(!rst_n) begin
//         out_valid <= 1'b0;
//         out_value <= 1'b0;
//     end
//     else if(tim == 'd9999) begin
//         out_valid <= 1'b1;
//     end
// end

endmodule