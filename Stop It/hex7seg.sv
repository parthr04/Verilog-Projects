// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.
// Module to drive a 7-segment display based on a 4-bit hexadecimal input
// Each segment (A-G) is controlled by combinational logic based on input bits (d3, d2, d1, d0)
module hex7seg (
    input  logic d3, d2, d1, d0,   // 4-bit input representing a hexadecimal digit (0-F)
    output logic A, B, C, D, E, F, G // 7 output signals for each segment of the display
);
// Segment A - Logic to control segment A based on the 4-bit input
assign A = !(
    (~d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 0
    (~d3 & ~d2 &  d1 & ~d0) | // Case for displaying 2
    (~d3 & ~d2 &  d1 &  d0) | // Case for displaying 3
    (~d3 &  d2 & ~d1 &  d0) | // Case for displaying 5
    (~d3 &  d2 &  d1 & ~d0) | // Case for displaying 6
    (~d3 &  d2 &  d1 &  d0) | // Case for displaying 8
    ( d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 9
    ( d3 & ~d2 & ~d1 &  d0) | // Case for displaying 10 (A)
    ( d3 & ~d2 &  d1 & ~d0) | // Case for displaying 12 (C)
    ( d3 &  d2 & ~d1 & ~d0) | // Case for displaying 13 (D)
    ( d3 &  d2 &  d1 & ~d0) | // Case for displaying 14 (E)
    ( d3 &  d2 &  d1 &  d0)   // Case for displaying 15 (F)
);
// Segment B - Logic to control segment B based on the 4-bit input
assign B = !(
    (~d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 0
    (~d3 & ~d2 & ~d1 &  d0) | // Case for displaying 1
    (~d3 & ~d2 &  d1 & ~d0) | // Case for displaying 2
    (~d3 &  d2 & ~d1 & ~d0) | // Case for displaying 4
    (~d3 &  d2 &  d1 &  d0) | // Case for displaying 7
    ( d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 8
    ( d3 & ~d2 & ~d1 &  d0) | // Case for displaying 9
    ( d3 & ~d2 &  d1 & ~d0) | // Case for displaying 10 (A)
    ( d3 &  d2 & ~d1 &  d0) | // Case for displaying 11 (B)
    (~d3 & ~d2 &  d1 &  d0)   // Case for displaying 3
);
// Segment C - Logic to control segment C based on the 4-bit input
assign C = !(
    (~d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 0
    (~d3 & ~d2 & ~d1 &  d0) | // Case for displaying 1
    (~d3 & ~d2 &  d1 &  d0) | // Case for displaying 3
    (~d3 &  d2 & ~d1 & ~d0) | // Case for displaying 4
    (~d3 &  d2 & ~d1 &  d0) | // Case for displaying 5
    (~d3 &  d2 &  d1 & ~d0) | // Case for displaying 6
    (~d3 &  d2 &  d1 &  d0) | // Case for displaying 7
    ( d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 8
    ( d3 & ~d2 & ~d1 &  d0) | // Case for displaying 9
    ( d3 & ~d2 &  d1 & ~d0) | // Case for displaying 10 (A)
    ( d3 & ~d2 &  d1 &  d0) | // Case for displaying 11 (B)
    ( d3 &  d2 & ~d1 &  d0)   // Case for displaying 13 (D)
);
// Segment D - Logic to control segment D based on the 4-bit input
assign D = !(
    (~d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 0
    (~d3 & ~d2 &  d1 & ~d0) | // Case for displaying 2
    (~d3 & ~d2 &  d1 &  d0) | // Case for displaying 3
    (~d3 &  d2 & ~d1 &  d0) | // Case for displaying 5
    (~d3 &  d2 &  d1 & ~d0) | // Case for displaying 6
    ( d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 8
    ( d3 & ~d2 &  d1 &  d0) | // Case for displaying 11 (B)
    ( d3 &  d2 & ~d1 & ~d0) | // Case for displaying 12 (C)
    ( d3 &  d2 & ~d1 &  d0) | // Case for displaying 13 (D)
    ( d3 &  d2 &  d1 & ~d0) | // Case for displaying 14 (E)
    ( d3 & ~d2 & ~d1 &  d0)   // Case for displaying 1
);
// Segment E - Logic to control segment E based on the 4-bit input
assign E = !(
    (~d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 0
    (~d3 & ~d2 &  d1 & ~d0) | // Case for displaying 2
    (~d3 &  d2 &  d1 & ~d0) | // Case for displaying 6
    ( d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 8
    ( d3 & ~d2 &  d1 & ~d0) | // Case for displaying 10 (A)
    ( d3 & ~d2 &  d1 &  d0) | // Case for displaying 11 (B)
    ( d3 &  d2 & ~d1 & ~d0) | // Case for displaying 12 (C)
    ( d3 &  d2 & ~d1 &  d0) | // Case for displaying 13 (D)
    ( d3 &  d2 &  d1 & ~d0) | // Case for displaying 14 (E)
    ( d3 &  d2 &  d1 &  d0)   // Case for displaying 15 (F)
);
// Segment F - Logic to control segment F based on the 4-bit input
assign F = !(
    (~d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 0
    (~d3 &  d2 & ~d1 & ~d0) | // Case for displaying 4
    (~d3 &  d2 & ~d1 &  d0) | // Case for displaying 5
    (~d3 &  d2 &  d1 & ~d0) | // Case for displaying 6
    ( d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 8
    ( d3 & ~d2 & ~d1 &  d0) | // Case for displaying 9
    ( d3 & ~d2 &  d1 & ~d0) | // Case for displaying 10 (A)
    ( d3 & ~d2 &  d1 &  d0) | // Case for displaying 11 (B)
    ( d3 &  d2 & ~d1 & ~d0) | // Case for displaying 12 (C)
    ( d3 &  d2 &  d1 & ~d0) | // Case for displaying 14 (E)
    ( d3 &  d2 &  d1 &  d0)   // Case for displaying 15 (F)
);
// Segment G - Logic to control segment G based on the 4-bit input
assign G = !(
    (~d3 & ~d2 &  d1 & ~d0) | // Case for displaying 2
    (~d3 & ~d2 &  d1 &  d0) | // Case for displaying 3
    (~d3 &  d2 & ~d1 & ~d0) | // Case for displaying 4
    (~d3 &  d2 & ~d1 &  d0) | // Case for displaying 5
    (~d3 &  d2 &  d1 & ~d0) | // Case for displaying 6
    ( d3 & ~d2 & ~d1 & ~d0) | // Case for displaying 8
    ( d3 & ~d2 & ~d1 &  d0) | // Case for displaying 9
    ( d3 & ~d2 &  d1 & ~d0) | // Case for displaying 10 (A)
    ( d3 & ~d2 &  d1 &  d0) | // Case for displaying 11 (B)
    ( d3 &  d2 &  d1 & ~d0) | // Case for displaying 14 (E)
    ( d3 &  d2 &  d1 &  d0) | // Case for displaying 15 (F)
    ( d3 &  d2 & ~d1 &  d0)   // Case for displaying 13 (D)
);
endmodule
