// ========================================
// Designer: Will Lin (PCS Lab, NYCU, TW)
// ========================================
`ifdef RTL
    `define CYCLE_TIME 20
`endif
`ifdef GATE
    `define CYCLE_TIME 20
`endif

module PATTERN(
    // Output signals
    clk,
	rst_n,
	in_valid,
    in_weight, 
	out_mode,
    // Input signals
    out_valid, 
	out_code
);

// ========================================
// Input & Output
// ========================================
output reg clk, rst_n, in_valid, out_mode;
output reg [2:0] in_weight;

input out_valid, out_code;
wire out_value;
assign out_value = out_code;
// ========================================
// Parameter
// ========================================
// parameter PAT_NUM = 1000;
// parameter SEED = 123;
parameter MAX_DELAY_CYCLE = 2000;
parameter NEXT_PAT_CYCLE_MIN = 2;
parameter NEXT_PAT_CYCLE_MAX = 4;

parameter W_NUM = 8;
parameter OUTPUT_BITS = 30;
// ========================================
// Intergers
// ========================================
integer PAT_NUM;
integer exe_cycles, tot_cycles;
integer pat;
integer f_in;
integer f_ans;
integer f_debug;
integer i,j,k;

integer _mode;
integer _weights[0:W_NUM-1];
reg [OUTPUT_BITS-1:0]_golden;
reg [OUTPUT_BITS-1:0]_your;



// String control
// Should use %0s
reg[9*8:1]  reset_color       = "\033[1;0m";
reg[10*8:1] txt_black_prefix  = "\033[1;30m";
reg[10*8:1] txt_red_prefix    = "\033[1;31m";
reg[10*8:1] txt_green_prefix  = "\033[1;32m";
reg[10*8:1] txt_yellow_prefix = "\033[1;33m";
reg[10*8:1] txt_blue_prefix   = "\033[1;34m";
reg[10*8:1] txt_cyan_prefix   = "\033[1;36m";

reg[10*8:1] bkg_black_prefix  = "\033[40;1m";
reg[10*8:1] bkg_red_prefix    = "\033[41;1m";
reg[10*8:1] bkg_green_prefix  = "\033[42;1m";
reg[10*8:1] bkg_yellow_prefix = "\033[43;1m";
reg[10*8:1] bkg_blue_prefix   = "\033[44;1m";
reg[10*8:1] bkg_white_prefix  = "\033[47;1m";


//================================================================
// design
//================================================================



// ======================
// main
// ======================
always #(`CYCLE_TIME/2.0) clk = ~clk;
initial clk = 1'b0;

initial main;

task main; 
    f_in = $fopen("../00_TESTBED/input.txt", "r");
    f_ans = $fopen("../00_TESTBED/output.txt", "r");
    f_debug = $fopen("../00_TESTBED/debug.txt", "r");
    k = $fscanf(f_in, "%d", PAT_NUM);
    reset_task;

    for(pat=0; pat<PAT_NUM; pat=pat+1)begin
        input_task;
        // cal_task;
        wait_task;
        check_task;
        $display("%0sPASS PATTERN NO.%4d, %0sCycles: %3d%0s",txt_blue_prefix, pat, txt_green_prefix, exe_cycles, reset_color);
        @(negedge clk);
    end
    pass_task;
begin

end
endtask

task reset_task; begin
    force clk = 0;
    rst_n = 1;
    in_valid = 0;
    out_mode = 'dx;
    in_weight = 'dx;

    tot_cycles = 0;

    #(`CYCLE_TIME) rst_n = 0;
    #(`CYCLE_TIME) rst_n = 1;
    if (out_valid !== 0 || out_value !== 0) begin
        $display("==========================================================================");
        $display("                ERROR after reset");
        $display("    out_valid & out_value are not 0 at %4d ns  ", $time);
        $display("==========================================================================");
        repeat(5) @(negedge clk);
        $finish;
    end
    #(`CYCLE_TIME/2.0) release clk;
end endtask

task input_task; begin
    _read_input;
    repeat($urandom_range(NEXT_PAT_CYCLE_MAX, NEXT_PAT_CYCLE_MIN)-2) @(negedge clk);
    for(i=0; i<W_NUM; i=i+1)begin
        if(i== 0) out_mode = _mode;
        in_weight = _weights[i];
        in_valid = 1;
        check_out_valid;
        @(negedge clk);
        out_mode = 'dx;
        in_weight = 'dx;
        in_valid = 0;
    end
end
endtask

