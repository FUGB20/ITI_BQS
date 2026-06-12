module rom (
    input wire [1:0] Tcount, 
    input wire [2:0] Pcount, 
    output reg [4:0] Wtime  
);


    reg [4:0] rom_table [0:31]; 

    
    integer t, p, i;

    initial begin
        // Initialize all 32 locations to 0 
        for (i = 0; i < 32; i = i + 1) begin
            rom_table[i] = 5'b00000; 
        end

        // Populate only the 24 valid combinations
        for (t = 1; t <= 3; t = t + 1) begin
            for (p = 0; p <= 7; p = p + 1) begin
                if (p == 0) begin
                    rom_table[{t[1:0], p[2:0]}] = 5'b00000;
                end else begin
                    rom_table[{t[1:0], p[2:0]}] = (3 * (p + t - 1)) / t;
                end
            end
        end
    end

    always @(*) begin
        Wtime = rom_table[{Tcount, Pcount}];
    end

endmodule
