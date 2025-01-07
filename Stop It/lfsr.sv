// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.
// Module implementing an 8-bit Linear Feedback Shift Register (LFSR)
// This module generates pseudo-random numbers using a feedback polynomial.
module lfsr (
    input  logic       clk_i,      // Clock input
    input  logic       rst_ni,     // Active-low reset signal
    input  logic       next_i,     // Control signal to shift to the next random number
    output logic [4:0] rand_o      // 5-bit output for the generated random number
);
// Internal signals for current and next state of the LFSR
logic [7:0] rand_d, rand_q;       // rand_d: next state, rand_q: current state of the LFSR
// Feedback logic for the LFSR based on XOR taps
assign rand_d[0] = rand_q[0] ^ rand_q[5] ^ rand_q[6] ^ rand_q[7];
// Generates the feedback bit based on XORing specific bits (taps) of the current state (rand_q).
// This setup creates a maximal-length LFSR sequence by applying a specific polynomial function.
// Shift the bits of the LFSR
assign rand_d[7:1] = rand_q[6:0];
// Assigns the next state for each bit by shifting the current state left by one position.
// The leftmost bit (rand_d[0]) is set by the feedback, creating the shift effect.
// Flip-flop logic to update the LFSR state on each rising clock edge
always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        // If reset is active (low), initialize the LFSR with a non-zero seed (e.g., 1)
        rand_q <= 1;
    end else if (next_i) begin
        // If reset is not active and next_i is high, update the LFSR state with rand_d
        rand_q <= rand_d;
    end
    // If next_i is low, retain the current state, pausing the LFSR operation
end
// Output the lower 5 bits of the LFSR state as the random number
assign rand_o = rand_q[4:0];
// The output rand_o uses only the lower 5 bits of the 8-bit LFSR for the random output
endmodule
