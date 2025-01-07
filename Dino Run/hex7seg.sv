// Copyright (c) 2024 Ethan Sifferman.

// All rights reserved. Distribution Prohibited.


module hex7seg(

    input  logic d3,d2,d1,d0,
    output logic A,B,C,D,E,F,G

);

logic [3:0] digits = {d3, d2, d1, d0};

// TODO

always_comb begin
    case (digits)
        4'h0: {A,B,C,D,E,F,G} = 7'b1000000;
        4'h1: {A,B,C,D,E,F,G} = 7'b1111001;
        4'h2: {A,B,C,D,E,F,G} = 7'b0100100;
        4'h3: {A,B,C,D,E,F,G} = 7'b0110000;
        4'h4: {A,B,C,D,E,F,G} = 7'b0011001;
        4'h5: {A,B,C,D,E,F,G} = 7'b0010010;
        4'h6: {A,B,C,D,E,F,G} = 7'b0000010;
        4'h7: {A,B,C,D,E,F,G} = 7'b1111000;
        4'h8: {A,B,C,D,E,F,G} = 7'b0000000;
        4'h9: {A,B,C,D,E,F,G} = 7'b0010000;
        4'ha: {A,B,C,D,E,F,G} = 7'b0001000;
        4'hb: {A,B,C,D,E,F,G} = 7'b0000011;
        4'hc: {A,B,C,D,E,F,G} = 7'b1000110;
        4'hd: {A,B,C,D,E,F,G} = 7'b0100001;
        4'he: {A,B,C,D,E,F,G} = 7'b0000110;
        4'hf: {A,B,C,D,E,F,G} = 7'b0001110;
        default: {A,B,C,D,E,F,G} = 7'b1111111;
    endcase

end

endmodule
