// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.
module led_shifter (
    input  logic        clk_i,        // Clock input
    input  logic        rst_ni,       // Active-low reset input
    input  logic        shift_i,      // Shift control signal
    input  logic [15:0] switches_i,   // Input switches to set LED pattern
    input  logic        load_i,       // Load control signal
    input  logic        off_i,        // Turn-off control for LEDs
    output logic [15:0] leds_o        // Output for the LED states
);
// Internal signals for LED states
logic [15:0] leds_d, leds_q;         // leds_d is the next state, leds_q is the current state
logic [15:0] zero = 0;               // Zero value to turn off all LEDs
// Sequential logic to update the current LED state
always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        // Reset condition: set all LEDs off on reset
        leds_q <= '0;
    end else begin
        // Update the current state with the next state
        leds_q <= leds_d;
    end
end
// Determine the next LED state based on control signals
// - If load_i is active, load switches_i value into leds_d
// - If shift_i is active, shift the LEDs to the left and add 1 at the rightmost position
// - Otherwise, maintain the current state of leds_q
assign leds_d = (load_i) ? switches_i : ((shift_i) ? {leds_q[14:0], 1'b1} : leds_q);
// Determine LED output based on off_i signal
// - If off_i is active, set all LEDs off (leds_o = zero)
// - Otherwise, output the current LED state
assign leds_o = (off_i) ? zero : leds_q;
endmodule
