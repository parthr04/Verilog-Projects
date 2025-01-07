module dinorun import dinorun_pkg::*; (
    input  logic       clk_25_175_i,
    input  logic       rst_ni,

    input  logic       start_i,
    input  logic       up_i,
    input  logic       down_i,

    output logic       digit0_en_o,
    output logic [3:0] digit0_o,
    output logic       digit1_en_o,
    output logic [3:0] digit1_o,
    output logic       digit2_en_o,
    output logic [3:0] digit2_o,
    output logic       digit3_en_o,
    output logic [3:0] digit3_o,

    output logic [3:0] vga_red_o,
    output logic [3:0] vga_green_o,
    output logic [3:0] vga_blue_o,
    output logic       vga_hsync_o,
    output logic       vga_vsync_o
);
state_t state_d, state_q;

logic lsfr_reset;
logic [15:0] rando;
lfsr16 lfsr16 (
    .clk_i(clk_25_175_i),
    .rst_ni(lsfr_reset),
    .next_i(1'b1),
    .rand_o(rando)
);

logic bird_reset;
logic nextframe_bird;
logic [9:0] vga_px, vga_py;
logic bird_pixel;
bird bird(
    .clk_i(clk_25_175_i),
    .rst_ni(bird_reset),
    .next_frame_i(nextframe_bird),
    .spawn_i(rando[12:7] == 6'b101010),
    .rand_i(rando[0]),
    .pixel_x_i(vga_px),
    .pixel_y_i(vga_py),
    .pixel_o(bird_pixel)
);

logic bird_pixel2;
bird bird2(
    .clk_i(clk_25_175_i),
    .rst_ni(bird_reset),
    .next_frame_i(nextframe_bird),
    .spawn_i(rando[12:7] == 6'b010101),
    .rand_i(rando[0]),
    .pixel_x_i(vga_px),
    .pixel_y_i(vga_py),
    .pixel_o(bird_pixel2)
);

logic cactus_reset;
logic nextframe_cactus;
logic cac_pixel;
cactus cactus(
    .clk_i(clk_25_175_i),
    .rst_ni(cactus_reset),
    .next_frame_i(nextframe_cactus),
    .spawn_i(rando[12:8] == 5'b00000),
    .rand_i(rando[4]),
    .pixel_x_i(vga_px),
    .pixel_y_i(vga_py),
    .pixel_o(cac_pixel)
);

logic dino_reset;
logic nextframe_dino;
logic hit_d, hit_q;
logic dino_pixel;
dino dino(
    .clk_i(clk_25_175_i),
    .rst_ni(dino_reset),
    .next_frame_i(nextframe_dino),
    .up_i(up_i & state_q == RUNNING),
    .down_i(down_i & state_q == RUNNING),
    .hit_i(hit_q),
    .pixel_x_i(vga_px),
    .pixel_y_i(vga_py),
    .pixel_o(dino_pixel)
);

logic title_pixel;
title title(
    .pixel_x_i(vga_px),
    .pixel_y_i(vga_py),
    .pixel_o(title_pixel)
);

logic vga_sync_edge;
edge_detector edge_detector(
    .clk_i(clk_25_175_i),
    .data_i(vga_vsync_o),
    .edge_o(vga_sync_edge)
);

logic score_reset;
logic score_en;
score_counter score_counter(
    .clk_i(clk_25_175_i),
    .rst_ni(score_reset),
    .en_i(score_en),
    .digit0_o(digit0_o),
    .digit1_o(digit1_o),
    .digit2_o(digit2_o),
    .digit3_o(digit3_o)
);

logic vga_visible;
vga_timer vga_timer(
    .clk_i(clk_25_175_i),
    .rst_ni(rst_ni),
    .hsync_o(vga_hsync_o),
    .vsync_o(vga_vsync_o),
    .visible_o(vga_visible),
    .position_y_o(vga_py),
    .position_x_o(vga_px)
);

logic [3:0] vga_red_d, vga_green_d, vga_blue_d;
logic [3:0] vga_red_q, vga_green_q, vga_blue_q;
assign vga_green_o = vga_green_q;
assign vga_blue_o = vga_blue_q;
assign vga_red_o = vga_red_q;
logic freeze_game, freeze_game_d, freeze_game_q;
assign freeze_game = freeze_game_q;
assign freeze_game_d = (!rst_ni) ? 0 : ((state_q == COLLISION) ? 1 : 0);
always_ff @(posedge clk_25_175_i) begin
    if (!rst_ni) begin
        state_q <= state_d;
        vga_red_q <= vga_red_d;
        vga_blue_q <= vga_blue_d;
        vga_green_q <= vga_green_d;
        hit_q <= hit_d;
        freeze_game_q <= freeze_game_d;
    end
    else begin
        state_q <= state_d;
        vga_blue_q <= vga_blue_d;
        vga_green_q <= vga_green_d;
        vga_red_q <= vga_red_d;
        freeze_game_q <= freeze_game_d;
        hit_q <= hit_d;
    end
end

always_comb begin
    state_d = state_q;
    hit_d = hit_q;
    if (!rst_ni) begin
        hit_d = 0;
        state_d = TITLE_SCREEN;
    end
    if (!rst_ni) begin
        vga_red_d = 0;
        vga_blue_d = 0;
        vga_green_d = 0;
    end
    lsfr_reset = rst_ni;
    bird_reset = rst_ni;
    cactus_reset = rst_ni;
    dino_reset = rst_ni;
    score_reset = rst_ni;
    digit0_en_o = 1;
    digit1_en_o = 1;
    digit2_en_o = 1;
    digit3_en_o = 1;
    vga_red_d = 0;
    vga_blue_d = 0;
    vga_green_d = 0;
    nextframe_bird = vga_sync_edge && !freeze_game;
    nextframe_cactus = vga_sync_edge && !freeze_game;
    nextframe_dino = vga_sync_edge && !freeze_game;
    score_en = vga_sync_edge && (state_q == RUNNING) && !freeze_game;
    if (vga_visible) begin
        case (state_q)
            TITLE_SCREEN: begin
                if (vga_py >= 397) begin
                    vga_red_d = 4'b1111;
                    vga_blue_d = 4'b1111;
                    vga_green_d = 4'b1111;
                end
                else begin
                    vga_blue_d = 4'b0000;
                    vga_green_d = 4'b0000;
                    vga_red_d = 4'b0000;
                end

                if (title_pixel) begin
                    vga_red_d = 4'b1111;
                    vga_blue_d = 4'b1111;
                    vga_green_d = 4'b1111;
                end

                if (dino_pixel) begin
                    vga_blue_d = 4'b1111;
                    vga_green_d = 4'b1111;
                    vga_red_d = 4'b1111;
                end

            end

            RUNNING, COLLISION: begin
                if (vga_py >= 397) begin
                    vga_red_d = 4'b1111;
                    vga_blue_d = 4'b1111;
                    vga_green_d = 4'b1111;
                end
                else begin
                    vga_blue_d = 4'b0000;
                    vga_green_d = 4'b0000;
                    vga_red_d = 4'b0000;
                end

                if (bird_pixel) begin
                    vga_blue_d = 4'b1111;
                    vga_green_d = 4'b1111;
                    vga_red_d = 4'b1111;
                end
                if (bird_pixel2) begin
                    vga_blue_d = 4'b1111;
                    vga_green_d = 4'b1111;
                    vga_red_d = 4'b1111;
                end

                if (cac_pixel) begin
                    vga_blue_d = 4'b1111;
                    vga_green_d = 4'b1111;
                    vga_red_d = 4'b1111;
                end

                if (dino_pixel) begin
                    vga_blue_d = 4'b1111;
                    vga_green_d = 4'b1111;
                    vga_red_d = 4'b1111;
                end

            end

            default: begin
                vga_blue_d = 4'h1;
                vga_red_d = 4'h1;
                vga_green_d = 4'h1;
            end

        endcase
    end

    unique case (state_q)

        TITLE_SCREEN: begin
            if (start_i) begin
                state_d = RUNNING;
                lsfr_reset = 0;
                bird_reset = 0;
                cactus_reset = 0;
                dino_reset = 0;
                score_reset = 0;
                hit_d = 0;
            end
        end

        RUNNING: begin
            if (dino_pixel && (bird_pixel || cac_pixel || bird_pixel2)) begin
                hit_d = 1;
                state_d = COLLISION;
            end
        end

        COLLISION: begin
            hit_d = 1;
            if (start_i) begin
                state_d = RUNNING;
                lsfr_reset = 0;
                bird_reset = 0;
                cactus_reset = 0;
                dino_reset = 0;
                score_reset = 0;
                hit_d = 0;
            end
        end

        default: begin
            state_d = TITLE_SCREEN;
        end

    endcase

end

endmodule
