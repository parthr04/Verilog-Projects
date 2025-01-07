// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module alu (
    input  logic [7:0] a_i,
    input  logic [7:0] b_i,
    input  logic [3:0] operation_i,
    output logic [7:0] y_o
);

    // Internal wires for storing function results
    wire [7:0] flog2_result;
    wire [7:0] sqrt_result;

    // Instantiate the flog2 module
    flog2 flog2_inst (
        .a_i(a_i),
        .y_o(flog2_result)
    );

    // Instantiate the sqrt module
    sqrt sqrt_inst (
        .a_i(a_i),
        .y_o(sqrt_result)
    );

    // Continuous assignment using ternary operators to select the operation
    assign y_o = (operation_i[0] ? (a_i + b_i) :
                  operation_i[1] ? (a_i - b_i) :
                  operation_i[2] ? flog2_result :
                  operation_i[3] ? sqrt_result : 8'b0);

endmodule