task _read_input;
begin
    k = $fscanf(f_in,"%d",_mode);
    for(i=0; i<W_NUM; i=i+1)begin
        k = $fscanf(f_in,"%d",_weights[i]);
    end
end
endtask

task check_out_valid; begin
    if (out_valid !== 0 || out_value !== 0) begin
        $display("==========================================================================");
        $display("    out_valid & out_value are not 0 at %4d ns  ", $time);
        $display("==========================================================================");
        repeat(5) @(negedge clk);
        $finish;
    end
end endtask

task wait_task; begin
    exe_cycles = 0;
    while (out_valid !== 1) begin
        if (out_value !== 0) begin
            $display("==========================================================================");
            $display("    out_value is not 0 at %4d ns  ", $time);
            $display("==========================================================================");
            repeat(5) @(negedge clk);
            $finish;
        end
        if (exe_cycles == MAX_DELAY_CYCLE) begin
            $display("==========================================================================");
            $display("    The execution latency at %4d ps is over %5d cycles  ", $time, MAX_DELAY_CYCLE);
            $display("==========================================================================");
            repeat(5) @(negedge clk);
            $finish; 
        end
        exe_cycles = exe_cycles + 1;
        @(negedge clk);
    end
end endtask

task check_task;
integer _totalCycle;
integer _bit;
integer out_lat;
begin
    out_lat = 0;
    k = $fscanf(f_ans,"%d",_totalCycle);     
    k = $fscanf(f_ans,"%b",_golden); 
    _clear_output_task;
    while(out_valid === 1) begin
        if (out_lat === _totalCycle) begin
            $display("==========================================================================");
            $display("    %0sOut cycles are %2d%0s !== %0sgolden cycles: %2d%0s at %4d ns ", txt_blue_prefix, out_lat+1, reset_color, txt_green_prefix, _totalCycle, reset_color, $time);
            $display("    golden = %0s%b%0s, your = %0s%b%0s", txt_blue_prefix, _golden, reset_color, txt_green_prefix, _your, reset_color);
            $display("==========================================================================");
            repeat(5) @(negedge clk);
            $finish;
        end
        _bit = _totalCycle - 1 - out_lat;
        _your[_bit] = out_value;
        out_lat = out_lat + 1;
        @(negedge clk);
    end
    if (out_lat<_totalCycle) begin
        $display("==========================================================================");
        $display("    %0sOut cycles are %2d%0s < %0sgolden cycles: %2d%0s at %4d ns ", txt_blue_prefix, out_lat, reset_color, txt_green_prefix, _totalCycle, reset_color, $time);
        $display("    golden = %0s%b%0s, your = %0s%b%0s", txt_blue_prefix, _golden, reset_color, txt_green_prefix, _your, reset_color);
        $display("==========================================================================");
        repeat(5) @(negedge clk);
        $finish;
    end
    if(_golden !== _your) begin
        $display("==========================================================================");
        $display("    Out is not correct at pattern #%6d  ", pat);
        $display("    golden = %0s%b%0s, your = %0s%b%0s", txt_blue_prefix, _golden, reset_color, txt_green_prefix, _your, reset_color);
        $display("==========================================================================");
        // _dumpYourOutput;
        repeat(5) @(negedge clk);
        $finish;
    end
    tot_cycles = tot_cycles + exe_cycles;
end endtask

task _clear_output_task;
begin
    _your = 0;
end
endtask;

task pass_task; 
integer tot_lat;
begin
    tot_lat = tot_cycles*`CYCLE_TIME;
    $display("\n");
    $display("  ========================================       |\\____||   ");
    $display("  ||         %0sCongratulations !!%0s         ||      /  O.O  | ", txt_yellow_prefix, reset_color);
    $display("  ||           %0sPASS This Lab%0s            ||     /______  | ", txt_red_prefix, reset_color);
    $display("  ||         ...Maybe (｡◕ ∀ ◕｡)         ||    /^ ^ ^\\   | ");
    $display("  ||        %0s# of Patterns: %-8d%0s     ||   /^ ^ ^ ^| ||", txt_blue_prefix, PAT_NUM, reset_color);
    $display("  ||        %0s# of Cycles: %-8d%0s       ||  |        |w||", txt_green_prefix, tot_cycles, reset_color);
    $display("  ||        %0sTotal Latency: %-8d%0s     ||   \\m___m_____|", txt_cyan_prefix, tot_lat, reset_color);
    $display("  ========================================                    ");
    $display("\n");
    $finish;
end endtask

endmodule