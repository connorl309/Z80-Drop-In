`timescale 1ns / 1ps

`include "z80_defines.v"

`define ADD 3'd0
`define SUB 3'd1
`define LSHF 3'd2
`define RSHF 3'd3
`define AND 3'd4
`define OR 3'd5
`define XOR 3'd6

parameter DATA_WID = 8;
// Gi = Ai * Bi
// Pi = Ai + Bi ( we want to avoid xor op )
wire [DATA_WID - 1:0] gen;
wire [DATA_WID - 1:0] pro;
wire [DATA_WID:0] carry_tmp;
assign carry_tmp[0] = cin;

generate
genvar i, ii;
// carry generator. effectively macro'd out during synthesis
for (i = 0; i < DATA_WID; i = i+1) begin
    assign gen[i] = opA[i] & opB[i];
    assign pro[i] = opA[i] | opB[i];
    assign carry_tmp[i+1] = gen[i] | (pro[i] & carry_tmp[i]);
end
assign carry_out = carry_tmp[DATA_WID];
// sum generator
genvar j;
for (j = 0; j < DATA_WID; j=j+1) begin
    assign sum[i] = opA[i] ^ opB[i] ^ carry_tmp[i];
end
endgenerate

endmodule

// 8 bit shifter modules
// the Z80 only shifted by 1 in either direction
// left shift
module lshf8(
    input [7:0] data,
    output [7:0] out,
    input wire rotate
);
assign out = {data[6:1], data[7] & rotate};
endmodule
// right shift
module rshf8(
    input [7:0] data,
    output [7:0] out,
    input wire rotate
);
assign out = {data[0] & rotate, data[7:1]};
endmodule


wire valid;
wire [1:0] cout;
reg [7:0] tmp_sum, tmp_sub, tmp_lshf, tmp_rshf;
wire [7:0] tmp;

// Submodule instantiation
cla8 adder(opA, opB, 0, cout[0], tmp_sum); // NOTE: We need to look at this for the ADC instruction
cla8 subber(opA, ~opB, 1, cout[1], tmp_sub); // NOTE: We need to look at this for the SBC instruction
lshf8 lshf(opA, tmp_lshf, rotate);
rshf8 rshf(opA, tmp_rshf, rotate);
// Other logic functions (like bitwise) we will just do manually here

// TBD: Update this as needed
always @(posedge clock) begin
    if (valid) begin
        case (mode)
            `ADD: begin
                accum <= tmp_sum;
             end
            `SUB: begin
            // H is set if borrow from bit 4; otherwise, it is reset.
            // TODO: fix the "H" bit flag here. it's not right.
                accum <= tmp_sub;
             end
            `LSHF: begin
                accum <= tmp_lshf;
             end
            `RSHF: begin
                accum <= tmp_rshf;
             end
            `AND: begin
                accum <= opA & opB;
             end
            `OR: begin
                accum <= opA | opB;
             end
             `XOR: begin
                accum <= opA ^ opB;
             end
        endcase
    end
end

module z80_alu(
    input clock,
    input [2:0] mode,
    input rotate,
    input [7:0] opA,
    input [7:0] opB,
    output reg [7:0] accum
);
module cla8(
    input [7:0] opA,
    input [7:0] opB,
    input cin,
    output carry_out,
    output [7:0] sum
);

endmodule

// 8 bit CLA module
