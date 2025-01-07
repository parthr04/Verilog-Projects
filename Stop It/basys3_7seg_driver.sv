// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.
// Module for a 4-digit 7-segment display driver for the Basys 3 board
module basys3_7seg_driver (
    input              clk_1k_i,        // 1 kHz clock input to control display refresh rate
    input              rst_ni,          // Active-low reset signal
    input  logic       digit0_en_i,     // Enable signal for digit 0
    input  logic [3:0] digit0_i,        // 4-bit input for digit 0 value (0-9)
    input  logic       digit1_en_i,     // Enable signal for digit 1
    input  logic [3:0] digit1_i,        // 4-bit input for digit 1 value (0-9)
    input  logic       digit2_en_i,     // Enable signal for digit 2
    input  logic [3:0] digit2_i,        // 4-bit input for digit 2 value (0-9)
    input  logic       digit3_en_i,     // Enable signal for digit 3
    input  logic [3:0] digit3_i,        // 4-bit input for digit 3 value (0-9)
    output logic [3:0] anode_o,         // Output signal for controlling which digit is active
    output logic [6:0] segments_o       // Output signal for 7-segment display segments (A-G)
);

// Internal signals
logic [3:0] digit;                      // Holds the current digit value to be displayed
logic [3:0] anode_d, anode_q;           // Anode control signals for current and next state

// Instantiate hex7seg module, which maps a 4-bit binary value to 7-segment output
hex7seg hex7seg (
    .d3(digit[3]),                      // Assign 4 bits of digit to hex7seg inputs
    .d2(digit[2]),
    .d1(digit[1]),
    .d0(digit[0]),
    .A(segments_o[0]),                  // Connect hex7seg outputs to 7-segment display segments
    .B(segments_o[1]),
    .C(segments_o[2]),
    .D(segments_o[3]),
    .E(segments_o[4]),
    .F(segments_o[5]),
    .G(segments_o[6])
);

// Flip-flop block to update anode_q on every clock cycle
always_ff @(posedge clk_1k_i) begin
    if (!rst_ni) begin
        // If reset is active (low), turn off all anodes (anode_q = 1111)
        anode_q <= 4'b1111;
    end else begin
        // Update anode_q with the next anode state (anode_d)
        anode_q <= anode_d;
    end
end

// Logic for rotating through anodes to display each digit in a multiplexed fashion
assign anode_d = (anode_q == 3) ? 0 : anode_q + 1;
// If anode_q is 3 (last digit), reset it to 0; otherwise, increment by 1

// Assign anode output based on current anode and digit enable signals
assign anode_o = (anode_q == 3) ? (digit3_en_i ? 4'b0111 : 4'b1111) :
                 ((anode_q == 2) ? (digit2_en_i ? 4'b1011 : 4'b1111) :
                 ((anode_q == 1) ? (digit1_en_i ? 4'b1101 : 4'b1111) :
                 ((anode_q == 0) ? (digit0_en_i ? 4'b1110 : 4'b1111) : 4'b1111)));

// Each case checks the active digit (based on anode_q) and if enabled, selects the respective anode signal.
// Anode_o: 4'b0111, 4'b1011, 4'b1101, 4'b1110 correspond to enabling digits 3, 2, 1, and 0 respectively.
// If a digit is disabled, anode_o is set to 4'b1111, which turns off all segments for that position.

// Select the correct digit value based on the current anode_q value
assign digit = (anode_q == 3) ? digit3_i :
               ((anode_q == 2) ? digit2_i :
               ((anode_q == 1) ? digit1_i :
               ((anode_q == 0) ? digit0_i : 0)));
// The 'digit' signal is assigned the 4-bit binary value corresponding to the current anode position.
// If anode_q is 3, select digit3_i, if 2 select digit2_i, and so on. If no condition matches, default to 0.

endmodule
