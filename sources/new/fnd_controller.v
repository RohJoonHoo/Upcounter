`timescale 1ns / 1ps


module fnd_controller (
    input clk,
    input reset,
    input [13:0] count,
    output [3:0] seg_comm,
    output [7:0] seg
);

    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000;
    wire [3:0] bcd;
    wire [1:0] seg_sel;
    wire o_clk;

    clkdivider U_clkdivider (
        .clk  (clk),
        .reset(reset),
        .o_clk(o_clk)
    );

    counter_4 U_counter_4 (
        .clk  (o_clk),
        .reset(reset),
        .o_sel(seg_sel)
    );

    digit_splitter U_digit_splitter (
        .bcd(count),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000)
    );

    mux_4x1 U_mux4x1 (
        .sel(seg_sel),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000),
        .bcd(bcd)
    );

    decoder2to4 U_decoder2to4 (
        .seg_sel (seg_sel),
        .seg_comm(seg_comm)
    );

    bcdtoseg U_bcdtoseg (
        .bcd(bcd),
        .seg(seg)
    );

endmodule


module clkdivider (
    input  clk,
    input  reset,
    output o_clk
);
    parameter FCOUNT = 250_000;
    reg [$clog2(FCOUNT)-1:0] r_counter;
    reg r_clk;
    assign o_clk = r_clk;

    always @(posedge clk, posedge reset) begin  //reset을 넣으면 동기식
        if (reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if (r_counter == FCOUNT - 1) begin  //100Mhz -> 400 hz
                r_counter = 0;
                r_clk = r_clk + 1;
            end else begin
                r_counter = r_counter + 1;
            end
        end
    end
endmodule

module counter_4 (
    input clk,
    input reset,
    output [1:0] o_sel
);

    reg [1:0] r_counter;
    assign o_sel = r_counter;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
        end else begin
            r_counter <= r_counter + 1;
        end
    end
endmodule

module decoder2to4 (
    input [1:0] seg_sel,
    output reg [3:0] seg_comm
);
    always @(seg_sel) begin
        case (seg_sel)
            2'b00:   seg_comm = 4'b1110;
            2'b01:   seg_comm = 4'b1101;
            2'b10:   seg_comm = 4'b1011;
            2'b11:   seg_comm = 4'b0111;
            default: seg_comm = 4'b1111;
        endcase
    end
endmodule

module bcdtoseg (
    input [3:0] bcd,
    output reg [7:0] seg  //7-segment led
);
    //always 구문 출력으로 reg type를 가져야한다
    always @(bcd) begin
        case (bcd)
            4'h0: seg = 8'hC0;
            4'h1: seg = 8'hF9;
            4'h2: seg = 8'hA4;
            4'h3: seg = 8'hB0;
            4'h4: seg = 8'h99;
            4'h5: seg = 8'h92;
            4'h6: seg = 8'h82;
            4'h7: seg = 8'hF8;
            4'h8: seg = 8'h80;
            4'h9: seg = 8'h90;
            4'ha: seg = 8'h88;
            4'hb: seg = 8'h83;
            4'hc: seg = 8'hC6;
            4'hd: seg = 8'hA1;
            4'he: seg = 8'h86;
            4'hf: seg = 8'h8E;
            default: seg = 8'hFF;
        endcase
    end
endmodule

module digit_splitter (
    input  [13:0] bcd,
    output [3:0] digit_1,
    output [3:0] digit_10,
    output [3:0] digit_100,
    output [3:0] digit_1000
);
    assign digit_1 = bcd % 10;
    assign digit_10 = bcd / 10 % 10;
    assign digit_100 = bcd / 100 % 10;
    assign digit_1000 = bcd / 1000 % 10;
endmodule

module mux_4x1 (
    input [1:0] sel,
    input [3:0] digit_1,
    input [3:0] digit_10,
    input [3:0] digit_100,
    input [3:0] digit_1000,
    output reg [3:0] bcd
);

    always @(sel, digit_1, digit_10, digit_100, digit_1000) begin
        case (sel)
            2'b00:   bcd = digit_1;
            2'b01:   bcd = digit_10;
            2'b10:   bcd = digit_100;
            2'b11:   bcd = digit_1000;
            default: bcd = digit_1000;
        endcase
    end

endmodule
