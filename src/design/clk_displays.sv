module clk_displays(
    input clk,
    input reset,
    output reg clk_display
);
    localparam divisor = 1349;  // Divisor: 27 MHz -> 10 kHz.
    reg [10:0] contador = 0;
    
    always @ (posedge clk)begin
        if(reset) begin
            contador <= 0;
        end else if(contador == divisor) begin
            contador <= 0;
        end else begin
            contador <= contador + 1;
        end
    end
    
    // Divisor de reloj
    always @(posedge clk) begin
        if (reset) begin
            clk_display <= 0;
        end else begin
            if (contador == divisor) begin
                clk_display <= ~clk_display;
            end else begin
                clk_display <= clk_display;
            end
        end
    end
endmodule