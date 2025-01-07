// Copyright (c) 2024 Ethan Sifferman.
// All rights reserved. Distribution Prohibited.
// Top-level module for a game system that involves LED control, a random number generator,
// a countdown timer, and a state machine to manage gameplay states.
module stop_it import stop_it_pkg::*; (
    input  logic        rst_ni,       // Active-low reset signal: resets the entire game
    input  logic        clk_4_i,      // 4 Hz clock input: used as the primary clock for game
    input  logic        go_i,         // Start signal: triggers the game to start counting
    input  logic        stop_i,       // Stop signal
    input  logic        load_i,       // Load signal: used to load switch values into the LEDs
    input  logic [15:0] switches_i,   // 16-bit input from switches: player input for Display
    output logic [15:0] leds_o,       // 16-bit LED output: game status and player feedback
    output logic        digit0_en_o,  // Enable signals for 7-segment display digits
    output logic [3:0]  digit0_o,     // Output for digit 0 (countdown display)
    output logic        digit1_en_o,  // Enable signal for digit 1 (countdown display)
    output logic [3:0]  digit1_o,     // Output for digit 1 (countdown display)
    output logic        digit2_en_o,  // Enable signal for digit 2 (target random display)
    output logic [3:0]  digit2_o,     // Output for digit 2 (target random display)
    output logic        digit3_en_o,  // Enable signal for digit 3 (target random display)
    output logic [3:0]  digit3_o      // Output for digit 3 (target random display)
);
// Internal signals for various operations
logic digit_d, digit_q;                // Flip-flop logic to manage flashing of 7-segment digits
logic [4:0] count;                     // 5-bit count output from game_counter
logic game_counter_en;                 // Enable signal for game_counter, starts countdown
logic game_counter_rst;                // Reset signal for game_counter, resets countdown
// Instantiate game_counter module
// Handles the countdown in the DECREMENTING state of the game
game_counter game_counter (
    .clk_4_i(clk_4_i),                 // Connect to system clock
    .rst_ni(game_counter_rst&&rst_ni),         // Reset signal for game counter
    .en_i(game_counter_en),            // Enable signal for game counter
    .count_o(count)                    // Output count value (displayed on 7-segment display)
);
logic [4:0] random;                    // 5-bit random output from LFSR
logic random_en;                       // Enable signal for LFSR (linear feedback shift register)
// Instantiate LFSR (Linear Feedback Shift Register) module
// Generates a pseudo-random target number in each round
lfsr lfsr (
    .clk_i(clk_4_i),                   // Connect to system clock
    .rst_ni(rst_ni),                   // Connect to system reset
    .next_i(random_en),                // Enable signal to generate the next random number
    .rand_o(random)                    // Output random number (displayed on 7-segment display)
);
logic [5:0] timeCount;                 // 6-bit counter for timing events
logic enable_time;                     // Enable signal for time_counter (controls timing in states)
logic rst_time;                        // Reset signal for time_counter
// Instantiate time_counter module
// Used to track timed events, such as the duration of the STARTING and WRONG states
time_counter time_counter (
    .clk_4_i(clk_4_i),                 // Connect to system clock
    .rst_ni(rst_time),                 // Reset signal for the time counter
    .en_i(enable_time),                // Enable signal to count up when active
    .count_o(timeCount)                // Output time count value used for timed transitions
);
logic [15:0] leds_q;                   // Holds the current state of LEDs for display
logic [5:0] wins_d, wins_q;            // Counters for tracking player wins
logic leds_off;                        // Signal to turn all LEDs off
logic leds_shift;                      // Signal to shift LED pattern
logic leds_flash;                      // Signal to flash LEDs
// Instantiate led_shifter module
// Manages LED pattern shifts and flashing to give feedback to the player
led_shifter led_shifter (
    .clk_i(clk_4_i),                   // Connect to system clock
    .rst_ni(rst_ni),                   // Connect to system reset
    .shift_i(leds_shift),              // Enable signal for shifting LEDs
    .switches_i(switches_i),           // Load values from switches
    .load_i(load_i),                   // Signal to load switch values into LEDs
    .off_i(leds_off),                  // Control signal to turn off LEDs
    .leds_o(leds_q)                    // LED output to represent game state or player input
);
// State machine declaration to manage game states
state_t state_d, state_q;
always_ff @(posedge clk_4_i) begin
    if (!rst_ni) begin
        state_q <= WAITING_TO_START;   // Default state when reset is active
        wins_q <= 0;                   // Reset win count to zero on reset
    end else begin
        state_q <= state_d;            // Update current state to next state
        wins_q <= wins_d;              // Update win count
    end
end
// Flash control for 7-segment display digits
logic flash;
assign digit_d = (flash) ? !digit_q : digit_q; // Toggles digit when flash signal is active

