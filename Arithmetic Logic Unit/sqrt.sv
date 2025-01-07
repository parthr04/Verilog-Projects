module sqrt (
    input  logic [7:0] a_i,
    output logic [7:0] y_o
);

    // Declare a memory array for storing precomputed values
    reg [7:0] sqrt_lookup_table [256];

    // Initialize the memory array with values from the file
    initial begin
        $readmemh("sqrt.memh", sqrt_lookup_table);
    end

    // Assign the output based on the input index
    assign y_o = sqrt_lookup_table[a_i];

endmodule
