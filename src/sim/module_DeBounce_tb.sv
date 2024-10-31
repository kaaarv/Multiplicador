`timescale 1 ns / 100 ps

module module_Debounce_tb;

    // Parámetros y señales
    parameter N = 4;  // Ver en clases cual sirve
    logic clk;
    logic n_reset;
    logic [3:0] key_in;
    logic [3:0] debounced_key;
    logic data_available;


    module_Debounce #(.N(N)) uut (
        .clk(clk),
        .n_reset(n_reset),
        .key_in(key_in),
        .debounced_key(debounced_key),
        .data_available(data_available)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Periodo de 20 ns
    end

    initial begin
        n_reset = 0;
        key_in = 4'b0000;
        #40 n_reset = 1; // Activar el reset
        #100000 key_in = 4'b0001;   // Cambia a 0001 durante 100 ms
        #100000 key_in = 4'b0000;   // Cambia a 0000 durante 100 ms
        #100000 key_in = 4'b0001;   // Cambia a 0001 durante 100 ms
        #100000 key_in = 4'b0100;   // Cambia a 0100 durante 100 ms
        #100000 key_in = 4'b1010;   // Cambia a 1010 durante 100 ms
        #100000 key_in = 4'b0000;   // Cambia a 0000 durante 100 ms
        #400000 $finish;            // Finaliza la simulación
    end

    initial begin
        $monitor("Tiempo=%0t | key_in=%b | debounced_key=%b | data_available=%b", 
                 $time, key_in, debounced_key, data_available);
    end

endmodule