// Flip-flop to control flashing of digit enable signals
always_ff @(posedge clk_4_i) begin
    if (!rst_ni) begin
        digit_q <= 1;                  // Default state of digit when reset is active
    end else begin
        digit_q <= digit_d;            // Update digit state to next digit state
    end
end

// LED Off control logic
logic off_d, off_q;
assign off_d = (leds_flash) ? !off_q : off_q; // Toggles off signal when LEDs need to flash
// Flip-flop to control the off state of LEDs for flashing effect
always_ff @(posedge clk_4_i) begin
    if (!rst_ni) begin
        off_q <= 0;                    // Default LED state when reset is active
    end else begin
        off_q <= off_d;                // Update off state to next off state
    end
end

assign leds_off = off_q;               // Connect the off state to control LED display
// Assign outputs to display the count and random values on the 7-segment displays
assign digit0_o = count[3:0];          // Display the lower 4 bits of count on digit 0
assign digit1_o = {3'b000, count[4]};  // Display the MSB of count on digit 1
assign digit2_o = random[3:0];         // Display the lower 4 bits of random number on digit 2
assign digit3_o = {3'b000, random[4]}; // Display the MSB of random number on digit 3

// State machine logic for managing gameplay flow
always_comb begin
    // Default control signal values for each state
    state_d = state_q;                 // Default: stay in current state
    leds_flash = 0;
    rst_time = 0;
    enable_time = 0;
    leds_shift = 0;
    game_counter_en = 0;
    flash = 0;
    game_counter_rst = 1;
    random_en = 0;
    wins_d = wins_q;
    digit0_en_o = 1;
    digit1_en_o = 1;
    digit2_en_o = 1;
    digit3_en_o = 1;
    unique case (state_q)
        WAITING_TO_START: begin
            // Initial state, waiting for player to start the game
            random_en = 1;              // Enable random number generation
            digit0_en_o = 1;
            digit1_en_o = 1;
            digit2_en_o = 0;
            digit3_en_o = 0;
            if (go_i) begin
                // Transition to STARTING when player presses go
                state_d = STARTING;
            end
        end
        STARTING: begin
            game_counter_rst = 0;       // Reset the game counter
            // Game starting, begin timing countdown
            rst_time = 1;               // Reset the timer
            enable_time = 1;            // Enable timer to start counting
            digit0_en_o = 1;
            digit1_en_o = 1;
            digit2_en_o = 1;
            digit3_en_o = 1;
            if (timeCount == 7) begin
                // After time count reaches threshold, transition to DECREMENTING
                state_d = DECREMENTING;
            end
        end
        DECREMENTING: begin
            // Countdown state
            game_counter_rst = 1;       // Keep counter reset disabled
            game_counter_en = 1;        // Enable the game counter to start counting down
            digit0_en_o = 1;
            digit1_en_o = 1;
            digit2_en_o = 1;
            digit3_en_o = 1;
            if (stop_i) begin
                // Player stops countdown
                game_counter_en = 0;    // Disable counter

                if (count == random) begin
                    // If player’s count matches random, move to CORRECT state
                    state_d = CORRECT;
                end else begin
                    // If player’s count doesn’t match, move to WRONG state
                    state_d = WRONG;
                end
            end
        end
        WRONG: begin
            // Indicate incorrect guess to player
            rst_time = 1;               // Reset the timer for a delay
            enable_time = 1;            // Enable the timer
            flash = 1;                  // Enable digit flashing
            digit0_en_o = digit_d;      // Flash all display digits
            digit1_en_o = digit_d;
            digit2_en_o = digit_q;
            digit3_en_o = digit_q;
            if (timeCount == 15) begin
                // After delay, reset to initial state
                state_d = WAITING_TO_START;
            end
        end
        CORRECT: begin
            // Indicate correct guess to player
            rst_time = 1;
            enable_time = 1;
            flash = 1;                  // Enable digit flashing
            digit0_en_o = digit_q;
            digit1_en_o = digit_q;
            digit2_en_o = digit_q;
            digit3_en_o = digit_q;
            if (timeCount == 15) begin
                // After delay, increase win count
                wins_d = wins_q + 1;
                leds_shift = 1;         // Shift LED pattern for win feedback
                if ((leds_o[15])) begin
                    // If maximum wins, transition to WON state
                    state_d = WON;
                end else begin
                    // Otherwise, return to start state
                    state_d = WAITING_TO_START;
                end
            end
        end
        WON: begin
            // Winning state with flashing LEDs
            digit0_en_o = 1;
            digit1_en_o = 1;
            digit2_en_o = 1;
            digit3_en_o = 1;
            leds_flash = 1;             // Flash LEDs to indicate player has won the game
            if (!rst_ni) begin
                // If reset, return to initial state
                state_d = WAITING_TO_START;
            end
        end
        default: begin
            // Default state is WAITING_TO_START
            state_d = WAITING_TO_START;
        end
    endcase
end
assign leds_o = leds_q;                // Connect LED output to the current LED state
endmodule
