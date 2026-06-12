module seperator (
    input wire [4:0] binary_in, // Wtime (max 21)
    output reg [3:0] tens,
    output reg [3:0] ones
);

    always @(*) begin
        tens = binary_in / 10; // Extracts the tens column
        ones = binary_in % 10; // Extracts the remainder (ones column)
    end

endmodule
