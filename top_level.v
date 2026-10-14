`timescale 1ns / 1ps
module cic_decimator #(
    parameter N = 4,     
    parameter R = 512,   
    parameter BIN = 2,     
    parameter BOUT = 20)
    (
    input  wire clk,
    input  wire reset,
    input  wire signed [BIN-1:0] din,
    output reg  signed [BOUT-1:0] dout,
    output reg  dvalid);
    localparam BMAX = N*$clog2(R) + BIN;   
    wire signed [BMAX-1:0] din_ext = din;

   wire signed [BMAX-1:0] i_out [0:N-1];
    genvar k;
    generate
        for (k = 0; k < N; k = k + 1) begin : INT
            if (k == 0)
                integrator #(.W(BMAX)) u (
                    .clk(clk), .reset(reset), .din(din_ext), .dout(i_out[k]));
            else
                integrator #(.W(BMAX)) u (
                    .clk(clk), .reset(reset), .din(i_out[k-1]), .dout(i_out[k]));
        end
    endgenerate
    wire tick;
    downsampler #(.R(R)) u_ds (.clk(clk), .reset(reset), .tick(tick));
    wire signed [BMAX-1:0] c [0:N];
    assign c[0] = i_out[N-1];
    generate
        for (k = 0; k < N; k = k + 1) begin : CMB
            comb #(.W(BMAX)) u (
                .clk(clk), .reset(reset), .tick(tick),
                .din(c[k]), .dout(c[k+1]));
        end
    endgenerate
    wire signed [BOUT-1:0] sliced;
    generate
        if (BMAX >= BOUT) begin : SLICE
            assign sliced = c[N][BMAX-1 -: BOUT];
        end else begin : PAD
            assign sliced = c[N];   
        end
    endgenerate

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dout   <= 0;
            dvalid <= 0;
        end else begin
            dvalid <= tick;
            if (tick) dout <= sliced;
        end
    end
endmodule
