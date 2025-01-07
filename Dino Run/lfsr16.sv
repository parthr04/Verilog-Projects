// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module lfsr16 (
    input  logic       clk_i,
    input  logic       rst_ni,

    input  logic       next_i,
    output logic [15:0] rand_o
);

// TODO

logic [15:0] rand_q, rand_d;

always_ff @(posedge clk_i) begin
    if(!rst_ni) begin
        rand_q <= rand_d;
    end
    else if (next_i) begin
        rand_q <= rand_d;
    end
    else begin
        rand_q <= rand_d;
    end
end

assign rand_d = (!rst_ni) ? 1 :
((next_i) ? {rand_q[14:0], (rand_q[15] ^ rand_q[14] ^ rand_q[12] ^ rand_q[3])}: rand_q);
assign rand_o = rand_q;

endmodule
