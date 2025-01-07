module flog2 (
    input  logic [7:0] a_i,
    output logic [7:0] y_o
);

    // Continuous assignment using ternary operators to replicate the logic of the if-else ladder
    assign y_o = (a_i[7] ? 7 :
                  a_i[6] ? 6 :
                  a_i[5] ? 5 :
                  a_i[4] ? 4 :
                  a_i[3] ? 3 :
                  a_i[2] ? 2 :
                  a_i[1] ? 1 : 0);

endmodule
