// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

module screensaver (
    input  logic       clk_i,
    input  logic       rst_ni,
    input  logic [3:0] image_select_i,  // Renamed to match testbench

    output logic [3:0] vga_red_o,
    output logic [3:0] vga_blue_o,
    output logic [3:0] vga_green_o,
    output logic       vga_hsync_o,
    output logic       vga_vsync_o
);

reg [11:0] pixel;
logic visible;
logic [2:0] img;
logic [9:0] position_x;
logic [9:0] position_y;
logic hsync;
logic vsync;

logic hsync_d;
logic vsync_d;

vga_timer vga_inst(
    .clk_i(clk_i), 
    .rst_ni(rst_ni),
    .hsync_o(hsync), 
    .vsync_o(vsync),
    .position_x_o(position_x), 
    .position_y_o(position_y), 
    .visible_o(visible)
);

always_ff @(posedge clk_i) begin
    if(!rst_ni) begin
        hsync_d <= 0;
        vsync_d <= 0;
    end else begin
        hsync_d <= hsync;
        vsync_d <= vsync;
    end
end

assign vga_hsync_o = hsync_d;
assign vga_vsync_o = vsync_d;

localparam int IMAGE_WIDTH = 160;
localparam int IMAGE_HEIGHT = 120;
localparam int IMAGE_ROM_SIZE = (IMAGE_WIDTH * IMAGE_HEIGHT);

logic [$clog2(IMAGE_ROM_SIZE)-1:0] rom_addr;
assign rom_addr = (position_y[9:2] * 160) + position_x[9:2];

logic [11:0] image0_rdata;
logic [11:0] image1_rdata;
logic [11:0] image2_rdata;
logic [11:0] image3_rdata;

images #(
    .IMAGE_ROM_SIZE(IMAGE_ROM_SIZE)
) images (
    .clk_i,
    .rom_addr_i(rom_addr),
    .image0_rdata_o(image0_rdata),
    .image1_rdata_o(image1_rdata),
    .image2_rdata_o(image2_rdata),
    .image3_rdata_o(image3_rdata)
);

logic [11:0] img_d, img_q;

always_ff @(posedge clk_i) begin
    if(!rst_ni) begin
        img_q <= 0;
    end else begin
        img_q <= img_d;
    end
end

assign img_d = (image_select_i == 1) ? 0 : 
               (image_select_i == 2) ? 1 : 
               (image_select_i == 4) ? 2 : 
               (image_select_i == 8) ? 3 : img_q;

always_comb begin
    if(!visible) begin
        pixel = 0;
    end else begin
        case(img_q)
            0: pixel = image0_rdata;
            1: pixel = image1_rdata;
            2: pixel = image2_rdata;
            3: pixel = image3_rdata;
            default: pixel = 0;
        endcase
    end
end

assign vga_red_o = pixel[11:8];
assign vga_green_o = pixel[7:4];
assign vga_blue_o = pixel[3:0];

endmodule
