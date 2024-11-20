`timescale 1 ns / 100 ps

module Top_module_tb;

    // Señales de testbench
    logic clk;
    logic rst;
    logic [3:0] key_in;

    logic data_available;
    logic [3:0] dato_o;
    
    // Instancia del módulo `Top_module`
    Top_module DUT (
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .data_available(data_available),
        .dato_o(dato_o)
    );

    // Generación de reloj principal a 27 MHz
    initial begin
        clk = 0;
        forever #18.5 clk = ~clk;  // Periodo de 37 ns (aprox. 27 MHz)
    end

    // Proceso de simulación
    initial begin
        // Inicialización
        rst = 0;
        key_in = 4'b1111; // Sin teclas presionadas al inicio
        
        // Activación de reset
        #100 rst = 1;
        
        // Simulación de presiones de teclas en `key_in`
        repeat (3) begin
            // Primera tecla presionada - Fila 1
            key_in = 4'b1110;  // Simula la activación de la fila 1
            #200000;            // Espera de tiempo para procesar

            // Segunda tecla presionada - Fila 2
            key_in = 4'b1101;  // Simula la activación de la fila 2
            #200000;

            // Tercera tecla presionada - Fila 3
            key_in = 4'b1011;  // Simula la activación de la fila 3
            #200000;

            // Cuarta tecla presionada - Fila 4
            key_in = 4'b0111;  // Simula la activación de la fila 4
            #200000;

            // Regresar a sin teclas presionadas
            key_in = 4'b1111;
            #50000;  // Pausa entre ciclos
        end

        // Finalizar simulación
        $finish;
    end

    // Monitoreo de salidas
    initial begin
        $monitor("Time=%0t | rst=%b | key_in=%b | data_available=%b | dato_o=%h",
                 $time, rst, key_in, data_available, dato_o);
    end

    initial begin
        $dumpfile("Top_module_tb.vcd");
        $dumpvars(0, Top_module_tb);
    end

endmodule
