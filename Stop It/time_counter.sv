// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.
// Module for a 5-bit time counter
// This counter increments on each rising edge of the clock when enabled
module time_counter (
    input  logic       clk_4_i,    // 4 Hz clock input
    input  logic       rst_ni,     // Active-low reset signal
    input  logic       en_i,       // Enable signal to allow counting
    output logic [4:0] count_o     // 5-bit output representing the current count value
);
// Internal signals to hold the current count and next count values
logic [4:0] count_q, count_d;      // count_q: current count, count_d: next count value
// Reset value for the counter (5'b00000, which is 0 in decimal)
logic [4:0] reset_d = 5'b00000;    // Defines the reset state of the counter
// Combinational logic to calculate the next count value by incrementing count_q
assign count_d = count_q + 1;
// When enabled, the counter increments by 1 on each clock cycle
// Flip-flop logic to update the counter on each rising edge of clk_4_i
always_ff @(posedge clk_4_i) begin
    if (!rst_ni) begin
        // If reset is active (low), set the count to the reset value (0)
        count_q <= reset_d;
    end else if (en_i) begin
        // If enabled, update count_q with the next count value (count_d)
        count_q <= count_d;
    end
    // If en_i is low, the counter holds its current value (pauses counting)
end
// Assign the current count value (count_q) to the output count_o
assign count_o = count_q;
// count_o reflects the current value of the counter, representing elapsed time
endmodule
