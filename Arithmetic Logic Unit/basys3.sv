// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module basys3(
    input  logic [15:0] sw,
    input  logic btnU,
    input  logic btnL,
    input  logic btnR,
    input  logic btnD,
    output logic [7:0]  led
);

wire [3:0] operation;

assign operation = btnU ? 1 : btnL ? 2 : btnR ? 4: btnD ? 8:0;

    alu alu_inst (
        .a_i(sw[7:0]),
        .b_i(sw[15:8]),
        .operation_i(operation),
        .y_o(led[7:0])
    );

endmodule

