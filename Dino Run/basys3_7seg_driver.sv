// Copyright (c) 2024 Ethan Sifferman.

// All rights reserved. Distribution Prohibited.


module basys3_7seg_driver (

    input              clk_1k_i,

    input              rst_ni,


    input  logic       digit0_en_i,

    input  logic [3:0] digit0_i,

    input  logic       digit1_en_i,

    input  logic [3:0] digit1_i,

    input  logic       digit2_en_i,

    input  logic [3:0] digit2_i,

    input  logic       digit3_en_i,

    input  logic [3:0] digit3_i,


    output logic [3:0] anode_o,

    output logic [6:0] segments_o

);


// TODO


logic [1:0] state_d, state_q;


always_ff @(posedge clk_1k_i) begin

    if(!rst_ni) begin

        state_q <= 0;

    end

    else begin

        state_q <= state_d;

    end

end


assign state_d = state_q + 1;


logic [3:0] digit;


always_comb begin

    anode_o = 4'b1111;

    case (state_q)

        0: begin
            digit = digit0_i;
            anode_o[0] = !digit0_en_i;
        end


        1: begin

            digit = digit1_i;

            anode_o[1] = !digit1_en_i;

        end


        2: begin

            digit = digit2_i;

            anode_o[2] = !digit2_en_i;

        end


        3: begin

            digit = digit3_i;

            anode_o[3] = !digit3_en_i;

        end


        default: begin

            digit = 4'b0000;

            anode_o = 4'b1111;

        end

    endcase

end


logic A,B,C,D,E,F,G;


hex7seg hex7seg(

    .d3(digit[3]),

    .d2(digit[2]),

    .d1(digit[1]),

    .d0(digit[0]),


    .A(A),

    .B(B),

    .C(C),

    .D(D),

    .E(E),

    .F(F),

    .G(G)

);


always_comb begin

    if (anode_o == 4'b1111) begin

        segments_o = 7'b1111111;

    end

    else begin

        segments_o = {A,B,C,D,E,F,G};

    end

end

endmodule


