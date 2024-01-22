


// module SORT_IP #(
//     parameter IP_WIDTH = 5
// )(  
//     input   [IP_WIDTH*5-1:0] IN_weight,
//     input   [IP_WIDTH*4-1:0] IN_character,
//     output reg  [IP_WIDTH*4-1:0] OUT_character
// );
// parameter SIZE=5; 
//     reg  [IP_WIDTH*5-1:0] OUT_index;
//     reg [IP_WIDTH*SIZE-1:0] sorted_bus;
//     always @(*) begin
//         OUT_index = sorted_bus;
//     end

//     integer i, j;
//     reg [SIZE-1:0] temp;
//     reg [SIZE-1:0] array [1:IP_WIDTH];
//     reg [SIZE-1:0] index [1:IP_WIDTH];
//     always @* begin
//         for (i = 0; i < IP_WIDTH; i = i + 1) begin
//             array[i+1] = IN_weight[i*SIZE +: SIZE];
//             index[i+1] = IN_character[i*SIZE +: SIZE];
//         end

//         for (i = IP_WIDTH; i > 0; i = i - 1) begin
//             for (j = 1 ; j < i; j = j + 1) begin
//                 if (array[j] < array[j + 1]) begin
//                     temp         = array[j];
//                     array[j]     = array[j + 1];
//                     array[j + 1] = temp;
//                     temp         = index[j];
//                     index[j]     = index[j + 1];
//                     index[j + 1] = temp;
//                 end 
//             end
//         end
// //display array of sorted data
//         for (i = 0; i < IP_WIDTH; i = i + 1) begin
//             $display("array[%0d] = %d", i, array[i+1]);
//         end
//     //display indexes of sorted data orginal and sorted
//         for (i = 0; i < IP_WIDTH; i = i + 1) begin
//             $display("index[%0d] = %d", i, index[i+1]);
//         end
//         for (i = 0; i < IP_WIDTH; i = i + 1) begin
//             sorted_bus[i*SIZE +: SIZE] = index[i+1];
//         end
//     end

//     always @* begin
//         for (i = 0; i < IP_WIDTH; i = i + 1) begin
//             OUT_character[i*4 +: 4] = sorted_bus[i*SIZE +: SIZE];
//         end
//       //  $display(sorted_bus);
//     end

// genvar idx;
// generate
// for (idx = 0; idx < IP_WIDTH*4; idx = idx + 4) begin
// always @* begin
//        // $display("sorthIN_character[%0d:%0d] = %h", idx+3, idx, IN_character[idx+3:idx]);
//      //   $display("array[%0d:%0d] = %h", idx+3, idx, array[idx+3:idx]);
//         $display("sorted bus[%0d:%0d] = %h", idx+3, idx, sorted_bus[idx+3:idx]);
//     end
// end

module SORT_IP #(
    parameter IP_WIDTH = 8
)(  
    input   [IP_WIDTH*5-1:0] IN_weight,
    input   [IP_WIDTH*4-1:0] IN_character,
    output reg  [IP_WIDTH*4-1:0] OUT_character
);
    parameter SIZE=5; 
    reg  [IP_WIDTH*4-1:0] OUT_index;
    reg [IP_WIDTH*SIZE-1:0] sorted_bus;
    always @(*) begin
        OUT_index = sorted_bus;
    end

    integer i, j;
    reg [SIZE-1:0] temp,temp1;
    reg [4:0] array [1:IP_WIDTH];
    reg [3:0] index [1:IP_WIDTH];
    always @* begin
        for (i = 0; i < IP_WIDTH; i = i + 1) begin
            array[i+1] = IN_weight[i*5 +: 5];
            index[i+1] = IN_character[i*4 +: 4];
          //  $display("array[%0d] = %d", i, array[i+1]);
       //    $display("index_pad[%0d] = %d", i, index[i+1]);
        end

        for (i = IP_WIDTH; i > 0; i = i - 1) begin
            for (j = 1 ; j < i; j = j + 1) begin
                if (array[j] > array[j + 1]&&array[j] != array[j + 1]) begin
                    temp         = array[j];
                    temp1        = index[j];

                    array[j]     = array[j + 1];
                    index[j]     = index[j + 1];

                    array[j + 1] = temp;
                    index[j + 1] = temp1;
                end else if(array[j] == array[j + 1] && index[j] > index[j + 1]) begin
                        temp         = array[j];
                        temp1        = index[j];

                        array[j]     = array[j + 1];
                        index[j]     = index[j + 1];

                        array[j + 1] = temp;
                        index[j + 1] = temp1;
                end
            end
        end
        // for(i=0;i<IP_WIDTH;i=i+1)begin 
        //     $display("index[%0d] = %h", i, index[i+1]);
        // end
        // $display("------------------------------------");
        //   for(i=0;i<IP_WIDTH;i=i+1)begin 
        //     $display("array[%0d] = %h", i, array[i+1]);
        // end
        for (i = 0; i < IP_WIDTH; i = i + 1) begin
            sorted_bus[i*SIZE +: SIZE] = index[i+1];
        end
    end
    always @* begin
        for (i = 0; i < IP_WIDTH; i = i + 1) begin
            OUT_character[i*4 +: 4] = sorted_bus[i*SIZE +: SIZE];
        end
    end
    // always @* begin
    //     $display("OUT_character = %h", OUT_character);
    // end
endmodule
