// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.

package dinorun_pkg;

localparam int ScreenWidth = 640;
localparam int ScreenHeight = 480;

localparam int Ground = 400;
localparam int ObstacleInitialX = 640;

typedef enum logic [1:0] {
    // TODO
    TITLE_SCREEN = 2'b00,
    RUNNING =  2'b01,
    COLLISION = 2'b10
} state_t;


endpackage
