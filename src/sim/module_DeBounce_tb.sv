`timescale 1 ns / 100 ps


module module_DeBounce_tb;
    // Parámetros de simulación
    parameter CLK_PERIOD = 20; // Período del reloj en ns
    parameter SIM_DURATION = 500; // Duración de la simulación en ns

    // Señales del testbench
    logic clk;
    logic n_reset;
    logic button_in;
    logic DB_out;

    // Instancia del módulo DeBounce
    module_DeBounce uut (
        .clk(clk),
        .n_reset(n_reset),
        .button_in(button_in),
        .DB_out(DB_out)
    );

    // Generador de reloj
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; // Cambia el reloj cada medio período
    end

    // Proceso de test
initial begin
    // Inicialización
    n_reset = 0;
    button_in = 0;
    #100; // Esperar 100 ns para el reset

    n_reset = 1; // Desactivar el reset
    #100; // Esperar estabilización

    button_in = 1; // Pulsar el botón
    #5000; // Mantener presionado el botón por un tiempo más largo

    button_in = 0; // Soltar el botón
    #5000; // Esperar y observar el estado

    button_in = 1; // Pulsar el botón de nuevo
    #5000; // Mantener presionado
    button_in = 0; // Soltar el botón
    #5000; // Esperar y observar

    // Detener la simulación
    $stop;
end


    // Monitor para observar señales
    initial begin
    $monitor("Time: %0t | n_reset: %b | button_in: %b | DB_out: %b | q_reg: %b", 
             $time, n_reset, button_in, DB_out, uut.q_reg);
end

endmodule
