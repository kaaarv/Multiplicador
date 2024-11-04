`timescale 1 ns / 100 ps

module module_Debounce_tb;

    // Señales de entrada y salida
    logic clk;
    logic [3:0] filas_in;
    logic enable;

    // Instanciación del módulo de debounce
    module_Debounce uut (
        .clk(clk),
        .filas_in(filas_in),
        .enable(enable)
    );

    // Generador de reloj (1 kHz -> 1000 ns por ciclo)
    always #500 clk = ~clk;

    initial begin
        // Inicialización de señales
        clk = 0;
        filas_in = 4'b1111;
        
        // Generación de un rebote en la señal `filas_in`
        // Cambios rápidos de estado para simular ruido de rebote
        #1000 filas_in = 4'b1110;    // Primer cambio
        #1000 filas_in = 4'b1111;    // Vuelve al estado inicial
        #1000 filas_in = 4'b1110;    // Rebote
        #1000 filas_in = 4'b1111;    // Vuelve al estado inicial
        #1000 filas_in = 4'b1110;    // Cambio de nuevo
        #10000 filas_in = 4'b1110;   // Mantiene el estado para estabilizar

        // Después de mantener `filas_in` estable, `enable` debería activarse
        #20000 $finish;                // Fin de la simulación
    end

    // Monitor para observar los cambios en el tiempo
    initial begin
        $monitor("Time=%0t | clk=%b | filas_in=%b | enable=%b",
                 $time, clk, filas_in, enable);
    end

    initial begin
        $dumpfile("module_Debounce_tb.vcd");
        $dumpvars(0, module_Debounce_tb);
    end
endmodule
