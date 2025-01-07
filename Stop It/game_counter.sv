// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.
// Module for a countdown counter, which can be used in a game to count down a value
module game_counter (
    input  logic       clk_4_i,        // Input clock signal, operating at a frequency of 4 Hz
    input  logic       rst_ni,         // Active-low reset signal
    input  logic       en_i,           // Enable signal for counting operation
    output logic [4:0] count_o         // 5-bit output representing the current count value
);

// Internal signals for the current and next count values
logic [4:0] count_d, count_q;         // count_d: next count value, count_q: current count value
// Initialize the reset value to 5'b11111, which is 31 in decimal
logic [4:0] reset_d = 5'b11111;       // Value to reset the counter to when reset is active
// Calculate the next count value by subtracting 1 from the current count
assign count_d = count_q - 1;
// `count_d` is assigned `count_q - 1` to create a countdown effect where the counter decrements by 1
// Flip-flop logic to update count_q on the rising edge of clk_4_i
always_ff @(posedge clk_4_i) begin
    if (!rst_ni) begin
        // If reset is active (rst_ni is low), set count_q to the reset value (31)
        count_q <= reset_d;
    end else if (en_i) begin
        // If reset is not active and enable signal is high, update count_q with count_d
        count_q <= count_d;
    end
    // If enable is low, count_q retains its previous value, pausing the countdown
end
// Output the current count value
assign count_o = count_q;
// count_o reflects the current count value in count_q

endmodule
