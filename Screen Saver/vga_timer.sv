// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

// https://vesa.org/vesa-standards/
// http://tinyvga.com/vga-timing
module vga_timer (
    input  logic       clk_i,
    input  logic       rst_ni,
    output logic       hsync_o,
    output logic       vsync_o,
    output logic       visible_o,
    output logic [9:0] position_x_o,
    output logic [9:0] position_y_o
);

// Horizontal signal
logic [9:0] h_d, h_q;

always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        h_q <= 0;
    end else begin
        h_q <= h_d;
    end
end

// hsync
assign hsync_o = (h_q >= 656 && h_q <= 751) ? 1'b0 : 1'b1;
assign position_x_o = h_q;

// Vertical signal
logic [9:0] v_d, v_q;

always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        v_q <= 0;
    end else begin
        v_q <= v_d;
    end
end

// vsync
assign vsync_o = (v_q == 490 || v_q == 491) ? 1'b0 : 1'b1;

always_ff @(posedge clk_i) begin
    if(!rst_ni) begin
        visible_o <= 0;
    end else if(v_d <= 480 && h_d <= 640) begin
        visible_o <= 1;
    end else begin
        visible_o <= 0;
    end
end

always_comb begin
    v_d = v_q;
    h_d = h_q;
    if(h_q == 799) begin
        h_d = 0;
        if(v_q == 524) begin
            v_d = 0;
        end else begin
            v_d = v_d + 1;
        end
    end else begin
        h_d = h_d + 1;
    end
end

assign position_y_o = v_q;

endmodule
