// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module muladd import muladd_pkg::*; (
    input  logic       clk_i,
    input  logic       rst_ni,

    output logic       in_ready_o,
    input  logic       in_valid_i,
    input  logic [7:0] a_i, b_i, c_i,

    output logic [7:0] prodsum_o,
    input  logic       prodsum_ready_i,
    output logic       prodsum_valid_o
);

// Multiplication logic
logic [7:0] prod;
logic       prod_valid;
wire prod_eq_0 = (prod_valid && prod == 0);

mul mul (
    .clk_i,
    .rst_ni,

    .in_valid_i(in_valid_i && in_ready_o),
    .a_i(a_i),
    .b_i(b_i),

    .prod_o(prod),
    .prod_valid_o(prod_valid)
);

// Addition logic
logic [7:0] sum;
logic [7:0] c_d, c_q;

add add (
    .clk_i,
    .a_i(prod),
    .b_i(c_q),
    .sum_o(sum)
);

assign c_d = (in_valid_i && in_ready_o) ? c_i : c_q;
wire c_eq_0 = (c_q == 0);

always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        c_q <= 0;
    end else begin
        c_q <= c_d;
    end
end

// State machine logic
state_t state_d, state_q; // Use the enum from muladd_pkg

always_comb begin
    // Default assignments
    state_d = state_q;
    in_ready_o = 0;
    prodsum_valid_o = 0;
    prodsum_o = 0;

    case (state_q)
        IDLE: begin
            in_ready_o = 1;
            if (in_valid_i && in_ready_o) begin
                state_d = MUL;
            end
        end
        MUL: begin
            if (prod_valid) begin
                if (prod_eq_0) begin
                    prodsum_o = c_q;
                    prodsum_valid_o = 1;
                    if (prodsum_ready_i) state_d = IDLE;
                end else if (c_eq_0) begin
                    prodsum_o = prod;
                    prodsum_valid_o = 1;
                    if (prodsum_ready_i) state_d = IDLE;
                end else begin
                    state_d = ADD;
                end
            end
        end
        ADD: begin
            prodsum_o = sum;
            prodsum_valid_o = 1;
            if (prodsum_ready_i) begin
                state_d = IDLE;
            end
        end
        default: state_d = IDLE;
    endcase
end

always_ff @(posedge clk_i) begin
    if (!rst_ni) begin
        state_q <= IDLE;
    end else begin
        state_q <= state_d;
    end
end

endmodule
