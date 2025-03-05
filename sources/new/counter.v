module Top_Upcounter (
    input clk,
    input reset,
    input [1:0] sw,
    output [3:0] seg_comm,
    output [7:0] seg
);
    wire [13:0] count;
    wire o_clk;



    clkdivide U_clkdivide (
        .clk  (clk),
        .reset(reset),
        .o_clk(o_clk)
    );

    counter U_counter (
        .clk(o_clk),
        .reset(reset),
        .run_stop(sw[0]),
        .clear(sw[1]),
        .count(count)
    );

    fnd_controller U_fndcontrollder (
        .clk(clk),
        .reset(reset),
        .count(count),
        .seg_comm(seg_comm),
        .seg(seg)
    );

endmodule

module clkdivide (  //10hz로 바꾸기
    input  clk,
    input  reset,
    output o_clk
);

    parameter FCOUNT = 5_000_000;
    reg [$clog2(FCOUNT)-1:0] r_counter;
    reg r_clk;
    assign o_clk = r_clk;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if (r_counter == FCOUNT - 1) begin
                r_counter = 0;
                r_clk = r_clk + 1;
            end else begin
                r_counter = r_counter + 1;
            end
        end
    end
endmodule

module counter (
    input clk,
    input reset,
    input run_stop,
    input clear,
    output [13:0] count
);
    reg [13:0] r_count;
    reg r_run_stop;
    assign count = r_count;

    always @(posedge clk , posedge reset , posedge clear , negedge run_stop) begin 
        //clear는 0->1일때동작, run_stop은 1->0이될때의동작이중요함
        if (reset) begin
            r_count <= 0;
            r_run_stop <= 0;
        end else if (clear) begin
            r_count <= 0;
        end else if (!run_stop) begin
            r_run_stop <= 0;
        end else begin
            r_run_stop <= 1;
            if (r_run_stop) begin
                if (r_count == 10_000 - 1) begin
                    r_count <= 0;
                end else begin
                    r_count <= r_count + 1;
                end
            end
        end
    end

endmodule

